import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:parichay/colors/pallete.dart';
import 'package:parichay/screens/favourites.dart';
import 'package:parichay/screens/home.dart';
import 'package:parichay/screens/planner.dart';
import 'package:parichay/screens/planner_pro_input.dart';
import 'package:parichay/screens/profile.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({Key? key, required this.getIndex}) : super(key: key);
  final int getIndex;

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen>
    with SingleTickerProviderStateMixin {
  TabController? tabController;
  int selectedIndex = 0;

  @override
  void initState() {
    selectedIndex = widget.getIndex;
    tabController = TabController(length: 4, vsync: this);
    tabController!.index = widget.getIndex;
    super.initState();
  }

  getSelectedIndex(int index) {
    setState(() {
      selectedIndex = index;
      tabController!.index = selectedIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        controller: tabController,
        children: [Home(), Favourites(), Profile(), TripPlannerPro()],
      ),
      // backgroundColor: Color(0x00FFFFFF),
      bottomNavigationBar: CurvedNavigationBar(
        height: 60,
        index: selectedIndex,
        // useLegacyColorScheme: true,
        onTap: (index) {
          setState(() {
            print(index);
            selectedIndex = index;
            print(selectedIndex);
            tabController!.index = selectedIndex;
          });
        },
        backgroundColor: Color(0x00FFFFFF),

        animationDuration: Duration(milliseconds: 300),
        color: Pallete.primary,
        items: [
          Icon(
            Icons.home,
            color: Pallete.whiteColor,
          ),
          Icon(
            Icons.favorite,
            color: Pallete.whiteColor,
          ),
          Icon(
            Icons.person,
            color: Pallete.whiteColor,
          ),
          Icon(
            Icons.map,
            color: Pallete.whiteColor,
          )
        ],
      ),
    );
  }
}
