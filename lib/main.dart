import 'package:alarm/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'components/alarm/alarm_bloc.dart';
import 'screen/home.dart';
import '../theme/theme_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const AlarmApp());
}

class AlarmApp extends StatelessWidget {
  const AlarmApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(create: (context) => ThemeCubit()),
        BlocProvider(create: (_) => AlarmBloc()..add(AlarmStarted())),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            title: 'Alarm App',
            debugShowCheckedModeBanner: false,
            theme: themeData(context),
            darkTheme: darkThemeData(context),
            themeMode:
                (state is ThemeIsLight) ? ThemeMode.light : ThemeMode.dark,
            home: Home(
              alarmBloc: context.read<AlarmBloc>(),
            ),
          );
        },
      ),
    );
  }
}
