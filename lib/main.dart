/*
Harrison Stadler
02/24/2025
ClassActivity #06
Age Counter App
*/

// Importing necessary Dart and Flutter packages.
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_size/window_size.dart';

// Main entry point of the application.
void main() {
  setupWindow();  // Sets up window properties for desktop apps.
  runApp(
    ChangeNotifierProvider(
      create: (context) => Counter(),  // Creates a Counter object managed by Provider.
      child: const MyApp(),
    ),
  );
}

// Setup window size and title for desktop platforms, not relevant for web or mobile.
void setupWindow() {
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    WidgetsFlutterBinding.ensureInitialized();
    setWindowTitle('Age Counter App');
    setWindowMinSize(const Size(360, 640));
    setWindowMaxSize(const Size(360, 640));
    getCurrentScreen().then((screen) {
      setWindowFrame(Rect.fromCenter(
        center: screen!.frame.center,
        width: 360,
        height: 640,
      ));
    });
  }
}

// Counter class using ChangeNotifier to allow for widgets to react to changes.
class Counter with ChangeNotifier {
  int value = 0;  // Starting value of the counter.

  // Sets the counter value based on the slider and notifies widgets to rebuild.
  void setValue(double newValue) {
    value = newValue.round();
    notifyListeners();
  }

  // Method to determine the background color of the container based on the age.
  Color get color {
    if (value <= 12) return Colors.lightBlue;
    if (value <= 19) return Colors.green;
    if (value <= 30) return Colors.yellow;
    if (value <= 50) return Colors.orange;
    return Colors.grey;  // Default color for ages 51 and older.
  }

  // Returns a different message depending on the age range.
  String get message {
    if (value <= 12) return "You're a child!";
    if (value <= 19) return "Teenager time!";
    if (value <= 30) return "You're a young adult!";
    if (value <= 50) return "You're an adult now!";
    return "Golden years!";  // For seniors.
  }

  // Determines the progress bar color based on age.
  Color get progressBarColor {
    if (value < 33) return Colors.green;
    if (value < 67) return Colors.yellow;
    return Colors.red;  // Color for ages 67 and up.
  }
}

// MyApp is the main application widget.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

// MyHomePage is the widget that displays the main content.
class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Age Counter App'),  // App bar with a simple title.
      ),
      body: Center(
        child: Consumer<Counter>(
          builder: (context, counter, child) => Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: counter.color,  // Background color changes based on age.
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'You are ${counter.value} years old',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Text(
                  counter.message,  // Displaying the message based on age.
                  style: const TextStyle(color: Colors.white, fontSize: 24),
                ),
                Slider(
                  value: counter.value.toDouble(),
                  min: 0,
                  max: 99,
                  divisions: 99,
                  label: counter.value.toString(),
                  onChanged: (double newValue) {
                    counter.setValue(newValue);  // Update age when the slider is adjusted.
                  },
                ),
                LinearProgressIndicator(
                  value: counter.value / 99,
                  backgroundColor: Colors.grey[300],
                  color: counter.progressBarColor,  // Changes color based on age.
                  minHeight: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
