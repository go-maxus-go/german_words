import 'dart:io';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class Word {
  static const learnedKey = 'learned';
  static const toLearnKey = 'toLearn';
  static const wordKey = 'word';
  static const translationKey = 'translation';

  final String word;
  final String translation;
  final bool learned;
  final bool toLearn;
  Word({
    required this.word,
    required this.translation,
    required this.learned,
    required this.toLearn,
  });

  Word.fromJson(Map<String, dynamic> json)
      : word = json[wordKey],
        translation = json[translationKey],
        learned = json[learnedKey] ?? false,
        toLearn = json[toLearnKey] ?? false;

  Map<String, dynamic> toJson() {
    return {
      wordKey: word,
      translationKey: translation,
      learnedKey: learned,
      toLearnKey: toLearn,
    };
  }
}

class Noun extends Word {
  static const articleKey = 'article';
  static const pluralKey = 'plural';

  final String article;
  final String plural;
  Noun({
    required String word,
    required String translation,
    required bool learned,
    required bool toLearn,
    required this.article,
    required this.plural,
  }) : super(
          word: word,
          translation: translation,
          learned: learned,
          toLearn: toLearn,
        );

  Noun.fromJson(Map<String, dynamic> json)
      : article = json[articleKey],
        plural = json[pluralKey],
        super(
          word: json[Word.wordKey],
          translation: json[Word.translationKey],
          learned: json[Word.learnedKey] ?? false,
          toLearn: json[Word.toLearnKey] ?? false,
        );

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json[articleKey] = article;
    json[pluralKey] = plural;
    return json;
  }
}

class Database {
  static final Database _database = Database._internal();
  factory Database() => _database;
  Database._internal();

  final sections = {'adjectives': [], 'nouns': [], 'other': [], 'verbs': []};

  Future<void> loadAllSections() async {
    List<Future> futures = [];
    for (final sectionName in sections.keys) {
      Future future;
      if (sectionName != 'nouns') {
        future = _loadSection(sectionName);
      } else {
        future = _loadNounsSection();
      }
      futures.add(future);
    }
    await Future.wait(futures);
  }

  Future<void> saveSection(String section) async {
    final words = sections[section];
    if (words != null) {
      final json = [];
      for (final word in words) {
        json.add(word.toJson());
      }

      final jsonText = jsonEncode(json);
      final directory = await getApplicationDocumentsDirectory();
      final path = directory.path + '/' + section + '.txt';
      final file = File(path);
      await file.writeAsString(jsonText);
    }
  }

  Future<void> _loadNounsSection() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path + '/nouns.txt';
    final file = File(path);

    String text;
    if (file.existsSync()) {
      text = file.readAsStringSync();
    } else {
      text = await rootBundle.loadString('res/nouns.txt');
    }

    final json = jsonDecode(text);

    final List<Noun> words = [];
    for (final jsonWord in json) {
      final word = Noun.fromJson(jsonWord);
      words.add(word);
    }

    sections['nouns'] = words;
  }

  Future<void> _loadSection(String section) async {
    final text = await rootBundle.loadString('res/$section.txt');
    final json = jsonDecode(text);

    final List<Word> words = [];
    for (final jsonWord in json) {
      final word = Word.fromJson(jsonWord);
      words.add(word);
    }

    sections[section] = words;
  }
}
