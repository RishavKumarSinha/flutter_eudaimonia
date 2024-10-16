import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:eudaimonia/theme/dark_mode.dart';
import 'package:eudaimonia/theme/theme_provider.dart';
import 'package:provider/provider.dart';


class MyHeatMap extends StatelessWidget {
  final Map<DateTime, int> datasets;
  final DateTime startDate;
  const MyHeatMap({super.key,required this.startDate,required this.datasets});

  @override
  Widget build(BuildContext context) {
    return HeatMap(
      startDate:startDate ,
      endDate: DateTime.now(),
      datasets: datasets,
      colorMode: ColorMode.color,
      defaultColor: Theme.of(context).colorScheme.secondary,
      textColor: Provider.of<ThemeProvider>(context).themeData==darkMode ? Colors.white:Colors.black,
      showColorTip: false,
      showText: true,
      scrollable: true,
      size: 30,
      colorsets: {
      1:Colors.green.shade300,
      2:Colors.green.shade400,
      3:Colors.green.shade500,
      4:Colors.green.shade700,
      5:Colors.green.shade900,
    },
    );
  }
}