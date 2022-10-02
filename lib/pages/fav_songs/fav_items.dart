import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:integradora_1/pages/fav_songs/provider/fav_provider.dart';
import 'package:integradora_1/pages/final_data.dart';

class FavItems extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final favoriteItem;
  const FavItems({
    super.key,
    this.favoriteItem,
  });

  @override
  State<FavItems> createState() => _FavItemsState();
}

class _FavItemsState extends State<FavItems> {
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => FinalData(
                    song: widget.favoriteItem,
                    isFavorite: true,
                  )),
        );
      },
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(10),
        height: 300,
        width: 300,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                  height: 300,
                  width: 300,
                  alignment: Alignment.center,
                  "${widget.favoriteItem["albumCover"]}"),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                  icon: const Icon(Icons.favorite),
                  onPressed: () => showDialog(
                        context: context,
                        builder: (context) => _deleteAlert(context),
                      )),
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 175, 76, 158).withOpacity(0.7),
                    borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(25.0),
                        bottomRight: Radius.circular(8.0),
                        bottomLeft: Radius.circular(8.0)),
                  ),
                  width: 300,
                  child: Column(
                    children: [
                      Text(
                        "${widget.favoriteItem["songName"]}",
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text("${widget.favoriteItem["artistName"]}")
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }



  AlertDialog _deleteAlert(BuildContext context) {
    return AlertDialog(
      title: const Text("Eliminar de tus favoritas"),
      content: const Text(
          "¿Quieres eliminar esta canción de tus favoritas?"),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("Cancelar"),
        ),
        TextButton(
          onPressed: () {
            context.read<FavProvider>().removeFavoriteSong(widget.favoriteItem);
            Navigator.of(context).pop();
          },
          child: const Text("Eliminar"),
        )
      ],
    );
  }
}
