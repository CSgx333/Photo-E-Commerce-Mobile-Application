import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pigment/Widget/login.dart';
import 'package:pigment/Widget/search.dart';
import 'package:pigment/homePage.dart';
import 'package:pigment/imagesPage.dart';
import 'package:pigment/listPage.dart';
import 'package:pigment/likePage.dart';

import 'Widget/user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  int i = 0;
  int color = 0;
  int _currentIndex = 0;
  final screens = [
    homePage(),
    imagesPage(),
    likePage(),
    listPage(),
  ];

  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          flexibleSpace: gradient(),
          leading: Container(
            child: Image(
              image: AssetImage('images/logo.png'),
            ),
          ),
          actions: [
            search1(),
            account()
          ],
        ),
        body: screens[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          iconSize: 20,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.image),
              label: 'Images',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border),
              label: 'Like',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: 'Cart',
            ),
          ],
          selectedItemColor: Color(0xFFff4772),
          onTap: (index) {
            setState(() {
              _currentIndex = index;
              color = 1;
              if(_currentIndex == 0){
                color = 0;
              };
            });
          },
        ),
      ),
    );
  }
}

class search1 extends StatelessWidget {
  const search1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: Icon(
          Icons.search,
        ),
        onPressed: () => {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return search();
          })),
        });
  }
}
class account extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: Icon(
          Icons.account_circle,
        ),
        onPressed: () => {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return Login();
          })),
        });
  }
}

class gradient extends StatelessWidget {
  const gradient({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Color(0xFF0f0735),
            Color(0xFF24307a),
          ],
        ),
      ),
    );
  }
}




