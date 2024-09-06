import 'package:flutter/material.dart';
import 'package:movie_hub/views/home_screen.dart';
import 'package:movie_hub/views/playing_screen.dart';
import 'package:movie_hub/views/search.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentIndex = 0;

  List<Widget> bodyList = [
    const HomeScreen(),
    const PlayingScreen(),
    const SearchScreen(),
  ];

    void onitemTaped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: bodyList[currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: onitemTaped,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.play_arrow),
              label: 'Playing',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Search',
            ),
           
          ],
        ));
  }
}
