import 'package:flutter/material.dart';
import 'nouns_screen.dart';
import 'common_screen.dart';
import 'database.dart';

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
  bool _loading = true;
  @override
  void initState() {
    super.initState();
    Database().loadAllSections().whenComplete(() {
      setState(() {
        _loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final sections = Database().sections;

    final nouns = sections['nouns']!;
    final nounsToLearn = nouns.where((word) => word.toLearn).length;
    final nounsLearned = nouns.where((word) => word.learned).length;

    final adjectives = sections['adjectives']!;
    final adjectivesToLearn = adjectives.where((word) => word.toLearn).length;
    final adjectivesLearned = adjectives.where((word) => word.learned).length;

    final verbs = sections['verbs']!;
    final verbsToLearn = verbs.where((word) => word.toLearn).length;
    final verbsLearned = verbs.where((word) => word.learned).length;

    final other = sections['other']!;
    final otherToLearn = other.where((word) => word.toLearn).length;
    final otherLearned = other.where((word) => word.learned).length;

    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (!_loading) ...[
              ElevatedButton(
                onPressed: () async {
                  await Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return NounsScreen();
                  }));
                  setState(() {});
                },
                child: Text(
                    "Nouns ($nounsToLearn | $nounsLearned | ${nouns.length})"),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  await Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return CommonScreen("adjectives");
                  }));
                  setState(() {});
                },
                child: Text(
                    "Adjectives ($adjectivesToLearn | $adjectivesLearned | ${adjectives.length})"),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  await Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return CommonScreen("verbs");
                  }));
                  setState(() {});
                },
                child: Text(
                    "Verbs ($verbsToLearn | $verbsLearned | ${verbs.length})"),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  await Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return CommonScreen("other");
                  }));
                  setState(() {});
                },
                child: Text(
                    "Other ($otherToLearn | $otherLearned | ${other.length})"),
              ),
              SizedBox(height: 64),
              IconButton(
                onPressed: () => widget.toggleDarkMode(),
                icon:
                    Icon(widget.isDarkMode ? Icons.wb_sunny : Icons.nightlight),
              ),
            ] else
              LinearProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
