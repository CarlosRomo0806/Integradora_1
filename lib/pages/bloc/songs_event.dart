part of 'songs_bloc.dart';

@immutable
abstract class SongsEvent extends Equatable {
  const SongsEvent();

  @override
  List<Object> get props => [];
}

class SongsUpdate extends SongsEvent {}
