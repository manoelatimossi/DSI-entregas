import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

class _RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _saved = <WordPair>{};
  final _biggerFont = const TextStyle(fontSize: 18.0);

  Widget _buildSuggestions() {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, i) {
          if (i.isOdd) return const Divider(); /*2*/

          final index = i ~/ 2;
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10)); /*4*/
          }
          return _buildRow(_suggestions[index], index);
        });
  }

  Widget _buildRow(WordPair pair, index) {
    final alreadySaved = _saved.contains(pair);
    final item = _suggestions[index].asString;
    return Dismissible(
        key: Key(item),
        background: Container(
          color: Colors.amber,
          child: Align(
            alignment: Alignment(-0.9, 0),
            child: Icon(Icons.delete, color: Colors.white),
          ),
        ),
        onDismissed: (direction) {
          setState(() {
            _suggestions.removeAt(index);
          });
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('MaterialPageRoute index: $index')));
        },
        child: ListTile(
          title: ListTile(title: Text('$pair')),
          onTap: () => (edit(_suggestions, index)),
          trailing: IconButton(
              onPressed: () {
                setState(() {
                  if (alreadySaved) {
                    _saved.remove(pair);
                  } else {
                    _saved.add(pair);
                  }
                });
              },
              icon: Icon(Icons.favorite,
                  color: alreadySaved ? Colors.amber : null,
                  semanticLabel: alreadySaved ? 'Remove from saved' : 'Save')),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Startup Name Generator'),
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: _pushSaved,
            tooltip: 'Saved Suggestions',
          ),
        ],
      ),
      body: _buildSuggestions(),
    );
  }

  void edit(List<WordPair> _suggestions, int index) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return Scaffold(
              appBar: AppBar(
                title: Text('Edit Suggestions'),
              ),
              body: TextFormField(
                  initialValue: _suggestions[index].asString,
                  onFieldSubmitted: (value) => setState(() {
                        var aux = value.substring(0, 1);
                        var aux2 = value.substring(
                          1,
                        );
                        _suggestions[index] = WordPair(aux, aux2);
                      })));
        },
      ),
    );
  }

  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          final tiles = _saved.map(
            (WordPair pair) {
              return ListTile(
                title: Text(
                  pair.asLowerCase,
                  style: _biggerFont,
                ),
              );
            },
          );
          final divided = ListTile.divideTiles(
            context: context,
            tiles: tiles,
          ).toList();

          return Scaffold(
            appBar: AppBar(
              title: Text('Saved Suggestions'),
            ),
            body: ListView(children: divided),
          );
        }, // ...to here.
      ),
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  State<RandomWords> createState() => _RandomWordsState();
}
