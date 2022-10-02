import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'pages/bloc/songs_bloc.dart';
import 'pages/home_page.dart';
import 'pages/fav_songs/provider/fav_provider.dart';

void main(){ runApp(
    BlocProvider(
      create: (context) => SongsBloc(),
      child: ChangeNotifierProvider(
        create: (context) => FavProvider(),
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music App',
      theme: ThemeData(
        colorScheme: const ColorScheme.dark(),
      ),
      home: const HomePage(),
    );
  }
}