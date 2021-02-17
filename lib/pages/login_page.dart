import 'dart:developer';

//import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:mypresensi/pages/adak_controller.dart';
import 'package:mypresensi/pages/dosen_controller.dart';
import 'package:mypresensi/pages/mhs_controller.dart';
import 'package:mypresensi/pages/splashscreen.page.dart';
import 'package:mypresensi/session/session.dart';

class LoginPage extends StatefulWidget {
  static Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  RegExp regExp = RegExp(LoginPage.pattern);

  //UserCredential userCredential;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void validation() {
    if (emailController.text.trim().isEmpty) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text("Email is Empty."),
      //   ),
      // );
      log('log : Email is Empty.');
      return;
    }
    // else if (!regExp.hasMatch(emailController.text)) {
    //   // ScaffoldMessenger.of(context).showSnackBar(
    //   //   SnackBar(
    //   //     content: Text("Please enter valid email."),
    //   //   ),
    //   // );
    //   log('log : Please enter valid email.');
    //   return;
    // }
    if (passwordController.text.trim().isEmpty) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text("Password is empty."),
      //   ),
      // );
      log('log : Password is empty..');
      return;
    } else {
      loginAuth();
    }
  }

  Future loginAuth() async {

    // jika login sebagai role siswa
    FirebaseFirestore.instance
        .collection("userDatas")
        .where("nim",isEqualTo: emailController.text)
        .where("password",isEqualTo: passwordController.text)
        .limit(1)
        .get().then((value){
            if (value.docs.isNotEmpty && value.docs[0].data()['password'] == passwordController.text){
              var user = UserSession(id:value.docs[0].id, name : "",email: value.docs[0].data()['email'], role : value.docs[0].data()['rule']);
              SessionManager().save(user).then((v){ validateRole(v); });
            }
        });

    // jika login sebagai role adak
    FirebaseFirestore.instance
        .collection("userDatas")
        .where("email",isEqualTo: emailController.text)
        .limit(1)
        .get().then((value){
          if (value.docs.isNotEmpty && value.docs[0].data()['password'] == passwordController.text){
            var user = UserSession(id:value.docs[0].id, name : "",email: value.docs[0].data()['email'], role : value.docs[0].data()['rule']);
            SessionManager().save(user).then((v){ validateRole(v); });
        }
    });

    // try {
    //   userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
    //       email: emailController.text, password: passwordController.text);
    // } on FirebaseAuthException catch (e) {
    //   if (e.code == 'user-not-found') {
    //     // ScaffoldMessenger.of(context).showSnackBar(
    //     //   SnackBar(
    //     //     content: Text("No user found for that email."),
    //     //   ),
    //     // );
    //     log('log : No user found for that email.');
    //     return;
    //   } else if (e.code == 'wrong-password') {
    //     // ScaffoldMessenger.of(context).showSnackBar(
    //     //   SnackBar(
    //     //     content: Text("Wrong password provided for that user."),
    //     //   ),
    //     // );
    //     log('log : Wrong password provided for that user.');
    //     return;
    //   }
    // }
  }

  void validateRole(UserSession user){
    if (user.role == 'adak') {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AdakController()),
        );
      });
    // }
    // else if (user.role == 'dosen') {
    //   SchedulerBinding.instance.addPostFrameCallback((_) {
    //     Navigator.push(
    //       context,
    //       MaterialPageRoute(
    //           builder: (context) => DosenController()),
    //     );
    //   });
    } else if (user.role == 'user'){
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MahasiswaController()),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Container(
          alignment: Alignment.center,
          child: Text(
            'Login',
            style: TextStyle(color: Colors.black, fontSize: 30.0),
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 30.0, horizontal: 30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    child: Image.asset(
                      'images/login.png',
                      width: 250,
                      height: 250,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    labelText: 'Email',
                  ),
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(
                  height: 10.0,
                ),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    labelText: 'Password',
                  ),
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 60,
                  width: 200,
                  child: RaisedButton(
                    color: Colors.blue[900],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    onPressed: () async {
                      try {
                        validation();
                      } catch (e) {
                        print(e);
                      }
                    },
                    child: Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
