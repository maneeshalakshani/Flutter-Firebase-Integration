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
  bool isEditing = false;
  bool textFieldVisibility = false;
  String fireStoreCollectionName = "Books";
  late Book currentBook;

  getAllBooks(){
    return FirebaseFirestore.instance.collection(fireStoreCollectionName).snapshots();
  }

  addBook() async {
    Book book = Book(bookName: bookNameController.text, authorName: authorController.text);
    try{
      FirebaseFirestore.instance.runTransaction(
         (Transaction transaction) async {
            await FirebaseFirestore.instance.collection(fireStoreCollectionName).doc().set(book.toJson());
         }
      );
    }catch(e){
      print(e.toString());
    }
  }

  updateBook(Book book, String bookName, String authorName){
    try{
      FirebaseFirestore.instance.runTransaction((transaction) async {
        await transaction.update(book.documentReference, {'bookName': bookName, 'authorName': authorName});
      });
    }catch(e){
      print(e.toString());
    }
  }

  updateIfEditing(){
    if(isEditing){
      updateBook(currentBook, bookNameController.text, authorController.text);
      setState(() {
        isEditing = false;
      });
    }
  }
  
  deleteBook(Book book){
    FirebaseFirestore.instance.runTransaction(
      (Transaction transaction) async {
        await transaction.delete(book.documentReference);
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}


