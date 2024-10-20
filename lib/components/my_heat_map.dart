import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:eudaimonia/theme/dark_mode.dart';
import 'package:eudaimonia/theme/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class MyHeatMap extends StatefulWidget {
  final Map<DateTime, int> datasets;
  final DateTime startDate;

  const MyHeatMap({
    super.key,
    required this.startDate,
    required this.datasets,
  });

  @override
  _MyHeatMapState createState() => _MyHeatMapState();
}

class _MyHeatMapState extends State<MyHeatMap> {
  late DateTime _currentMonth;

  @override
  void initState() {
    super.initState();
    _currentMonth = DateTime(DateTime.now().year, DateTime.now().month, 1);
  }

  // Function to move to the next month
  void _goToNextMonth() {
    setState(() {
      if (_currentMonth.month == 12) {
        _currentMonth = DateTime(_currentMonth.year + 1, 1, 1);
      } else {
        _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 1);
      }
    });
  }

  // Function to move to the previous month
  void _goToPreviousMonth() {
    setState(() {
      if (_currentMonth.month == 1) {
        _currentMonth = DateTime(_currentMonth.year - 1, 12, 1);
      } else {
        _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1, 1);
      }
    });
  }

  /// Filter the dataset to only include dates in the current month
  Map<DateTime, int> _filterCurrentMonthDataset() {
    Map<DateTime, int> filteredDataset = {};

    widget.datasets.forEach((date, value) {
      if (date.year == _currentMonth.year && date.month == _currentMonth.month) {
        filteredDataset[date] = value;
      }
    });

    return filteredDataset;
  }

  @override
  Widget build(BuildContext context) {
    String monthName = DateFormat.yMMMM().format(_currentMonth);

    return Column(
      children: [
        // Display the current month at the top
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: _goToPreviousMonth,
              ),
              Text(
                monthName,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Provider.of<ThemeProvider>(context).themeData == darkMode
                      ? Colors.white
                      : Colors.black,
                ),
              ),
              IconButton(
                icon: Icon(Icons.arrow_forward),
                onPressed: _goToNextMonth,
              ),
            ],
          ),
        ),
        Expanded(
          child: GestureDetector(
            onHorizontalDragEnd: (DragEndDetails details) {
              if (details.primaryVelocity! > 0) {
                _goToPreviousMonth();
              } else if (details.primaryVelocity! < 0) {
                _goToNextMonth();
              }
            },
            child: HeatMap(
              // Force the heatmap to only show the days in the current month
              startDate: DateTime(_currentMonth.year, _currentMonth.month, 1),
              endDate: DateTime(_currentMonth.year, _currentMonth.month + 1, 0),
              datasets: _filterCurrentMonthDataset(),
              colorMode: ColorMode.color,
              defaultColor: Theme.of(context).colorScheme.secondary,
              textColor: Provider.of<ThemeProvider>(context).themeData == darkMode
                  ? Colors.white
                  : Colors.black,
              showColorTip: false,
              showText: true,
              scrollable: false,
              size: 30,
              colorsets: {
                1: Colors.green.shade300,
                2: Colors.green.shade400,
                3: Colors.green.shade500,
                4: Colors.green.shade700,
                5: Colors.green.shade900,
              },
            ),
          ),
        ),
      ],
    );
  }
}
