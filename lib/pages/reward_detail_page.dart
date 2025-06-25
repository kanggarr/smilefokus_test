import 'package:flutter/material.dart';
import 'package:smilefokus_test/core/model/reward_item_model.dart';

class RewardDetailPage extends StatefulWidget {
  // ข้อมูลรางวัลที่จะแสดง
  final RewardItem reward;
  // คะแนนของผู้ใช้ปัจจุบัน
  final int userPoints;
  // คะแนนที่อัปเดตหลังแลกรางวัล
  final ValueChanged<int> onPointsUpdated;
  // สถานะถูกใจรางวัล
  final ValueChanged<bool> onFavoriteToggled;

  const RewardDetailPage({
    super.key,
    required this.reward,
    required this.userPoints,
    required this.onPointsUpdated,
    required this.onFavoriteToggled,
  });

  @override
  State<RewardDetailPage> createState() => _RewardDetailPageState();
}

class _RewardDetailPageState extends State<RewardDetailPage> {
  late int currentUserPoints;

  @override
  void initState() {
    super.initState();
    // กำหนดคะแนนเริ่มต้นจากค่า userPoints ที่ส่งมา
    currentUserPoints = widget.userPoints;
  }

  // ฟังก์ชันสำหรับ toggle สถานะถูกใจรางวัล
  void toggleFavorite() {
    setState(() {
      widget.reward.isFavorite = !widget.reward.isFavorite;
    });
    // สถานะกลับไปยังหน้าเรียกใช้
    widget.onFavoriteToggled(widget.reward.isFavorite);
  }

  // ฟังก์ชันลองแลกรางวัล
  Future<void> tryRedeem() async {
    // ถ้าคะแนนไม่พอแจ้งเตือนและไม่ทำอะไรต่อ
    if (currentUserPoints < widget.reward.rewardPoints) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Insufficient points to redeem')),
      );
      return;
    }

    // แสดง dialog ยืนยันการแลก
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Redemption'),
        content: Text(
            'Redeem ${widget.reward.name} for ${widget.reward.rewardPoints} points?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Redeem')),
        ],
      ),
    );

    // ถ้าผู้ใช้กด Redeem
    if (confirmed == true) {
      setState(() {
        // หักคะแนน
        currentUserPoints -= widget.reward.rewardPoints;
      });
      // แจ้งคะแนนใหม่กลับไปยังหน้าเรียกใช้
      widget.onPointsUpdated(currentUserPoints);
      // แสดง snackbar ยืนยันแลกสำเร็จ
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            'Redeemed ${widget.reward.name}! Remaining points: $currentUserPoints'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    // เช็คว่าผู้ใช้มีคะแนนเพียงพอแลกหรือไม่
    final canRedeem = currentUserPoints >= widget.reward.rewardPoints;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reward Detail'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                widget.reward.imageUrl,
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.width * 0.8,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    widget.reward.name,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: Icon(widget.reward.isFavorite
                      ? Icons.favorite
                      : Icons.favorite_border),
                  onPressed: toggleFavorite,
                ),
              ],
            ),
            const SizedBox(height: 8),
            // แสดงจำนวนคะแนนที่ต้องใช้แลก
            Text(
              '${widget.reward.rewardPoints} Points',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 24),
            // รายละเอียดของรางวัล
            const Text('Detail:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            Text(
              widget.reward.rewardDesc,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 40),
            // ปุ่ม Redeem จะถูก enable ก็ต่อเมื่อคะแนนพอ
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.grey,
                  disabledForegroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: canRedeem ? tryRedeem : null,
                child: Text(canRedeem ? 'Redeem' : 'Insufficient Points'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
