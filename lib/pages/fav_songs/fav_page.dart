import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:integradora_1/pages/fav_songs/provider/fav_provider.dart';
import 'package:integradora_1/pages/fav_songs/fav_zone.dart';

class FavPage extends StatefulWidget {
  const FavPage({super.key});

  @override
  State<FavPage> createState() => _FavPageState();
}

class _FavPageState extends State<FavPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 11, 104, 121),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 11, 104, 121),
        title: const Text(
          'Canciones favoritas',
          style: TextStyle(color: Color.fromARGB(255, 255, 242, 242)),
        ),
      ),
      body: context.watch<FavProvider>().getFavSong.isNotEmpty
          ? const FavSection()
          : _noFavoriteItems(),
    );
  }
}

Column _noFavoriteItems() {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text(
            "Aún no has agregado canciones favoritas",
            style: TextStyle(fontSize: 10),
          ),
        ],
      ),
    ],
  );
}
