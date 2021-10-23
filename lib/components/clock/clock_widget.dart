import 'dart:async';

import 'package:alarm/components/clock/clock_painter.dart';
import 'package:alarm/theme/theme.dart';
import 'package:alarm/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../theme/theme_cubit.dart';

class ClockWidget extends StatefulWidget {
  const ClockWidget({Key? key}) : super(key: key);

  @override
  State<ClockWidget> createState() => _ClockWidgetState();
}

class _ClockWidgetState extends State<ClockWidget> {
  DateTime _dateTime = DateTime.now();
  Timer? _timer;
  String? _formattedTime;
  String? _formattedDate;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      _dateTime = _dateTime.add(const Duration(seconds: 1));
      _formattedTime = DateFormat('HH:mm').format(_dateTime);
      _formattedDate = DateFormat('EEE, d MMMM').format(_dateTime);
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'O\'Clock',
                style: headlineTextStyle,
              ),
              InkWell(
                borderRadius: BorderRadius.circular(50),
                child: const Icon(Icons.bedtime_outlined),
                onTap: () => {
                  BlocProvider.of<ThemeCubit>(context).toggleTheme(),
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              clockView(context),
              const SizedBox(width: 30),
              clockText(),
            ],
          ),
        ],
      ),
    );
  }

  Widget clockView(BuildContext context) {
    return SizedBox(
      width: 150,
      height: 150,
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: <BoxShadow>[
              BoxShadow(
                offset: const Offset(0, 0),
                color: Colors.grey.withOpacity(0.14),
                blurRadius: 1,
              ),
            ],
          ),
          child: CustomPaint(
            painter: ClockPainter(context, _dateTime),
          ),
        ),
      ),
    );
  }

  Widget clockText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          _formattedTime ?? '',
          style: headlineTextStyle.copyWith(
              fontSize: 36, fontWeight: FontWeight.w500),
        ),
        Text(
          _formattedDate ?? '',
          style: primaryTextStyle,
        ),
      ],
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
