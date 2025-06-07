import 'package:firebase_database/firebase_database.dart';

class HealthLog {
  final bool emergency;
  final double heartRate;
  final double oxygenSaturation;
  final int stepCount;
  final DateTime timestamp;

  HealthLog({
    required this.emergency,
    required this.heartRate,
    required this.oxygenSaturation,
    required this.stepCount,
    required this.timestamp,
  });

  factory HealthLog.fromJson(Map<dynamic, dynamic> json) {
    return HealthLog(
      emergency: json['emergency'] ?? false,
      heartRate: (json['heartRate'] ?? 0).toDouble(),
      oxygenSaturation: (json['oxygenSaturation'] ?? 0).toDouble(),
      stepCount: json['stepCount'] ?? 0,
      timestamp: DateTime.parse(json['timestamp'] ?? ""), //change to date time
    ); //json tiêu chuẩn của data
  }
}

class FirebaseService {
  final DatabaseReference _dbRef =
  FirebaseDatabase.instance.ref("healthRecords/logs"); //take the database ref and data

  Future<List<HealthLog>> fetchHealthLogs() async {
    final snapshot = await _dbRef.get();
    if (snapshot.exists) {
      final Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>; //dynamic là chơi bất kì kiểu nào.
      return data.values //all data except key
          .map((entry) => HealthLog.fromJson(entry))
          .toList(); //chuyển hóa thành dữ liệu dc lưu
    } else {
      return [];
    }
  }
  Future<List<HealthLog>> getAveragedPerMinuteLogs() async {
    // Lấy dữ liệu từ Firebase
    final logs = await fetchHealthLogs(); // Sử dụng đối tượng firebaseService để gọi fetchHealthLogs

    // Nhóm theo từng phút
    Map<String, List<HealthLog>> grouped = {};

    for (var log in logs) {
      final key = "${log.timestamp.year}-${log.timestamp.month}-${log.timestamp.day} "
          "${log.timestamp.hour}:${log.timestamp.minute}";

      grouped.putIfAbsent(key, () => []);
      grouped[key]!.add(log);
    }

    // Tính trung bình mỗi nhóm
    List<HealthLog> averagedLogs = [];

    grouped.forEach((key, group) {
      double avgHeart = double.parse(
        (group.map((e) => e.heartRate).reduce((a, b) => a + b) / group.length)
            .toStringAsFixed(1),
      );

      double avgOxy = double.parse(
        (group.map((e) => e.oxygenSaturation).reduce((a, b) => a + b) / group.length)
            .toStringAsFixed(1),
      );
      int avgStep = (group.map((e) => e.stepCount).reduce((a, b) => a + b) / group.length).round();

      // Dùng timestamp đầu tiên trong nhóm (hoặc parse từ key)
      averagedLogs.add(
        HealthLog(
          emergency: group.any((e) => e.emergency),
          heartRate: avgHeart,
          oxygenSaturation: avgOxy,
          stepCount: avgStep,
          timestamp: group.first.timestamp,
        ),
      );
    });

    // Sắp xếp lại theo thời gian (tăng dần)
    averagedLogs.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    return averagedLogs;
  }
}


