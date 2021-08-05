import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'util.dart';

class NounsScreen extends StatefulWidget {
  @override
  _NounsScreenState createState() => _NounsScreenState();
}

class Word {
  final String article;
  final String word;
  final String plural;
  final String translation;
  Word({
    required this.article,
    required this.word,
    required this.plural,
    required this.translation,
  });
}

class _NounsScreenState extends State<NounsScreen> {
  List<Word> _allWords = [];
  List<Word> _words = [];
  int index = 0;

  bool _showArticle = true;
  bool _showWord = true;
  bool _showPlural = true;
  bool _showTranslation = true;

  bool _showDer = true;
  bool _showDie = true;
  bool _showDas = true;

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
      appBar: AppBar(title: Text("nouns")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (_words.isNotEmpty) ...[
              Text(
                "${_words[index].article}",
                style: theme.textTheme.headline5?.copyWith(
                  color: _showArticle ? null : Color(0),
                ),
              ),
              SizedBox(height: 4),
              Text(
                "${_words[index].word}",
                style: theme.textTheme.headline5?.copyWith(
                  color: _showWord ? null : Color(0),
                ),
              ),
              SizedBox(height: 4),
              Text(
                "${_words[index].plural}",
                style: theme.textTheme.headline5?.copyWith(
                  color: _showPlural ? null : Color(0),
                ),
              ),
              SizedBox(height: 8),
              Text(
                "${_words[index].translation}",
                style: theme.textTheme.subtitle1?.copyWith(
                  color: _showTranslation ? null : Color(0),
                ),
              ),
              SizedBox(height: 8),
              IconButton(
                onPressed: _openInGoogle,
                color: Colors.blue,
                icon: Icon(Icons.translate),
              ),
            ],
            SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton(
                  onPressed: _toggleShowDer,
                  child: SizedBox(
                    width: 72,
                    child: Center(
                      child: Text(
                        "Der",
                        style: TextStyle(
                          color: _showDer ? null : Colors.grey,
                          decoration:
                              _showDer ? null : TextDecoration.lineThrough,
                        ),
                      ),
                    ),
                  ),
                ),
                OutlinedButton(
                  onPressed: _toggleShowDie,
                  child: SizedBox(
                    width: 72,
                    child: Center(
                      child: Text(
                        "Die",
                        style: TextStyle(
                          color: _showDie ? null : Colors.grey,
                          decoration:
                              _showDie ? null : TextDecoration.lineThrough,
                        ),
                      ),
                    ),
                  ),
                ),
                OutlinedButton(
                  onPressed: _toggleShowDas,
                  child: SizedBox(
                    width: 72,
                    child: Center(
                      child: Text(
                        "Das",
                        style: TextStyle(
                          color: _showDas ? null : Colors.grey,
                          decoration:
                              _showDas ? null : TextDecoration.lineThrough,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton(
                  onPressed: _toggleShowArticle,
                  child: SizedBox(
                    width: buttonWidth,
                    child: Center(
                      child: Text(
                        "Article",
                        style: TextStyle(
                          color: _showArticle ? null : Colors.grey,
                          decoration:
                              _showArticle ? null : TextDecoration.lineThrough,
                        ),
                      ),
                    ),
                  ),
                ),
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
                  onPressed: _toggleShowPlural,
                  child: SizedBox(
                    width: buttonWidth,
                    child: Center(
                      child: Text(
                        "Plural",
                        style: TextStyle(
                          color: _showPlural ? null : Colors.grey,
                          decoration:
                              _showPlural ? null : TextDecoration.lineThrough,
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

  void _toggleShowDer() {
    _showDer = !_showDer;
    _updateWords();
    _nextWord();
  }

  void _toggleShowDie() {
    _showDie = !_showDie;
    _updateWords();
    _nextWord();
  }

  void _toggleShowDas() {
    _showDas = !_showDas;
    _updateWords();
    _nextWord();
  }

  void _updateWords() {
    setState(() {
      _words.clear();
      for (final word in _allWords) {
        if ((word.article == "Der" && _showDer) ||
            (word.article == "Die" && _showDie) ||
            (word.article == "Das" && _showDas)) {
          _words.add(word);
        }
      }
    });
  }

  void _toggleShowArticle() {
    setState(() {
      _showArticle = !_showArticle;
    });
  }

  void _toggleShowWord() {
    setState(() {
      _showWord = !_showWord;
    });
  }

  void _toggleShowPlural() {
    setState(() {
      _showPlural = !_showPlural;
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
    final text = await rootBundle.loadString('res/nouns.txt');
    final lines = text.split("\n");
    for (final line in lines) {
      final lineParts = line.split("|");
      if (lineParts.length == 3) {
        final translation = lineParts[0];
        final article = lineParts[1].substring(0, 3);
        final word = lineParts[1].substring(4);
        final plural = lineParts[2];
        _allWords.add(Word(
          article: article,
          word: word,
          plural: plural,
          translation: translation,
        ));
      }
    }
    _allWords.shuffle();
    _updateWords();
  }

  void _openInGoogle() {
    final word = _words[index];
    openTranslator(word.word);
  }
}
