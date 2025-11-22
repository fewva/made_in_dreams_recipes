import 'package:equatable/equatable.dart';

abstract class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object?> get props => [];
}

class ThemeToggled extends ThemeEvent {
  const ThemeToggled();
}

class ThemeLoaded extends ThemeEvent {
  final bool isDarkMode;

  const ThemeLoaded(this.isDarkMode);

  @override
  List<Object?> get props => [isDarkMode];
}
