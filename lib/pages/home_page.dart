// ignore_for_file: unused_field, prefer_typing_uninitialized_variables, unused_import

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:integradora_1/pages/fav_songs/provider/fav_provider.dart';
import 'package:integradora_1/pages/fav_songs/fav_page.dart';
import 'package:integradora_1/pages/final_data.dart';

import 'bloc/songs_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _listenStatus = 'Reconoce la canción que estas escuchando';
  bool _animation = false;
  bool pressed = false;
  var _iconColor = Colors.white;
  var _song, _artist, _album, _date, _apple, _spotify, _cover, _link;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 14, 44, 71),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: BlocConsumer<SongsBloc, SongsState>(
          listener: (context, state) {
            if (state is SongsSuccess) {
              // ignore: avoid_print
              print('Funciona $state');
              _song = state.song;
              _artist = state.artist;
              _album = state.album;
              _date = state.date;
              _apple = state.apple;
              _spotify = state.spotify;
              _cover = state.image;
              _link = state.link;

              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => FinalData(
                    song: {
                      "songName": _song,
                      "artistName": _artist,
                      "albumName": _album,
                      "releaseDate": _date,
                      "appleLink": _apple,
                      "spotifyLink": _spotify,
                      "albumCover": _cover,
                      "listenLink": _link,
                    },
                    isFavorite: false,
                  ),
                ),
              );
              _animation = false;
              _listenStatus = 'Reconoce la canción que estas escuchando';
              _iconColor = Colors.white;
            } else if (state is SongsFailure) {
              _animation = false;
              _listenStatus = 'Reconoce la canción que estas escuchando';
              _iconColor = Colors.white;
              ScaffoldMessenger.of(context)
                ..removeCurrentSnackBar()
                ..showSnackBar(
                  const SnackBar(
                    content: Text(
                        "No se pudo reconocer la canción, vuelve a intentarlo."),
                    backgroundColor: Color.fromARGB(255, 131, 40, 33),
                  ),
                );
            } else if (state is SongsEnded) {
              _animation = true;
              _listenStatus = 'Buscando la rola...';
              _iconColor = Color.fromARGB(255, 0, 68, 255);
              // ignore: avoid_print
              print('$state');
            } else if (state is SongsRecognition) {
              // ignore: avoid_print
              print('$state');
              _animation = true;
              _listenStatus = 'Escuchando...';
              _iconColor = Color.fromARGB(255, 0, 68, 255);
            } else if (state is SongsInitial) {
              // ignore: avoid_print
              print('$state');
            } else if (state is SongsVal) {
              // ignore: avoid_print
              print("$state");
              _animation = false;
              _listenStatus = "Reconoce la canción que estas escuchando";
              _iconColor = Colors.white;
              ScaffoldMessenger.of(context)
                ..removeCurrentSnackBar()
                ..showSnackBar(
                  const SnackBar(
                    content: Text("La canción no se pudo encontrar, intente de nuevo..."),
                    backgroundColor: Colors.red,
                  ),
                );
            } else {
              _animation = false;
              _listenStatus = "Reconoce la canción que estas escuchando";
            }
          },
          builder: (context, state) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  _listenStatus,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                AvatarGlow(
                  endRadius: 200.0,
                  animate: _animation,
                  glowColor: Color.fromARGB(255, 0, 68, 255),
                  child: GestureDetector(
                    onTap: () {
                      pressed = true;
                      BlocProvider.of<SongsBloc>(context)
                          .add(SongsUpdate());
                    },
                    child: Material(
                      shape: const CircleBorder(),
                      elevation: 8,
                      child: Container(
                        padding: const EdgeInsets.all(40),
                        height: 200,
                        width: 200,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color.fromARGB(255, 36, 37, 134),
                        ),
                        child: Image.asset(
                          'assets/images/clave_sol.png',
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const FavPage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    backgroundColor: Colors.white,
                  ),
                  child: const Icon(
                    Icons.favorite,
                    color: Colors.black,
                  ),
                ),
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const FavPage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                    ),
                    child: const Text(
                      'Tus canciones Favoritas',
                      style: TextStyle(color: Colors.black),
                    ))
              ],
            );
          },
        ),
      ),
    );
  }
}
