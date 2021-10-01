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
      title: 'Band Name Survey',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Possible Band Names'),
    );
  }
}


class MyHomePage extends StatelessWidget {
  const MyHomePage({ Key ? key, required this.title}) : super(key: key);

  final String title;


  Widget _buildListItem(BuildContext context, DocumentSnapshot document) {
    return ListTile(
      title: Row(
        children: [
          Expanded(
            child: Text(
              document['name'],
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              color: Color(0xffddddff),
            ),
            padding: const EdgeInsets.all(8.0),
            child: Text(
              document['votes'].toString(),
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ),
        ],
      ),
      onTap: () {
        FirebaseFirestore.instance.runTransaction((transaction) async {
          DocumentSnapshot freshSnap =
          await transaction.get(document.reference);
          await transaction.update(freshSnap.reference, {
            'votes': freshSnap['votes'] + 1,
          });
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: StreamBuilder <QuerySnapshot> (
          stream: FirebaseFirestore.instance.collection('bandnames').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const Text('Loading...');
            return ListView.builder(
              itemExtent: 80.0,
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) =>
                  _buildListItem(context,snapshot.data!.docs[index]),
            );


          }),
    );
  }
}