import 'package:alarm/components/alarm/alarm_model.dart';
import 'package:alarm/screen/detail.dart';
import 'package:alarm/theme/theme.dart';
import 'package:alarm/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'alarm_bloc.dart';

Widget alarmWidget(context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: EdgeInsets.symmetric(horizontal: defaultPadding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Alarm',
              style: headlineTextStyle,
            ),
          ],
        ),
      ),
      SizedBox(
        width: MediaQuery.of(context).size.width,
        child: BlocBuilder<AlarmBloc, AlarmState>(
          builder: (context, state) {
            if (state is AlarmLoading) {
              return const Center(child: Text('Loading..'));
            }
            if (state is AlarmSuccessGetData) {
              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: state.data!.length,
                separatorBuilder: (context, index) {
                  return const Divider();
                },
                itemBuilder: (context, index) {
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 28),
                    dense: true,
                    title: Text(
                      DateFormat('HH:mm')
                          .format(state.data![index].alarmDateTime),
                      style: primaryTextStyle.copyWith(
                        color: Theme.of(context).primaryColor,
                        fontSize: 30,
                      ),
                    ),
                    subtitle: Text(
                      state.data![index].title,
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                    leading: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        context
                            .read<AlarmBloc>()
                            .add(DeleteAlarmEvent(id: state.data![index].id));
                      },
                    ),
                    trailing: BlocProvider.value(
                      value: context.read<AlarmBloc>(),
                      child: CustomSwitchButton(
                        value: state.data![index].isPending,
                        data: state.data![index],
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => Detail(
                                alarmBloc: context.read<AlarmBloc>(),
                                payload: state.data![index],
                              )));
                      // AlarmNotificationService.showNotification(
                      //   body: 'test',
                      //   title: 'test',
                      //   payload: jsonEncode(state.data![index].toMap()),
                      //   id: state.data![index].id,
                      // );
                      // context.read<AlarmBloc>().add(
                      //       UpdateAlarmEvent(
                      //         alarmModel: state.data![index],
                      //         isActive: state.data![index].isPending,
                      //         from: 'switch',
                      //       ),
                      //     );
                    },
                  );
                },
              );
            }

            if (state is AlarmDataIsEmpty) {
              return SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 2.2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Sorry, Alarm is Empty',
                      style: headlineTextStyle.copyWith(fontSize: 14),
                    ),
                    Text(
                      'Please insert the data with the button below',
                      style: headlineTextStyle.copyWith(
                        fontWeight: FontWeight.w300,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              );
            }
            return SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 2.2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Sorry, Alarm is Empty',
                    style: headlineTextStyle,
                  ),
                  Text(
                    'Please insert the data with the button below',
                    style: headlineTextStyle.copyWith(
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      )
    ],
  );
}

class CustomSwitchButton extends StatefulWidget {
  final bool value;
  final AlarmModel data;
  // CustomSwitchButton({Key? key, required this.value}) : super(key: key);
  const CustomSwitchButton({required this.value, required this.data, Key? key})
      : super(key: key);

  @override
  _CustomSwitchButtonState createState() => _CustomSwitchButtonState();
}

class _CustomSwitchButtonState extends State<CustomSwitchButton> {
  bool? isSwitched;
  @override
  Widget build(BuildContext context) {
    return Switch(
      value: isSwitched ?? widget.value,
      onChanged: (value) {
        setState(() {
          isSwitched = false;
        });
        context.read<AlarmBloc>().add(UpdateAlarmEvent(
            alarmModel: widget.data,
            isActive: isSwitched ?? false,
            from: 'switch'));
      },
      activeColor: Theme.of(context).primaryColor,
    );
  }
}
