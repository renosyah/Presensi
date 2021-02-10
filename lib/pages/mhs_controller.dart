import 'package:flutter/material.dart';
import 'package:mypresensi/pages/account.dart';
import 'package:mypresensi/pages/home_page_mhs.dart';
import 'package:mypresensi/pages/list_class_adak.dart';

class MahasiswaController extends StatefulWidget {
  @override
  _MahasiswaControllerState createState() => _MahasiswaControllerState();
}

class _MahasiswaControllerState extends State<MahasiswaController> {
  PageController _pageController = PageController();

  List<Widget> _screen = [
    HomePageMahasiswa(),
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
              label: 'Presents'),
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
