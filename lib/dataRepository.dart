import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class DataRepository extends StatefulWidget {
  _DataRepositoryState createState() => _DataRepositoryState();
}

class _DataRepositoryState extends State<DataRepository> {
  Stream<QuerySnapshot> _data;

  @override
  void initState() {
    // TODO: implement initState
    Firestore.instance
        .collection('books')
        .document()
        .setData({'title': 'title', 'author': 'author'});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("data"),
      ),
      body: new StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('stations').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return new Text('Loading...');
          return new ListView(
            children: snapshot.data.documents.map((DocumentSnapshot document) {
              return new ListTile(
                title: new Text("value of document['stationName']: " +
                    document['stationName']),
                subtitle: new Text("documentId: " + document.documentID),
              );
            }).toList(),
          );
        },
      ),
    );
  }

  Stream<QuerySnapshot> _loadData() {
    _data = Firestore.instance.collection("users").snapshots();
  }
}
