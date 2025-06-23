import 'package:flutter/material.dart';
import 'package:smilefokus_test/core/model/reward_item_model.dart';
import 'package:smilefokus_test/pages/reward_detail_page.dart';

class WishlistPage extends StatefulWidget {
  final List<RewardItem> allRewards;

  const WishlistPage({super.key, required this.allRewards});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  late List<RewardItem> savedItems;

  @override
  void initState() {
    super.initState();
    savedItems = widget.allRewards.where((item) => item.isFavorite).toList();
  }

  void toggleFavorite(RewardItem item) {
    setState(() {
      item.isFavorite = !item.isFavorite;
      if (!item.isFavorite) {
        savedItems.removeWhere((element) => element.id == item.id);
      }
    });
  }

  void openRewardDetails(RewardItem item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RewardDetailPage(
          reward: item,
          userPoints: 0, // TODO: Replace with actual user points
          onPointsUpdated: (int newPoints) {
            // TODO: Implement points update logic
          },
          onFavoriteToggled: (bool isFavorite) {
            item.isFavorite = isFavorite;
            toggleFavorite(item);
            setState(() {});
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wishlist')),
      body: savedItems.isEmpty
          ? const Center(
              child: Text(
                'ไม่มีรายการที่บันทึกไว้',
                style: TextStyle(fontSize: 18),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                itemCount: savedItems.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemBuilder: (context, index) {
                  final item = savedItems[index];
                  return GestureDetector(
                    onTap: () => openRewardDetails(item),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(12)),
                              child: Image.network(
                                item.imageUrl,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 6),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    item.name,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    item.isFavorite
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: item.isFavorite
                                        ? Colors.red
                                        : Colors.grey,
                                  ),
                                  onPressed: () => toggleFavorite(item),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
