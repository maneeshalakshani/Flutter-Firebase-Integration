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

  Widget buildBody(BuildContext context){
    return StreamBuilder<QuerySnapshot>(
      stream: getAllBooks(),
      builder: (context, snapshot) {
        if(snapshot.hasError){
          return Text('Error ${snapshot.error}');
        }
        if(snapshot.hasData){
          print("Dcument -> ${snapshot.data?.docs.length}");
          return buildList(context, snapshot.data?.docs);
        }
        return const SizedBox();
      },
    );
  }

  Widget buildList(BuildContext context, List<QueryDocumentSnapshot<Object?>>? snapshot){
    return ListView(
      children: snapshot!.map((data) => listItemBuilder(context, data)).toList(),
    );
  }

  Widget listItemBuilder(BuildContext context, DocumentSnapshot data){
    final book = Book.fromSnapshot(data);
    return Padding(
      key: ValueKey(book.bookName),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 3),
      child: Container(
        child: Column(
          children: [
            Text(book.bookName),
            Text(book.authorName),
            IconButton(
              onPressed: (){
                deleteBook(book);
              },
              icon: Icon(Icons.delete, color: Colors.red,),
            ),
            IconButton(
              onPressed: (){
                setUpdateUI(book);
              },
              icon: Icon(Icons.update, color: Colors.green,),
            ),
          ],
        ),
      ),
    );
  }

  setUpdateUI(Book book){
    bookNameController.text = book.bookName;
    authorController.text = book.authorName;
    setState(() {
      isEditing = true;
      textFieldVisibility = true;
      currentBook = book;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}


