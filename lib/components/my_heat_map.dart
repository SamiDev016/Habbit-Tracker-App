import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';

class MyHeatMap extends StatelessWidget {
  final DateTime startDate;
  final Map<DateTime, int>? datasets;
  const MyHeatMap({super.key, required this.startDate, this.datasets});

  @override
  Widget build(BuildContext context) {
    return HeatMap(
      startDate: startDate,
      endDate: DateTime.now(),
      datasets: datasets,
      colorMode: ColorMode.color,
      defaultColor: Theme.of(context).colorScheme.secondary,
      textColor: Colors.white,
      showColorTip: false,
      showText: true,
      scrollable: true,
      size: 30,
      colorsets: {
        1:Colors.blue.shade200,
        2:Colors.blue.shade300,
        3:Colors.blue.shade400,
        4:Colors.blue.shade500,
        5:Colors.blue.shade600,
      },
    );
  }
}