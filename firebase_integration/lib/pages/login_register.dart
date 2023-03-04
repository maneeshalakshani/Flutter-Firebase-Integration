import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  String? errorMsg = '';
  bool isLogin = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> signInWithEmailAndPassword() async {
    try{
      await Auth().signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
      );
    }on FirebaseAuthException catch (e){
      setState(() {
        errorMsg = e.message;
      });
    }
  }

  Future<void> createUserWithEmailAndPassword() async {
    try{
      await Auth().createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
      );
    }on FirebaseAuthException catch (e) {
      setState(() {
        errorMsg = e.message;
      });
    }
  }

  Widget textField(String title, TextEditingController controller){
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: title,
      )
    );
  }

  Widget errorMessage(){
    return Text(errorMsg == '' ? '' : errorMsg!);
  }

  Widget submitButon(BuildContext context){
    return ElevatedButton(
      onPressed: (){
        isLogin ? signInWithEmailAndPassword : createUserWithEmailAndPassword;
      },
      child: Text(isLogin ? "Login" : "Register"),
    );
  }

  Widget loginOrRegisterButton() {
    return TextButton(
      onPressed: (){
        setState(() {
          isLogin = !isLogin;
        });
      },
      child: Text(isLogin ? 'Register instead' : 'Login instead'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login/Register"),
      ),
      body: Column(
        children: [
          textField('email', emailController),
          textField('password', passwordController),
          errorMessage(),
          submitButon(context),
          loginOrRegisterButton(),
        ],
      ),
    );
  }
}
