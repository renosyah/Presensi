import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mypresensi/pages/listAgenda.dart';
import 'package:mypresensi/pages/scan_class.dart';


class HomePageMahasiswa extends StatefulWidget {
  @override
  _HomePageMahasiswaState createState() => _HomePageMahasiswaState();
}

class _HomePageMahasiswaState extends State<HomePageMahasiswa> {
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
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: size.height * 0.55,
            decoration: BoxDecoration(
              color: Colors.blue[600],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 70.0, horizontal: 20.0),
            child: Text(
              "${user.email} \nHave A Good Day",
              style: Theme.of(context)
                  .textTheme
                  .headline5
                  .copyWith(fontWeight: FontWeight.w900, color: Colors.white),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 200.0, horizontal: 20.0),
            child: Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: 0.85,
                children: <Widget>[
                  CategoryCard(
                    title: "Scan Class",
                    gambar: "images/qr.jpg",
                    press: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => ScanClass()));
                    },
                  ),
                  CategoryCard(
                      title: "Agenda",
                      gambar: "images/cal.png",
                      press: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ListAgenda()));
                      }),
                ],
              ),
            ),
          ),
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
            color: Colors.white,
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
