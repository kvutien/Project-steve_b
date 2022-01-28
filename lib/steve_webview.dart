/*
  Flutter 2.8.1 stable, Android Studio 2021.1 Bumblebee, Android SDK 32
  Navigate between screens of Steve Observer
 */
import 'package:flutter/material.dart';
import 'package:steve_b/tab1.dart';
import 'package:steve_b/tab2.dart';

class SteveWebview extends StatefulWidget {
  const SteveWebview({Key? key}) : super(key: key);
  @override
  _SteveWebviewState createState() => _SteveWebviewState();
}

class _SteveWebviewState extends State<SteveWebview> {
  // this key makes any widget in the widget tree access the WebView state
  // final GlobalKey webViewKey = GlobalKey();
  int _selectedIndex = 0; // Tutorial page is displayed by default
  static List<Widget> tabs = <Widget> [
    const Tab1(), // display tutorial page
    const Tab2(), // display vegetation page
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Steve_B Earth Observer"),
        centerTitle: true,
        backgroundColor: Colors.lightGreen,
        foregroundColor: Colors.brown,
        toolbarHeight: 18.0,
      ),
      body: tabs[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Theme.of(context).textSelectionTheme.selectionColor,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.help_outline),
            label: 'Help',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.agriculture_outlined),
            label: 'Vegetation',
          ),
          /*const BottomNavigationBarItem(
            icon: Icon(Icons.radar),
            label: 'Card3',
          ),*/
        ],
      ),
    );
  }
}
