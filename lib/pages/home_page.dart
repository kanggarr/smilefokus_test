import 'package:flutter/material.dart';
import 'package:smilefokus_test/core/data/reward_data.dart';
import 'package:smilefokus_test/core/model/reward_item_model.dart';
import 'package:smilefokus_test/pages/login_page.dart';
import 'package:smilefokus_test/pages/reward_detail_page.dart';

class HomePage extends StatefulWidget {
  final String firstName;
  final String lastName;

  const HomePage({
    super.key,
    required this.firstName,
    required this.lastName,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int userPoints = 10000;
  late List<RewardItem> _rewards;

  @override
  void initState() {
    super.initState();
    _rewards = List.from(rewards);
  }

  void toggleFavorite(int index) {
    setState(() {
      _rewards[index].isFavorite = !_rewards[index].isFavorite;
    });
  }

  void signOut() {
    Navigator.pop(context);
  }

  void openRewardDetails(RewardItem item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RewardDetailPage(
          reward: item,
          userPoints: userPoints,
          onPointsUpdated: (newPoints) {
            setState(() {
              userPoints = newPoints;
            });
          },
          onFavoriteToggled: (isFavorite) {
            toggleFavorite(_rewards.indexOf(item));
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String fullName = '${widget.firstName} ${widget.lastName}';

    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFFFFFFFF),
          centerTitle: false,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('คุณ $fullName',
                  style: const TextStyle(fontSize: 16, color: Colors.black)),
              Text('$userPoints points',
                  style: const TextStyle(fontSize: 14, color: Colors.grey)),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: SafeArea(
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFF000000),
                    foregroundColor: const Color(0xFFFFFFFF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginPage()),
                    );
                  },
                  child: const Text('Sign Out'),
                ),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: GridView.builder(
                itemCount: _rewards.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.8,
                ),
                itemBuilder: (context, index) {
                  final item = _rewards[index];
                  return GestureDetector(
                    onTap: () => openRewardDetails(item),
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(12)),
                                child: Image.network(
                                  item.imageUrl,
                                  height: 100,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                top: 8,
                                right: 8,
                                child: InkWell(
                                  onTap: () => toggleFavorite(index),
                                  child: Icon(
                                    item.isFavorite
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: item.isFavorite
                                        ? Colors.red
                                        : Colors.grey,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(item.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text('${item.rewardPoints} Points'),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ));
  }
}
