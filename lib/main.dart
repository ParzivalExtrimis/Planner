import 'package:flutter/material.dart';
import 'package:planner/plan_generation/models/generated_plan_model.dart';
import 'package:planner/plan_generation/pages/input.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark(useMaterial3: true),
      home: const Input(),
      // TODO: After navigating to Preview, Pop must be handled.
      // https://api.flutter.dev/flutter/widgets/PopScope-class.html
    );
  }
}
