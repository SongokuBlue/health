import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:health/charts/line.dart';
import 'package:health/bar/drawer.dart';
import 'package:health/services/firebase_data.dart';
import 'package:health/services/custom_range_button.dart';
final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class oxygen extends StatefulWidget {
  const oxygen({super.key});

  @override
  _OxyPageState createState() => _OxyPageState();
}
class _OxyPageState extends State<oxygen> {
  DateTime _lastUpdated = DateTime.now(); // Lưu trữ thời gian cập nhật
  String selectedFilter = ""; // Mặc định
  List<DateTime> filterdates = [];
  List<HealthLog> logs = []; // Danh sách lưu trữ logs từ Firebase
  List<FlSpot> spots = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // Load dữ liệu từ Firebase
  void _loadData() async {
    FirebaseService service = FirebaseService();
    final data = await service.getAveragedPerMinuteLogs();
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
          (index) => FlSpot(index.toDouble(), logs[index].oxygenSaturation),
    );
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = Color(0xFFFDF4FF); // Màu nền app
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: backgroundColor,
      endDrawer: CustomDrawer(),
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start, // Căn giữa icon và text
          children: [
            Text("Oxygen", style: TextStyle(fontWeight: FontWeight.bold)),
            Icon(Icons.bloodtype_rounded, color: Colors.redAccent), // Icon trái tim
            SizedBox(width: 8), // Khoảng cách giữa icon và text
          ],
        ),
        backgroundColor: const Color(0xFFFFEDF3),
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
            Container(
              height: 150,
              width: 300,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Last Measured",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Text("${logs.isNotEmpty ? logs.last.heartRate.toStringAsFixed(1) : '0.0'} %",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Text("Date: ${logs.isNotEmpty ? _formatDate(logs.last.timestamp) : 'N/A'}",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
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
                _buildFilterButton("1Hour"),
                _buildFilterButton("2Hours"),
              ],
            ),
            SizedBox(height: 32),
            // Biểu đồ trực tiếp không container
            LineChartWidget(
                dates: filterdates, spots: spots, chartColor: Colors.green, y_axis: 100.0,yAxisUnit: "%",yaxisintervals: 10,),
            SizedBox(height: 32),
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
              child: Column(
                children: [
                  Text(
                    "❤️ Health Tip",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    " When you own your breath, nobody can steal your peace.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Tạo button chọn thời gian
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
          case "1Hour":
            startDate = now.subtract(Duration(hours: 1));
            break;
          case "2Hours":
            startDate = now.subtract(Duration(hours: 2));
            break;
          default:
            startDate = DateTime(2000);
        }

        List<FlSpot> newSpots = [];
        List<DateTime> newDates = [];

        for (int i = 0; i < logs.length; i++) {
          if (logs[i].timestamp.isAfter(startDate)) {
            newSpots.add(FlSpot(newDates.length.toDouble(), logs[i].heartRate));
            newDates.add(logs[i].timestamp);
          }
        }

        spots = newSpots;
        filterdates = newDates;
      }
    });
  }

  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/"
        "${date.month.toString().padLeft(2, '0')}/"
        "${date.year} "
        "${date.hour.toString().padLeft(2, '0')}:"
        "${date.minute.toString().padLeft(2, '0')}";
  }
}
