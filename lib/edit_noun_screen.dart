import 'package:flutter/material.dart';
import 'database.dart';

class EditNounScreen extends StatefulWidget {
  final Noun noun;
  final int index;
  EditNounScreen({
    required this.noun,
    required this.index,
  });
  @override
  _EditNounScreenState createState() => _EditNounScreenState();
}

class _EditNounScreenState extends State<EditNounScreen> {
  late final TextEditingController _articleCtrl;
  late final TextEditingController _wordCtrl;
  late final TextEditingController _pluralCtrl;
  late final TextEditingController _translationCtrl;

  @override
  void initState() {
    super.initState();
    _articleCtrl = TextEditingController(text: widget.noun.article);
    _wordCtrl = TextEditingController(text: widget.noun.word);
    _pluralCtrl = TextEditingController(text: widget.noun.plural);
    _translationCtrl = TextEditingController(text: widget.noun.translation);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit'),
        actions: [
          IconButton(
            onPressed: () {
              _saveChanges();
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.check),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: _articleCtrl),
            SizedBox(height: 16),
            TextField(controller: _wordCtrl),
            SizedBox(height: 16),
            TextField(controller: _pluralCtrl),
            SizedBox(height: 16),
            TextField(controller: _translationCtrl),
            SizedBox(height: 64),
            ElevatedButton(
              onPressed: () {
                _deleteWord();
                Navigator.of(context).pop();
              },
              child: Text("DELETE"),
            ),
          ],
        ),
      ),
    );
  }

  void _saveChanges() {
    final json = widget.noun.toJson();
    json[Noun.articleKey] = _articleCtrl.text;
    json[Word.wordKey] = _wordCtrl.text;
    json[Noun.pluralKey] = _pluralCtrl.text;
    json[Word.translationKey] = _translationCtrl.text;
    final newNoun = Noun.fromJson(json);
    final words = Database().sections['nouns']!;
    words[widget.index] = newNoun;
    Database().saveSection('nouns');
  }

  void _deleteWord() {
    final words = Database().sections['nouns']!;
    words.removeAt(widget.index);
    Database().saveSection('nouns');
  }
}
