// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import 'package:record/record.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'dart:io';

part 'songs_event.dart';
part 'songs_state.dart';

class SongsBloc extends Bloc<SongsEvent, SongsState> {
  SongsState get initialState => SongsInitial();
  SongsBloc() : super(SongsInitial()) {
    on<SongsEvent>((_findSong));
  }
  
  get key => null;

  void _findSong(SongsEvent event, Emitter emit) async {
    final tmpP = await _getTempPath();
    final fileP = await recordAudio(tmpP, emit);
    print("File path: $fileP");
    File file = File(fileP!);
    String stringFile = await Convertion(file);
    var json = await _Response(stringFile);
    print("JSON: $json");

    if (json == null || json["result"] == null) {
      emit(SongsFailure());
    } else {
      try {
        final String song = json['result']['title'];
        final String artist = json['result']['artist'];
        final String album = json['result']['album'];
        final String date = json['result']['release_date'];
        final String apple = json['result']['apple_music']['url'];
        final String spotify =
            json['result']['spotify']['external_urls']['spotify'];
        final String image =
            json['result']['spotify']['album']['images'][0]['url'];
        final String link = json['result']['song_link'];

        emit(
          SongsSuccess(
            song: song,
            artist: artist,
            album: album,
            date: date,
            apple: apple,
            spotify: spotify,
            image: image,
            link: link,
          ),
        );
      } catch (e) {
        print("Error: $e");
        emit(SongsVal());
      }
    }
  }

  Future<String> _getTempPath() async {
    Directory tempDirect = await getTemporaryDirectory();
    return tempDirect.path;
  }

  Future<String> Convertion(File file) async {
  List<int> fileBytes = await file.readAsBytes();
  String base = base64Encode(fileBytes);
  return base;
}

  Future _Response(String file) async {
    emit(SongsEnded());
    http.Response response = await http.post(
      Uri.parse('https://api.audd.io/'),
      headers: {'Content-Type': 'multipart/form-data'},
      body: jsonEncode(
        <String, dynamic>{
          // 'api_token': '14ca28f87aaa2f7a0e178d2cea8a4ca3',
          'api_token': key,
          'return': 'apple_music,spotify',
          'audio': file,
          'method': 'recognize',
        },
      ),
    );
    if (response.statusCode == 200) {
      print("Success");
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load json');
    }
  }

  Future<String?> recordAudio(String tmpP, Emitter<dynamic> emit) async {
    final Record _record = Record();
    try {
      bool permission = await _record.hasPermission();
      print("Permission: $permission");
      if (permission) {
        emit(SongsRecognition());
        await _record.start(
          path: '${tmpP}/test.m4a',
          encoder: AudioEncoder.aacLc,
          bitRate: 128000,
          samplingRate: 44100,
        );
        await Future.delayed(const Duration(seconds: 7));
        return await _record.stop();
      } else {
        emit(SongsFailure());
        print("Permission denied");
      }
    } catch (e) {
      print(e);
    }
    return null;
  }
}



