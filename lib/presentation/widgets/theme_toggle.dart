import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/theme/theme_bloc.dart';
import '../bloc/theme/theme_event.dart';
import '../bloc/theme/theme_state.dart';

class ThemeToggle extends StatelessWidget {
  const ThemeToggle({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        return IconButton(
          onPressed: () {
            context.read<ThemeBloc>().add(const ThemeToggled());
          },
          icon: Icon(
            state.isDarkMode ? Icons.light_mode : Icons.dark_mode,
          ),
          tooltip: state.isDarkMode ? 'Light mode' : 'Dark mode',
        );
      },
    );
  }
}
