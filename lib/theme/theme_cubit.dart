import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeIsLight());

  /// Toggles the current brightness between light and dark.
  void toggleTheme() {
    emit(state is ThemeIsLight ? ThemeIsDark() : ThemeIsLight());
    // emit(state.brightness == Brightness.dark ? _lightTheme : _darkTheme);
  }
}
