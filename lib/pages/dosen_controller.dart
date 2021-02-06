import 'package:flutter/material.dart';
import 'package:mypresensi/pages/account.dart';
import 'package:mypresensi/pages/home_page_dosen.dart';
import 'package:mypresensi/pages/listClass.dart';


class DosenController extends StatefulWidget {
  @override
  _DosenControllerState createState() => _DosenControllerState();
}

class _DosenControllerState extends State<DosenController> {
  PageController _pageController = PageController();
  List<Widget> _screen = [
    HomePageDosen(),
    ListClass(),
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
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home_outlined,
                color: _selectedIndex == 0 ? Colors.blue[600] : Colors.grey,
              ),
              label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.list_alt_outlined,
                color: _selectedIndex == 1 ? Colors.blue[600] : Colors.grey,
              ),
              label: 'List Class'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                color: _selectedIndex == 2 ? Colors.blue[600] : Colors.grey,
              ),
              label: 'Account'),
        ],
      ),
    );
  }
}
