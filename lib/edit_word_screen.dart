import 'package:flutter/material.dart';
import 'database.dart';

class EditWordScreen extends StatefulWidget {
  final Word word;
  final String section;
  final int index;
  EditWordScreen({
    required this.word,
    required this.section,
    required this.index,
  });
  @override
  _EditWordScreenState createState() => _EditWordScreenState();
}

class _EditWordScreenState extends State<EditWordScreen> {
  late final TextEditingController _wordCtrl;
  late final TextEditingController _translationCtrl;

  @override
  void initState() {
    super.initState();
    _wordCtrl = TextEditingController(text: widget.word.word);
    _translationCtrl = TextEditingController(text: widget.word.translation);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit'),
        actions: [
          IconButton(
            onPressed: () {
              _deleteWord();
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.delete),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: _wordCtrl),
            SizedBox(height: 16),
            TextField(controller: _translationCtrl),
            SizedBox(height: 64),
            ElevatedButton(
              onPressed: () {
                _saveChanges();
                Navigator.of(context).pop();
              },
              child: Text("SAVE"),
            ),
          ],
        ),
      ),
    );
  }

  void _saveChanges() {
    final json = widget.word.toJson();
    json[Word.wordKey] = _wordCtrl.text;
    json[Word.translationKey] = _translationCtrl.text;
    final newWord = Word.fromJson(json);
    final words = Database().sections[widget.section]!;
    words[widget.index] = newWord;
    Database().saveSection(widget.section);
  }

  void _deleteWord() {
    final words = Database().sections[widget.section]!;
    words.removeAt(widget.index);
    Database().saveSection(widget.section);
  }
}
