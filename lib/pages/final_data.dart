import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:integradora_1/pages/fav_songs/provider/fav_provider.dart';

class FinalData extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final song;
  final bool isFavorite;
  const FinalData({
    super.key,
    this.song,
    required this.isFavorite,
  });

  @override
  // ignore: no_logic_in_create_state
  State<FinalData> createState() => _FinalDataState(
        song,
        isFavorite,
      );
}

// ignore: no_leading_underscores_for_local_identifiers
Future<void> _launchUrl(_url) async {
  _url = Uri.parse(_url);
  if (!await launchUrl(_url)) {
    throw 'No se pudo inicializar $_url';
  }
}

class _FinalDataState extends State<FinalData> {
  final Map<dynamic, dynamic> _song;
  bool _isFavorite;
  _FinalDataState(this._song, this._isFavorite);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff042442),
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              //show favourite confirmation dialog
              showDialog(
                context: context,
                builder: (context) {
                  if (_isFavorite) {
                    //AlertDialog to delete or add to favorites list
                    return _alertDialog(
                        context,
                        "Remover de tus favoritas",
                        "¿Quieres eliminar esta canción de tus favoritas?",
                        "Eliminar",
                        true);
                  } else {
                    return _alertDialog(
                        context,
                        "Añadir a tu playlist de Favoritas",
                        "¿Quieres añadir esta canción a tus favoritas?",
                        "Añadir",
                        false);
                  }
                },
              );
            },
            icon: _isFavorite
                ? const Icon(Icons.favorite)
                : const Icon(Icons.favorite_border),
          ),
        ],
        title: const Text(
          "Here you go",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xff042442),
      ),
      body: Container(
        alignment: Alignment.center,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.network("${widget.song["albumCover"]}"),
            const SizedBox(height: 20),
            Text("${widget.song["songName"]}",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center),
            const SizedBox(height: 5),
            Text("${widget.song["artistName"]}",
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center),
            const SizedBox(height: 5),
            Text(
              "${widget.song["albumName"]}",
              style: const TextStyle(
                fontSize: 15,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 5),
            Text(
              "${widget.song["releaseDate"]}",
              style: const TextStyle(
                fontSize: 15,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const Divider(
              height: 30,
              thickness: 1,
              indent: 20,
              endIndent: 20,
              color: Colors.white,
            ),
            const Text(
              "Abrir con:",
              style: TextStyle(
                fontSize: 13,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  iconSize: 40,
                  onPressed: () {
                    _launchUrl("${widget.song["spotifyLink"]}");
                  },
                  icon: Image.asset(
                    'assets/images/spotify.png',
                    height: 30,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  iconSize: 40,
                  onPressed: () {
                    _launchUrl("${widget.song["listenLink"]}");
                  },
                  icon: const Icon(Icons.podcasts_rounded),
                  color: Colors.white,
                ),
                IconButton(
                  iconSize: 40,
                  onPressed: () {
                    _launchUrl("${widget.song["appleLink"]}");
                  },
                  icon: const Icon(Icons.apple),
                  color: Colors.white,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  AlertDialog _alertDialog(BuildContext context, String title, String message,
      String actions, bool isNotFavorite) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("Cancelar"),
        ),
        TextButton(
          onPressed: () {
            if (isNotFavorite) {
              _isFavorite = false;
              setState(() {});
              context.read<FavProvider>().removeFavoriteSong(_song);
            } else {
              _isFavorite = true;
              setState(() {});
              context.read<FavProvider>().addFavoriteSong(_song);
            }
            Navigator.of(context).pop();
          },
          child: Text(actions),
        )
      ],
    );
  }
}
