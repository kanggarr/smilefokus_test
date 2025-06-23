import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
  late List<Widget> pages;

  @override
  void initState() {
    super.initState();
    pages = [
      HomePage(
        firstName: widget.firstName,
        lastName: widget.lastName,
      ),
      WishlistPage(allRewards: []),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final navigationProvider = Provider.of<NavigationProvider>(context);

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) {
          navigationProvider.currentIndex = value;
        },
        currentIndex: navigationProvider.currentPage,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'home',
            backgroundColor: Colors.amber,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'wishlist',
            backgroundColor: Colors.red,
          ),
        ],
      ),
      body: pages[navigationProvider.currentPage],
    );
  }
}
