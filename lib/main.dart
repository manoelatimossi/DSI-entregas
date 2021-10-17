import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'WordPair',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Wordpair());
  }
}

class MyHomePage extends State<Wordpair> {
  MyHomePage({Key? key, required this.title});
  final String title;
  final _saved = <DocumentSnapshot>{};
  final _suggestions = <DocumentSnapshot>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("WordPair"), actions: [
        IconButton(
          icon: const Icon(Icons.list),
          onPressed: () {
            _pushSaved(context);
          },
          tooltip: 'Saved Suggestions',
        ),
      ]),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('wordpair').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const Text('Loading...');
            return ListView.builder(
                itemExtent: 80.0,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  _suggestions.addAll(snapshot.data!.docs);
                  return _buildRow(snapshot.data!.docs[index], index);
                });
          }),
    );
  }

  Widget _buildRow(DocumentSnapshot pair, index) {
    final alreadySaved = _saved.contains(_suggestions[index]);
    final item = _suggestions[index].get('name');
    return Dismissible(
        key: UniqueKey(),
        background: Container(
          color: Colors.red,
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
            title: ListTile(title: Text('$item')),
            onTap: () => edit(_suggestions, index, context),
            trailing: Column(
              children: <Widget>[
                Container(
                  child: IconButton(
                    icon: Icon(
                      alreadySaved ? Icons.favorite : Icons.favorite_border,
                      color: alreadySaved ? Colors.red : null,
                    ),
                    onPressed: () {
                      setState(() {
                        if (alreadySaved) {
                          _saved.remove(_suggestions[index]);
                        } else {
                          _saved.add(_suggestions[index]);
                        }
                      });
                    },
                  ),
                )
              ],
            )));
  }

  void _pushSaved(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          final tiles = _saved.map(
            (DocumentSnapshot pair) {
              return ListTile(
                title: Text(
                  pair.get('name'),
                  style: Theme.of(context).textTheme.bodyText1,
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
        },
      ),
    );
  }

  void edit(List<DocumentSnapshot> _suggestions, int index, context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return Scaffold(
              appBar: AppBar(
                title: Text('Edit Suggestions'),
              ),
              body: TextFormField(
                  initialValue: _suggestions[index].get('name'),
                  onFieldSubmitted: (value) => setState(() {
                        var aux = _suggestions[index].get('name');
                        var aux2 = value;
                        FirebaseFirestore.instance
                            .collection('wordpair')
                            .doc('name')
                            .update({'name': aux});
                        _suggestions[index]
                            .reference
                            .update(<String, dynamic>{aux: aux2});
                      })));
        },
      ),
    );
  }
}

class Wordpair extends StatefulWidget {
  @override
  State<Wordpair> createState() => MyHomePage(title: 'WordPair');
}
