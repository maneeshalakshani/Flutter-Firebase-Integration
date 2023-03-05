import 'package:firebase_integration/pages/widget_tree.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import './models/book.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // runApp(BookApp());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: const WidgetTree(),
    );
  }
}


class BookApp extends StatelessWidget {
  const BookApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BookFireBaseDemo(),
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

  getAllBooks() {
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
        // return const SizedBox();
        return buildList(context, snapshot.data?.docs);
      },
    );
  }

  Widget buildList(BuildContext context, List<DocumentSnapshot>? snapshot){
    return ListView.builder(
      itemCount: snapshot!.length,
      itemBuilder: (context, index){
        return listItemBuilder(context, snapshot[index]);
      },
    );
  }

  Widget listItemBuilder(BuildContext context, DocumentSnapshot data){
    final book = Book.fromSnapshot(data);
    return Padding(
      key: ValueKey(book.bookName),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 3),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.yellow,
        ),
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

  button(){
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () {
          if(isEditing == true){
            updateIfEditing();
          }else{
            addBook();
          }
          setState(() {
            textFieldVisibility = false;
          });
        },
        child: Text(isEditing ? "Update" : "Add"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print(getAllBooks());
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Book List"),
        actions: [
          IconButton(
            onPressed: (){
              setState(() {
                textFieldVisibility = !textFieldVisibility;
              });
            },
            icon: const Icon(Icons.add, color: Colors.yellow),
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            textFieldVisibility
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: bookNameController,
                        decoration: const InputDecoration(
                          labelText: "Book Name",
                        ),
                      ),
                      TextFormField(
                        controller: authorController,
                        decoration: const InputDecoration(
                          labelText: "Author Name",
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 5, bottom: 5),
                        child: button(),
                      ),
                    ],
                  )
                : SizedBox(),
            Text("Books"),
            SizedBox(
              height: 20,
            ),
            Flexible(
              child: buildBody(context),
            ),
          ],
        ),
      ),
    );
  }
}