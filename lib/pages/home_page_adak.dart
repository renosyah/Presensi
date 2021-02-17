import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mypresensi/pages/account.dart';
import 'package:mypresensi/pages/list_class_adak.dart';
import 'package:mypresensi/session/session.dart';

import 'make_agenda.dart';
import 'make_class.dart';

class HomePageAdak extends StatefulWidget {
  @override
  _HomePageAdakState createState() => _HomePageAdakState();
}

class _HomePageAdakState extends State<HomePageAdak> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: size.height * 0.55,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 32, 178, 170),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 20, top: 80),
            child: FutureBuilder<UserSession>(
              future: SessionManager().load(),
              builder: (context,snapshot){
                if (snapshot.hasData){
                  return Text(
                    "${snapshot.data.email} \nHave A Good Day",
                    style: Theme.of(context)
                        .textTheme
                        .headline5
                        .copyWith(fontWeight: FontWeight.w900, color: Colors.white),
                  );
                }
                return Text(
                  "Have A Good Day",
                  style: Theme.of(context)
                      .textTheme
                      .headline5
                      .copyWith(fontWeight: FontWeight.w900, color: Colors.white),
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 220, left: 10, right: 10),
            child: Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: 0.85,
                children: <Widget>[],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String gambar;
  final String title;
  final Function press;

  const CategoryCard({
    Key key,
    this.gambar,
    this.title,
    this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(13),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(13),
            boxShadow: [
              BoxShadow(
                  offset: Offset(0, 17),
                  blurRadius: 17,
                  spreadRadius: -23,
                  color: Colors.blue)
            ]),
        child: Material(
          color: Colors.transparent,
          child: RaisedButton(
            color: Color.fromARGB(255, 230, 230, 250),
            onPressed: press,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: <Widget>[
                  Spacer(),
                  Image.asset(gambar),
                  Spacer(),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        .copyWith(fontSize: 23),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
