import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import 'package:health/services/custom_range_button.dart';
import 'package:health/charts/line.dart';
import 'package:health/bar/drawer.dart';
import 'package:health/services/firebase_data.dart';
import 'package:percent_indicator/percent_indicator.dart';


final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
final Target_input =
    TextEditingController(); // lấy giá trị string dc nhập từ user

class StepPage extends StatefulWidget {
  const StepPage({super.key});

  @override
  _StepPage createState() => _StepPage();
}

class _StepPage extends State<StepPage> {
  DateTime _lastUpdated = DateTime.now(); // Lưu trữ thời gian cập nhật
  String selectedFilter = ""; // Mặc định
  List<DateTime> filterdates = [];
  List<HealthLog> logs = []; // Danh sách lưu trữ logs từ Firebase
  List<FlSpot> spots = [];
  int targetStep = int.tryParse(Target_input.text) ?? 10000;
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // Load dữ liệu từ Firebase
  void _loadData() async {
    FirebaseService service = FirebaseService();
    final data = await service.getDailyStepLogs();
    print("Fetched data: $data");  // Kiểm tra xem dữ liệu có được lấy không
    setState(() {
      logs = data;
      _updateSpots();
      filterdates = data.map((log) => log.timestamp).toList();
    });
  }

  // Cập nhật spots cho biểu đồ từ dữ liệu logs
  void _updateSpots() {
    spots = List.generate(
      logs.length,
          (index) => FlSpot(index.toDouble(), logs[index].stepCount.toDouble()),
    );
  }
  Widget build(BuildContext context) {
    double currentStep = logs.isNotEmpty ? logs.last.stepCount.toDouble() : 0.0;
    double percent = currentStep / targetStep;
    final backgroundColor = Color(0xFFFDF4FF); // Màu nền app
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: CustomDrawer(),
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start, // Căn giữa icon và text
          children: [
            Text("Step", style: TextStyle(fontWeight: FontWeight.bold)),
            Icon(Icons.directions_walk, color: Colors.blueAccent),
            // Icon trái tim
            SizedBox(width: 8),
            // Khoảng cách giữa icon và text
          ],
        ),
        backgroundColor: backgroundColor,
        elevation: 0,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _loadData(); // Tải lại dữ liệu từ Firebase khi nhấn refresh
                _lastUpdated = DateTime.now(); // Cập nhật lại thời gian
              });
            },
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              _scaffoldKey.currentState!.openEndDrawer(); // Mở drawer
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
                    '${logs.isNotEmpty ? logs.last.stepCount.toStringAsFixed(1) : '0.0'}',
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
            SizedBox(height: 20), // khoảng cách giữa vòng và button
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _showDialog();
                    // TODO: mở dialog hoặc nhập target mới
                    print('Set Target pressed');
                  },
                  child: Text('Set Target'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: StadiumBorder(),
                  ),
                ),
              ],
            ),
            // Nút chọn thời gian
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
            // Biểu đồ trực tiếp không container
            LineChartWidget(
                dates: filterdates, spots: spots, chartColor: Colors.red, y_axis: targetStep.toDouble(),yAxisUnit: "steps"),
            SizedBox(height: 20),
            Text("Last updated: ${_lastUpdated.toString()}"),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 24),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(2, 2),
                  ),
                ],
              ),

            ),
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
          title: Text(
            'Set Step Target',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: TextField(
            controller: Target_input, // dùng controller đã có
            keyboardType: TextInputType.number, //set là chỉ nhập bàn phím
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
                // nếu cần lưu Firebase hay setState, xử lý ở đây
                if (parsed == null || parsed <= 0) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("Warning",style: TextStyle(fontWeight: FontWeight.bold)),
                        content: Text('Please enter a number greater than 0.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
                else {
                  // Input hợp lệ, cập nhật giá trị
                  setState(() {
                    targetStep = parsed;
                  });
                  Navigator.pop(context); // đóng dialog "Set Target"
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
        onPressed: () {
          _filterData(label);
        },
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
        // Nếu đang chọn filter đó => bấm lại lần nữa sẽ hủy chọn
        selectedFilter = ""; // hoặc "All"
        filterdates = logs.map((log) => log.timestamp).toList();
        _updateSpots(); // cập nhật lại spots từ toàn bộ logs
      } else {
        // Áp dụng filter mới
        selectedFilter = filter;
        DateTime now = DateTime.now();
        DateTime startDate;

        switch (filter) {
          case "Weekly":
            startDate = now.subtract(Duration(days: 7));
            break;
          case "2Hours":
            startDate = now.subtract(Duration(days: 14));
            break;
          default:
            startDate = DateTime(2000);
        }

        List<FlSpot> newSpots = [];
        List<DateTime> newDates = [];

        for (int i = 0; i < logs.length; i++) {
          if (logs[i].timestamp.isAfter(startDate)) {
            newSpots.add(FlSpot(newDates.length.toDouble(), logs[i].stepCount.toDouble()));
            newDates.add(logs[i].timestamp);
          }
        }

        spots = newSpots;
        filterdates = newDates;
      }
    });
  }
}
