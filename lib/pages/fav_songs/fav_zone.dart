import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:integradora_1/pages/fav_songs/provider/fav_provider.dart';
import 'package:integradora_1/pages/fav_songs/fav_items.dart';

class FavSection extends StatelessWidget {
  const FavSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 7, 88, 102),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: context.watch<FavProvider>().getFavSong.length,
              itemBuilder: (BuildContext context, int index) {
                return FavItems(
                    favoriteItem:
                        context.read<FavProvider>().getFavSong[index]);
              },
            ),
          )
        ],
      ),
    );
  }
}
