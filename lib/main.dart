import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

// Gabriel, o código de deletar tá aba de favoritos.
void main() => runApp(MyApp());

// #docregion MyApp
class MyApp extends StatelessWidget {
  // #docregion build
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Startup Name Generator',
      theme: ThemeData(
        primaryColor: Colors.purple,
      ),
      home: RandomWords(),
    );
  }

}

class _RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _saved = <WordPair>{};
  final edt = <WordPair>{};
  final _biggerFont = const TextStyle(fontSize: 18.0);
  // #enddocregion RWS-var

  // #docregion _buildSuggestions
  Widget _buildSuggestions() {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: /*1*/ (context, i) {
          if (i.isOdd) return const Divider(); /*2*/

          final index = i ~/ 2; /*3*/
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10)); /*4*/
          }
          return _buildRow(_suggestions[index], index);
        });
  }

  Widget _buildRow(WordPair pair, index) {
    final alreadySaved = _saved.contains(pair);
    return ListTile(

      title: ListTile(title: Text('$pair')),
      onTap: (
      edit
      ),
      trailing: IconButton(onPressed: () {
        setState(() {
          if (alreadySaved) {
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });
      },
          icon:Icon(Icons.favorite,

              color: alreadySaved ? Colors.amber : null,
              semanticLabel: alreadySaved ? 'Remove from saved' : 'Save')
      ),

    );
  }
  // #enddocregion _buildRow

  // #docregion RWS-build
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
  // #enddocregion RWS-build
void edit(){
  Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (BuildContext context) {
        return Scaffold(
            appBar: AppBar(
              title: Text('Edit Suggestions'),

            ),
            body: ListView.builder(
              itemCount: _suggestions.length,
              itemBuilder: (context, index) {
                String aux;
                return ListTile(
                    title: TextFormField(initialValue: _suggestions[index].asString,
                      style: _biggerFont,

                      onFieldSubmitted: (value)  =>

                          setState(() {
                            aux = value.substring(0,1);
                            var aux2 = value.substring(1,);
                            _suggestions[index] = WordPair(aux,aux2);
                          }
                          ),
                    ));


              },
            ));
      },
    ),
  );
}


  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return Scaffold(
              appBar: AppBar(
                title: Text('Saved Suggestions'),
              ),
              body: ListView.builder(
                itemCount: _saved.length,
                itemBuilder: (context, index) {
                  final item = _suggestions[index];
                  return Dismissible(
                    key: Key(item.asCamelCase),
                    onDismissed: (direction) {
                      setState(() {
                        print("MaterialPageRoute index: $index");
                        _saved.remove(item);
                      });
                    },
                    background: Container(color: Colors.red,
                      child: Align(
                        alignment: Alignment(-0.9, 0),
                        child: Icon(Icons.delete, color: Colors.white),
                      ),
                    ),
                    child: ListTile(title: Text('$item')),
                  );
                },
              ));
        },
      ),
    );
  }
}
class RandomWords extends StatefulWidget {
  @override
  State<RandomWords> createState() => _RandomWordsState();
}