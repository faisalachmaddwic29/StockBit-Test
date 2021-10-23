import 'package:alarm/components/alarm/alarm_bloc.dart';
import 'package:alarm/components/alarm/alarm_model.dart';
import 'package:alarm/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Detail extends StatelessWidget {
  final AlarmModel? payload;
  final AlarmBloc alarmBloc;
  const Detail({this.payload, required this.alarmBloc, Key? key})
      : super(key: key);
  // const Detail({this.payload});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Alarm ke ${payload!.id}'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            alarmBloc.add(AlarmGetData());
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Text(
              payload!.time.toString() + ' Second',
              style: headlineTextStyle,
            ),
            VerticalChart(
              data: int.tryParse(payload!.time ?? ''),
              text: payload!.id.toString(),
            ),
          ],
        ),
      ),
    );
  }
}

// CHART

class VerticalChart extends StatefulWidget {
  final int? data;
  final String text;
  const VerticalChart({Key? key, required this.data, required this.text})
      : super(key: key);

  @override
  _VerticalChartState createState() => _VerticalChartState();
}

class _VerticalChartState extends State<VerticalChart> {
  late List<ChartModel> _chartdata;

  @override
  void initState() {
    super.initState();
    _chartdata = getDataCharts();
  }

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      series: <ChartSeries>[
        BarSeries<ChartModel, String>(
          dataSource: _chartdata,
          xValueMapper: (ChartModel data, _) => data.x,
          yValueMapper: (ChartModel data, _) => data.y,
        ),
      ],
      isTransposed: true,
      primaryXAxis: CategoryAxis(),
    );
  }

  List<ChartModel> getDataCharts() {
    final List<ChartModel> chartData = [
      ChartModel('1', widget.data ?? 10),
    ];
    return chartData;
  }
}

class ChartModel {
  ChartModel(this.x, this.y);
  final String x;
  final int y;
}
