import 'package:flutter/material.dart';
import 'package:mobil_cirak/service.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _service = FirebaseNotificationService();

  @override
  void initState() {
    super.initState();
    _service.connectNotification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Notification"),
      ),
    );
  }
}
