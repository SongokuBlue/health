import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:health/services/custom_range_button.dart';
import 'package:health/charts/line.dart';
import 'package:health/bar/drawer.dart';
import 'package:health/services/firebase_data.dart';
import 'package:percent_indicator/percent_indicator.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
final Target_input = TextEditingController();

class StepPage extends StatefulWidget {
  const StepPage({super.key});

  @override
  _StepPage createState() => _StepPage();
}

class _StepPage extends State<StepPage> {
  DateTime _lastUpdated = DateTime.now();
  String selectedFilter = "";
  List<DateTime> filterdates = [];
  List<HealthLog> logs = [];
  List<FlSpot> spots = [];
  int targetStep = 10000;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    Target_input.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    FirebaseService service = FirebaseService();
    final data = await service.getDailyStepLogs();
    setState(() {
      logs = data;
      _updateSpots();
      filterdates = data.map((log) => log.timestamp).toList();
    });
  }

  void _updateSpots() {
    spots = List.generate(
      logs.length,
          (index) => FlSpot(index.toDouble(), logs[index].stepCount.toDouble()),
    );
  }

  @override
  Widget build(BuildContext context) {
    double currentStep = logs.isNotEmpty ? logs.last.stepCount.toDouble() : 0.0;
    double percent = currentStep / targetStep;
    final backgroundColor = Color(0xFFFDF4FF);

    return Scaffold(
      key: _scaffoldKey,
      endDrawer: CustomDrawer(),
      appBar: AppBar(
        title: Row(
          children: [
            Text("Step", style: TextStyle(fontWeight: FontWeight.bold)),
            Icon(Icons.directions_walk, color: Colors.blueAccent),
            SizedBox(width: 8),
          ],
        ),
        backgroundColor: backgroundColor,
        elevation: 0,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () async {
              await _loadData();
              setState(() {
                _lastUpdated = DateTime.now();
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              _scaffoldKey.currentState!.openEndDrawer();
            },
          ),
        ],
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularPercentIndicator(
              radius: 130,
              lineWidth: 10,
              progressColor: Colors.blue,
              percent: percent.clamp(0.0, 1.0),
              center: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${currentStep.toStringAsFixed(1)}',
                    style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                  ),
                  Text('Steps', style: TextStyle(fontSize: 18)),
                  SizedBox(height: 8),
                  Text(
                    '${(targetStep - currentStep).clamp(0, targetStep)} steps left',
                    style: TextStyle(color: Colors.blue, fontSize: 18),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _showDialog,
              child: Text('Set Target'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shape: StadiumBorder(),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomRangeButton(
                  selectedFilter: selectedFilter,
                  logs: logs,
                  onFilterChanged: (filter) {
                    setState(() {
                      selectedFilter = filter;
                    });
                  },
                  onCustomRangeApplied: (newSpots, newDates) {
                    setState(() {
                      spots = newSpots;
                      filterdates = newDates;
                    });
                  },
                ),
                _buildFilterButton("Weekly"),
                _buildFilterButton("2Weeks"),
              ],
            ),
            SizedBox(height: 20),
            spots.isEmpty
                ? Text("No data available")
                : LineChartWidget(
              dates: filterdates,
              spots: spots,
              chartColor: Colors.red,
              y_axis: targetStep.toDouble(),
              yAxisUnit: "steps",
            ),
            SizedBox(height: 20),
            Text("Last updated: ${_lastUpdated.toString()}"),
          ],
        ),
      ),
    );
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Set Step Target', style: TextStyle(fontWeight: FontWeight.bold)),
          content: TextField(
            controller: Target_input,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Step target',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final input = Target_input.text.trim();
                final parsed = int.tryParse(input);
                if (parsed == null || parsed <= 0) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text("Warning", style: TextStyle(fontWeight: FontWeight.bold)),
                      content: Text('Please enter a number greater than 0.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('OK'),
                        ),
                      ],
                    ),
                  );
                } else {
                  setState(() {
                    targetStep = parsed;
                  });
                  Navigator.pop(context);
                }
              },
              child: Text('Save'),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        );
      },
    );
  }

  Widget _buildFilterButton(String label) {
    final isSelected = selectedFilter == label;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: ElevatedButton(
        onPressed: () => _filterData(label),
        child: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? Colors.purple : Colors.white,
          foregroundColor: isSelected ? Colors.white : Colors.purple,
          shape: StadiumBorder(),
          elevation: 2,
        ),
      ),
    );
  }

  void _filterData(String filter) {
    setState(() {
      if (selectedFilter == filter) {
        selectedFilter = "";
        filterdates = logs.map((log) => log.timestamp).toList();
        _updateSpots();
      } else {
        selectedFilter = filter;
        DateTime now = DateTime.now();
        DateTime startDate;

        switch (filter) {
          case "Weekly":
            startDate = now.subtract(Duration(days: 7));
            break;
          case "2Weeks":
            startDate = now.subtract(Duration(days: 14));
            break;
          default:
            startDate = DateTime(2000);
        }

        List<FlSpot> newSpots = [];
        List<DateTime> newDates = [];

        for (int i = 0; i < logs.length; i++) {
          if (logs[i].timestamp.isAfter(startDate)) {
            newSpots.add(FlSpot(newSpots.length.toDouble(), logs[i].stepCount.toDouble()));
            newDates.add(logs[i].timestamp);
          }
        }

        spots = newSpots;
        filterdates = newDates;
      }
    });
  }
}
