import 'package:flutter/material.dart';
import 'util.dart';
import 'database.dart';
import 'edit_noun_screen.dart';

class NounsScreen extends StatefulWidget {
  @override
  _NounsScreenState createState() => _NounsScreenState();
}

class _NounsScreenState extends State<NounsScreen> {
  List<int> _indices = [];
  int _index = 0;

  bool _showArticle = true;
  bool _showWord = true;
  bool _showPlural = true;
  bool _showTranslation = true;

  bool _showDer = true;
  bool _showDie = true;
  bool _showDas = true;

  bool _showLearned = false;
  bool _showToLearn = false;

  @override
  void initState() {
    super.initState();
    _updateIndices();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final words = Database().sections['nouns']!;
    Noun? word = _indices.isNotEmpty ? words[_indices[_index]] : null;

    return Scaffold(
      appBar: AppBar(
        title: Text("nouns"),
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
                final noun = Database().sections['nouns']![index]!;
                await Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return EditNounScreen(noun: noun, index: index);
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
                  "${word.article}",
                  style: theme.textTheme.headline5?.copyWith(
                    color: _showArticle ? null : Color(0),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 4),
                Text(
                  "${word.word}",
                  style: theme.textTheme.headline5?.copyWith(
                    color: _showWord ? null : Color(0),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 4),
                Text(
                  "${word.plural}",
                  style: theme.textTheme.headline5?.copyWith(
                    color: _showPlural ? null : Color(0),
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
                            final newNoun = Noun.fromJson(json);
                            final index = _indices[_index];
                            final nouns = _getNouns();
                            nouns[index] = newNoun;
                            Database().saveSection('nouns');
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
                            final newNoun = Noun.fromJson(json);
                            final index = _indices[_index];
                            final nouns = _getNouns();
                            nouns[index] = newNoun;
                            Database().saveSection('nouns');
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
                      child: Center(
                        child: Text(
                          "Article",
                          style: TextStyle(
                            color: _showArticle ? null : Colors.grey,
                            decoration: _showArticle
                                ? null
                                : TextDecoration.lineThrough,
                          ),
                        ),
                      ),
                    ),
                  ),
                  OutlinedButton(
                    onPressed: _toggleShowWord,
                    child: SizedBox(
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

  List<dynamic> _getNouns() {
    return Database().sections['nouns']!;
  }

  void _toggleShowDer() {
    _showDer = !_showDer;
    _updateIndices();
  }

  void _toggleShowDie() {
    _showDie = !_showDie;
    _updateIndices();
  }

  void _toggleShowDas() {
    _showDas = !_showDas;
    _updateIndices();
  }

  void _updateIndices() {
    setState(() {
      _indices.clear();
      final words = Database().sections['nouns']!;

      for (int i = 0; i < words.length; ++i) {
        final word = words[i];
        final rightArticle = (word.article == "Der" && _showDer) ||
            (word.article == "Die" && _showDie) ||
            (word.article == "Das" && _showDas);
        final passFilter = (word.learned && word.learned == _showLearned) ||
            (word.toLearn && word.toLearn == _showToLearn) ||
            (word.learned == _showLearned && word.toLearn == _showToLearn);
        if (passFilter && rightArticle) {
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
      final words = Database().sections['nouns']!;
      final word = words[_indices[_index]];
      openTranslator(word.word);
    }
  }
}
