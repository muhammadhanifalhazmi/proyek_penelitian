import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:proyek_penelitian/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions
        .currentPlatform, // Ini otomatis terbuat saat Anda menjalankan 'flutterfire configure'
  );
  runApp(SiramApp());
}

class SiramApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Siram',
      theme: ThemeData(
        primaryColor: Color(0xFFC1D8C3),
        scaffoldBackgroundColor: Color(0xFFC1D8C3),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF8AB583),
        ),
      ),
      home: SensorDataScreen(),
    );
  }
}

class SensorDataScreen extends StatefulWidget {
  @override
  _SensorDataScreenState createState() => _SensorDataScreenState();
}

class _SensorDataScreenState extends State<SensorDataScreen> {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  double temperature = 0.0;
  double humidity = 0.0;
  int soilMoisture = 0;
  String relay1Status = 'OFF';
  String relay2Status = 'OFF';

  @override
  void initState() {
    super.initState();
    _getDataFromFirebase();
  }

  void _getDataFromFirebase() {
    _database.child('DHT/temperature').onValue.listen((event) {
      setState(() {
        temperature = (event.snapshot.value as num).toDouble();
      });
    });

    _database.child('DHT/humidity').onValue.listen((event) {
      setState(() {
        humidity = (event.snapshot.value as num).toDouble();
      });
    });

    _database.child('SoilMoisture').onValue.listen((event) {
      setState(() {
        soilMoisture = event.snapshot.value as int;
      });
    });

    _database.child('Relay1/pumpState').onValue.listen((event) {
      setState(() {
        relay1Status = event.snapshot.value as String;
      });
    });

    _database.child('Relay2/pumpState').onValue.listen((event) {
      setState(() {
        relay2Status = event.snapshot.value as String;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSensorCard('Suhu Kebun', '$temperature °C'),
            _buildSensorCard('Kelembaban Kebun', '$humidity %'),
            _buildSensorCard('Kelembaban Tanah', '$soilMoisture'),
            _buildSensorCard('Pompa Kebun', relay1Status),
            _buildSensorCard('Pompa Tanah', relay2Status),
          ],
        ),
      ),
    );
  }

  Widget _buildSensorCard(String title, String value) {
    return Card(
      color: Color(0xFF8AB583),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
        trailing: Text(
          value,
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }
}
