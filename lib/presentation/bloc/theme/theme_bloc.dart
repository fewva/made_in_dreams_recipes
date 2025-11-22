import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/datasources/local_data_source.dart';
import 'theme_event.dart';
import 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final LocalDataSource _localDataSource;

  ThemeBloc({required LocalDataSource localDataSource})
      : _localDataSource = localDataSource,
        super(const ThemeInitial(false)) {
    on<ThemeLoaded>(_onThemeLoaded);
    on<ThemeToggled>(_onThemeToggled);
  }

  Future<void> _onThemeLoaded(
    ThemeLoaded event,
    Emitter<ThemeState> emit,
  ) async {
    emit(ThemeInitial(event.isDarkMode));
  }

  Future<void> _onThemeToggled(
    ThemeToggled event,
    Emitter<ThemeState> emit,
  ) async {
    final currentIsDark = state.isDarkMode;
    final newIsDark = !currentIsDark;
    
    // Save to local storage
    await _localDataSource.saveTheme(newIsDark);
    
    emit(ThemeChanged(newIsDark));
  }

  Future<void> loadTheme() async {
    final isDarkMode = await _localDataSource.getTheme();
    add(ThemeLoaded(isDarkMode));
  }
}
