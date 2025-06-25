import 'package:flutter/material.dart';
import 'package:smilefokus_test/core/model/reward_item_model.dart';
import 'package:smilefokus_test/pages/login_page.dart';
import 'package:smilefokus_test/pages/reward_detail_page.dart';

class HomePage extends StatefulWidget {
  // รับข้อมูลชื่อ, นามสกุล และรายการของรางวัลผ่าน constructor
  final String firstName;
  final String lastName;
  final List<RewardItem> rewards;

  const HomePage({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.rewards,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // คะแนนเริ่มต้นของผู้ใช้
  int userPoints = 10000;

  // ฟังก์ชันสลับสถานะ favorite ของรางวัลที่ตำแหน่ง index ที่กำหนด
  void toggleFavorite(int index) {
    setState(() {
      widget.rewards[index].isFavorite = !widget.rewards[index].isFavorite;
    });
  }

  // ฟังก์ชันออกจากระบบ
  void signOut() {
    Navigator.pop(context);
  }

  // เปิดหน้ารายละเอียดของรางวัล พร้อมส่งข้อมูลคะแนนและ callback สำหรับอัปเดตคะแนนและสถานะชอบ
  void openRewardDetails(RewardItem item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RewardDetailPage(
          reward: item,
          userPoints: userPoints,
          onPointsUpdated: (newPoints) {
            // อัปเดตคะแนนใหม่เมื่อรับ callback จากหน้า detail
            setState(() {
              userPoints = newPoints;
            });
          },
          onFavoriteToggled: (isFavorite) {
            // อัปเดตสถานะชอบเมื่อรับ callback จากหน้า detail
            toggleFavorite(widget.rewards.indexOf(item));
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ชื่อผู้ใช้งาน firstName และ lastName
    String fullName = '${widget.firstName} ${widget.lastName}';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
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
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
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
            // แสดงรายการของรางวัลในรูปแบบ Grid 2 คอลัมน์
            child: GridView.builder(
              itemCount: widget.rewards.length, // จำนวนไอเทมทั้งหมด
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 2 คอลัมน์
                mainAxisSpacing: 16, // ช่องว่างแนวตั้งระหว่างไอเทม
                crossAxisSpacing: 16, // ช่องว่างแนวนอนระหว่างไอเทม
                childAspectRatio: 0.8, // อัตราส่วนความกว้างต่อความสูงของไอเทม
              ),
              itemBuilder: (context, index) {
                final item = widget.rewards[index];
                return GestureDetector(
                  onTap: () =>
                      openRewardDetails(item), // กดเปิดรายละเอียดรางวัล
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
                            // รูปภาพรางวัลมุมบน
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
                            // ปุ่มกดชอบ (favorite) อยู่มุมบนขวาของรูปภาพ
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
                        // ชื่อรางวัล
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(item.name,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        // คะแนนที่ต้องใช้แลกรางวัล
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
