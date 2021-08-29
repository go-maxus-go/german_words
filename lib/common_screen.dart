import 'package:flutter/material.dart';
import 'util.dart';
import 'database.dart';
import 'edit_word_screen.dart';

class CommonScreen extends StatefulWidget {
  final String section;
  CommonScreen(this.section);
  @override
  _CommonScreenState createState() => _CommonScreenState();
}

class _CommonScreenState extends State<CommonScreen> {
  List<int> _indices = [];
  int _index = 0;

  bool _showWord = true;
  bool _showTranslation = true;

  bool _showLearned = false;
  bool _showToLearn = false;

  @override
  void initState() {
    super.initState();
    _updateIndices();
  }

  List<dynamic> _getWords() {
    return Database().sections[widget.section]!;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final buttonWidth = 56.0;

    final words = _getWords();
    Word? word = _indices.isNotEmpty ? words[_indices[_index]] : null;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.section),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _showToLearn = !_showToLearn;
                _updateIndices();
              });
            },
            color: _showToLearn ? Colors.red : null,
            icon: Icon(Icons.school),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                _showLearned = !_showLearned;
                _updateIndices();
              });
            },
            color: _showLearned ? Colors.green : null,
            icon: Icon(Icons.check_circle),
          ),
          SizedBox(width: 32),
          IconButton(
            onPressed: () {
              setState(() {
                _indices.shuffle();
              });
            },
            icon: Icon(Icons.casino),
          ),
          IconButton(
            onPressed: () async {
              if (_indices.isNotEmpty) {
                final index = _indices[_index];
                final word = _getWords()[index]!;
                await Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return EditWordScreen(
                    word: word,
                    section: widget.section,
                    index: index,
                  );
                }));
                setState(() {
                  _updateIndex();
                });
              }
            },
            icon: Icon(Icons.edit),
          ),
        ],
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.only(left: 16, right: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (word != null) ...[
                Text(
                  "${word.word}",
                  style: theme.textTheme.headline5?.copyWith(
                    color: _showWord ? null : Color(0),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  "${word.translation}",
                  style: theme.textTheme.subtitle1?.copyWith(
                    color: _showTranslation ? null : Color(0),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: Icon(Icons.school),
                      color: word.toLearn ? Colors.red : Colors.grey,
                      onPressed: () {
                        if (_indices.isNotEmpty) {
                          setState(() {
                            final json = word.toJson();
                            json[Word.toLearnKey] = !word.toLearn;
                            json[Word.learnedKey] = false;
                            final newWord = Word.fromJson(json);
                            final index = _indices[_index];
                            _getWords()[index] = newWord;
                            Database().saveSection(widget.section);
                          });
                        }
                      },
                    ),
                    IconButton(
                      onPressed: _openInGoogle,
                      color: Colors.blue,
                      icon: Icon(Icons.translate),
                    ),
                    IconButton(
                      icon: Icon(Icons.check_circle),
                      color: word.learned ? Colors.green : Colors.grey,
                      onPressed: () {
                        if (_indices.isNotEmpty) {
                          setState(() {
                            final json = word.toJson();
                            json[Word.learnedKey] = !word.learned;
                            json[Word.toLearnKey] = false;
                            final newWord = Word.fromJson(json);
                            final index = _indices[_index];
                            _getWords()[index] = newWord;
                            Database().saveSection(widget.section);
                          });
                        }
                      },
                    ),
                  ],
                ),
              ],
              SizedBox(height: 32),
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
      ),
    );
  }

  void _updateIndices() {
    setState(() {
      _indices.clear();
      final words = _getWords();

      for (int i = 0; i < words.length; ++i) {
        final word = words[i];
        final passFilter = (word.learned && word.learned == _showLearned) ||
            (word.toLearn && word.toLearn == _showToLearn) ||
            (word.learned == _showLearned && word.toLearn == _showToLearn);
        if (passFilter) {
          _indices.add(i);
        }
      }

      _updateIndex();
    });
  }

  void _updateIndex() {
    if (_indices.isNotEmpty) {
      _index = _index % _indices.length;
    } else {
      _index = 0;
    }
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
      _index++;
      _updateIndex();
    });
  }

  void _prevWord() {
    setState(() {
      _index--;
      _updateIndex();
    });
  }

  void _openInGoogle() {
    if (_indices.isNotEmpty) {
      final words = _getWords();
      final word = words[_indices[_index]];
      openTranslator(word.word);
    }
  }
}
