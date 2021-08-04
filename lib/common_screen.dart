import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'util.dart';

class CommonScreen extends StatefulWidget {
  final String name;
  CommonScreen(this.name);
  @override
  _CommonScreenState createState() => _CommonScreenState();
}

class Word {
  final String word;
  final String translation;
  Word({
    required this.word,
    required this.translation,
  });
}

class _CommonScreenState extends State<CommonScreen> {
  List<Word> _words = [];
  int index = 0;

  bool _showWord = true;
  bool _showTranslation = true;

  @override
  void initState() {
    super.initState();
    _loadWords();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final buttonWidth = 56.0;
    return Scaffold(
      appBar: AppBar(title: Text(widget.name)),
      body: Container(
        padding: EdgeInsets.only(left: 16, right: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (_words.isNotEmpty) ...[
              Text(
                "${_words[index].word}",
                style: theme.textTheme.headline5?.copyWith(
                  color: _showWord ? null : Color(0),
                ),
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 8),
              Text(
                "${_words[index].translation}",
                style: theme.textTheme.subtitle1?.copyWith(
                  color: _showTranslation ? null : Color(0),
                ),
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 8),
              IconButton(
                onPressed: _openInGoogle,
                color: Colors.blue,
                icon: Icon(Icons.translate),
              ),
            ],
            SizedBox(height: 64),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton(
                  onPressed: _toggleShowWord,
                  child: SizedBox(
                    width: buttonWidth,
                    child: Center(
                      child: Text(
                        "Word",
                        style: TextStyle(
                          color: _showWord ? null : Colors.grey,
                          decoration:
                              _showWord ? null : TextDecoration.lineThrough,
                        ),
                      ),
                    ),
                  ),
                ),
                OutlinedButton(
                  onPressed: _toggleShowTranslation,
                  child: SizedBox(
                    width: buttonWidth,
                    child: Center(
                      child: Text(
                        "Meaning",
                        style: TextStyle(
                          color: _showTranslation ? null : Colors.grey,
                          decoration: _showTranslation
                              ? null
                              : TextDecoration.lineThrough,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 64),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _prevWord,
                  child: SizedBox(
                    height: 64,
                    child: Center(
                      child: Text("PREV"),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: _nextWord,
                  child: SizedBox(
                    height: 64,
                    child: Center(
                      child: Text("NEXT"),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 64),
          ],
        ),
      ),
    );
  }

  void _toggleShowWord() {
    setState(() {
      _showWord = !_showWord;
    });
  }

  void _toggleShowTranslation() {
    setState(() {
      _showTranslation = !_showTranslation;
    });
  }

  void _nextWord() {
    setState(() {
      index++;
      if (index >= _words.length) {
        index = 0;
      }
    });
  }

  void _prevWord() {
    setState(() {
      index--;
      if (index < 0) {
        index = _words.length - 1;
      }
      if (index < 0) {
        index = 0;
      }
    });
  }

  void _loadWords() async {
    final text = await rootBundle.loadString('res/${widget.name}.txt');
    final lines = text.split("\n");
    for (final line in lines) {
      final lineParts = line.split("|");
      if (lineParts.length == 2) {
        final translation = lineParts[1];
        final word = lineParts[0];
        _words.add(Word(
          word: word,
          translation: translation,
        ));
      }
    }
    _words.shuffle();
    setState(() {});
  }

  void _openInGoogle() {
    final word = _words[index];
    openTranslator(word.word);
  }
}
