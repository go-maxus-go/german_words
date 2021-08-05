import 'package:flutter/material.dart';
import 'nouns_screen.dart';
import 'common_screen.dart';

class MainScreen extends StatefulWidget {
  final bool isDarkMode;
  final Function toggleDarkMode;
  MainScreen({
    required this.isDarkMode,
    required this.toggleDarkMode,
  });
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return NounsScreen();
                }));
              },
              child: Text("Nouns"),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return CommonScreen("adjectives");
                }));
              },
              child: Text("Adjectives"),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return CommonScreen("verbs");
                }));
              },
              child: Text("Verbs"),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return CommonScreen("other");
                }));
              },
              child: Text("Other"),
            ),
            SizedBox(height: 64),
            IconButton(
              onPressed: () => widget.toggleDarkMode(),
              icon: Icon(widget.isDarkMode ? Icons.wb_sunny : Icons.nightlight),
            ),
          ],
        ),
      ),
    );
  }
}
