import 'package:flutter/material.dart';
import 'package:note_apps/utils/routeObserver.dart';
import 'package:note_apps/view/HomePage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [ObserverUtils.routeObserver],
      debugShowCheckedModeBanner: false,
      title: 'Note apps',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}
