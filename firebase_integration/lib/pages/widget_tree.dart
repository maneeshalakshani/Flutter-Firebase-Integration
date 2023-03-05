import 'package:firebase_integration/models/auth.dart';
import 'package:firebase_integration/pages/home.dart';
import 'package:firebase_integration/pages/login_register.dart';
import 'package:flutter/material.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({Key? key}) : super(key: key);

  @override
  _WidgetTreeState createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().authStateChange,
      builder: (context, snapshot) {
        if(snapshot.hasData){
          return HomePage();
        }else{
          return const LoginPage();
        }
      },
    );
  }
}
