import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smilefokus_test/core/data/reward_data.dart';
import 'package:smilefokus_test/core/model/reward_item_model.dart';
import 'package:smilefokus_test/core/provider/provider.dart';
import 'package:smilefokus_test/pages/home_page.dart';
import 'package:smilefokus_test/pages/wishlist_page.dart';

class Home extends StatefulWidget {
  final String firstName;
  final String lastName;

  const Home({
    super.key,
    required this.firstName,
    required this.lastName,
  });

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late List<RewardItem> _sharedRewards;

  @override
  void initState() {
    super.initState();
    _sharedRewards = List.from(rewards);
  }

  @override
  Widget build(BuildContext context) {
    final navigationProvider = Provider.of<NavigationProvider>(context);

    int userPoints = 10000;

    void updateUserPoints(int newPoints) {
      setState(() {
        userPoints = newPoints;
      });
    }

    final pages = [
      HomePage(
        firstName: widget.firstName,
        lastName: widget.lastName,
        rewards: _sharedRewards,
      ),
      WishlistPage(
        allRewards: rewards,
        userPoints: userPoints,
        onPointsUpdated: updateUserPoints,
      ),
    ];

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) {
          navigationProvider.currentIndex = value;
        },
        currentIndex: navigationProvider.currentPage,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite), label: 'wishlist'),
        ],
      ),
      body: pages[navigationProvider.currentPage],
    );
  }
}
