import 'package:flutter/material.dart';
import 'package:smilefokus_test/core/model/reward_item_model.dart';
import 'package:smilefokus_test/pages/reward_detail_page.dart';

class WishlistPage extends StatefulWidget {
  // รับข้อมูลรางวัลทั้งหมด คะแนนของผู้ใช้และอัปเดตคะแนน
  final List<RewardItem> allRewards;
  final int userPoints;
  final ValueChanged<int> onPointsUpdated;

  const WishlistPage({
    super.key,
    required this.allRewards,
    required this.userPoints,
    required this.onPointsUpdated,
  });

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  // กรองเฉพาะรางวัลที่ถูกกดถูกใจเท่านั้น
  List<RewardItem> get savedItems =>
      widget.allRewards.where((item) => item.isFavorite).toList();

  // ฟังก์ชันสลับสถานะถูกใจของรางวัล
  void toggleFavorite(RewardItem item) {
    setState(() {
      item.isFavorite = !item.isFavorite;
    });
  }

  // เปิดหน้าแสดงรายละเอียดของรางวัล
  void openRewardDetails(RewardItem item) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RewardDetailPage(
          reward: item,
          userPoints: widget.userPoints,
          onPointsUpdated: widget.onPointsUpdated,
          onFavoriteToggled: (isFav) {
            // เมื่อสถานะถูกใจในหน้ารายละเอียดเปลี่ยน ให้ปรับสถานะในหน้า wishlist ด้วย
            setState(() {
              item.isFavorite = isFav;
            });
          },
        ),
      ),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final items = savedItems; // รายการรางวัลที่ถูกใจทั้งหมด

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wishlist'),
      ),
      body: items.isEmpty
          // กรณีไม่มีรายการที่ถูกใจแสดงข้อความแจ้ง
          ? const Center(
              child: Text(
                'ไม่มีรายการที่บันทึกไว้',
                style: TextStyle(fontSize: 18),
              ),
            )
          // กรณีมีรายการถูกใจ
          : SafeArea(
              child: Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: GridView.builder(
                    itemCount: items.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 0.8,
                    ),
                    itemBuilder: (context, index) {
                      final item = items[index];
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
                                      onTap: () => toggleFavorite(item),
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
                                child: Text(
                                  item.name,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                ),
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
            ),
    );
  }
}
