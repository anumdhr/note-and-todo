import 'package:flutter/material.dart';

import '../todo/screens/todo_screen.dart';
import '../noteapp/home_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>  with TickerProviderStateMixin{
late TabController tabController;
@override
void initState() {
  tabController = TabController(length: 2, vsync: this,initialIndex: 0);
  super.initState();
}
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            TabBar(
              controller: tabController,
                tabs: [
              Tab(
                icon: Icon(Icons.note_alt_rounded,
                  color: Colors.black87,
                ),
              ),
              Tab(
                icon: Icon(Icons.today_outlined,
                  color: Colors.black87,
                ),
              )
            ]),
            Expanded(
              child: TabBarView(
                controller: tabController,
                  children: [
                    HomeScreen(),
                    Todo(),

              ]),
            )
          ],

        ),
      ),
    );
  }
}
