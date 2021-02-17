import 'package:flutter/material.dart';
import 'package:mypresensi/pages/account.dart';
import 'package:mypresensi/pages/home_page_adak.dart';
import 'package:mypresensi/pages/list_class_adak.dart';

class AdakController extends StatefulWidget {
  @override
  _AdakControllerState createState() => _AdakControllerState();
}

class _AdakControllerState extends State<AdakController> {
  PageController _pageController = PageController();
  List<Widget> _screen = [
    // HomePageAdak(),
    ListClassAdak(),
    Account(),
  ];

  int _selectedIndex = 0;
  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onItemTapped(int selectedIndex) {
    _pageController.jumpToPage(selectedIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: _screen,
        onPageChanged: _onPageChanged,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: _onItemTapped,
        items: [
          // BottomNavigationBarItem(
          //     icon: Icon(
          //       Icons.home_outlined,
          //       color: _selectedIndex == 0 ? Color.fromARGB(255, 32, 178, 170) : Colors.grey,
          //     ),
          //     label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.list_alt_outlined,
                color: _selectedIndex == 0 ? Color.fromARGB(255, 32, 178, 170) : Colors.grey,
              ),
              label: 'List Class'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                color: _selectedIndex == 1 ? Color.fromARGB(255, 32, 178, 170) : Colors.grey,
              ),
              label: 'Account'),
        ],
      ),
    );
  }
}
