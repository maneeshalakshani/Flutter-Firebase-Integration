import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import './models/book.dart';

void main() => runApp(BookApp());

class BookApp extends StatelessWidget {
  const BookApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "test",
      home: Scaffold(
        body: Text("sf"),
      ),
    );
  }
}

class BookFireBaseDemo extends StatefulWidget {
  const BookFireBaseDemo({Key? key}) : super(key: key);

  @override
  _BookFireBaseDemoState createState() => _BookFireBaseDemoState();
}

class _BookFireBaseDemoState extends State<BookFireBaseDemo> {

  TextEditingController bookNameController = TextEditingController();
  TextEditingController authorController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Container();
  }
}


