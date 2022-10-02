import 'package:flutter/cupertino.dart';

class FavProvider with ChangeNotifier {
  final List<dynamic> _favoriteSongs = [];

  List<dynamic> get getFavSong => _favoriteSongs;

  void addFavoriteSong(dynamic song) {
    _favoriteSongs.add(song);
    notifyListeners();
  }

  void removeFavoriteSong(dynamic song) {
    _favoriteSongs.remove(song);
    notifyListeners();
  }
}