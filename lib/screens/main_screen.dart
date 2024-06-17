import 'package:flutter/material.dart';

import '../todo/screens/todo_screen.dart';
import '../noteapp/note_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  late TabController tabController;
  int activeIndex = 0;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this, initialIndex: activeIndex);
    tabController.addListener(() {
      setState(() {
        activeIndex = tabController.index;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            TabBar(controller: tabController, tabs: [
              Tab(
                icon: Icon(
                  Icons.note_alt_rounded,
                  color: activeIndex == 0 ? Colors.orange : Colors.grey,
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.today_outlined,
                  color: activeIndex == 0 ? Colors.grey : Colors.orange,
                ),
              )
            ]),
            Expanded(
              child: TabBarView(controller: tabController, children: [
                NotePage(),
                TodoPage(),
              ]),
            )
          ],
        ),
      ),
    );
  }
}
