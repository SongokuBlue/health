import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

// import 'package:omni_datetime_picker/omni_datetime_picker.dart';
// import 'package:health/charts/line.dart';
// import 'package:health/bar/drawer.dart';
import 'package:health/services/firebase_data.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:health/bar/textfield.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
final Target_input =
    TextEditingController(); // lấy giá trị string dc nhập từ user

class StepPage extends StatefulWidget {
  const StepPage({super.key});

  @override
  _StepPage createState() => _StepPage();
}

class _StepPage extends State<StepPage> {
  int currentStep = 7850;
  int targetStep = int.tryParse(Target_input.text) ?? 10000;
  @override
  Widget build(BuildContext context) {
    double percent = currentStep / targetStep;
    final backgroundColor = Color(0xFFFDF4FF); // Màu nền app
    return Scaffold(
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
              // setState(() {
              //   _loadData(); // Tải lại dữ liệu từ Firebase khi nhấn refresh
              //   _lastUpdated = DateTime.now(); // Cập nhật lại thời gian
              // });
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
                    '$currentStep',
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
}
