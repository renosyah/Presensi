import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mypresensi/pages/welcome_page.dart';

class Account extends StatefulWidget {
  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  DateTime now = DateTime.now();

  User user;
  Future<void> getUserData() async {
    User userData = FirebaseAuth.instance.currentUser;
    setState(() {
      user = userData;
    });
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Account',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  '$now',
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
            ),
            user == null ? Text("Have A Good Day") : buildCard(),
            Center(
              child: user == null
                  ? FlatButton(
                      textColor: Colors.white,
                      color: Colors.lightBlue,
                      child: Text("Login"),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => WelcomePage()));
                      },
                    )
                  : Container(
                      child: Column(),
                    ),
            ),
            MaterialButton(
              color: Colors.yellow,
              child: Text('Log Out'),
              onPressed: () async {
                WidgetsBinding.instance.addPostFrameCallback((_) async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => WelcomePage()),
                  );
                });
                // logout(context);
              },
            )
          ],
        ),
      ),
    );
  }

  Widget buildCard() => Card(
        margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 100,
            child: Column(
              children: <Widget>[
                Text(
                  "Email ",
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 12.0),
                Text(
                  "${user.email}",
                  style: TextStyle(fontSize: 18.0),
                ),
              ],
            ),
          ),
        ),
      );
}
