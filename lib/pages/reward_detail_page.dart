import 'package:flutter/material.dart';
import 'package:smilefokus_test/core/model/reward_item_model.dart';

class RewardDetailPage extends StatefulWidget {
  final RewardItem reward;
  final int userPoints;
  final ValueChanged<int> onPointsUpdated;
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
  late bool isFavorite;
  late int currentUserPoints;

  @override
  void initState() {
    super.initState();
    isFavorite = widget.reward.isFavorite;
    currentUserPoints = widget.userPoints;
  }

  void toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
      widget.reward.isFavorite = isFavorite;
      widget.onFavoriteToggled(isFavorite);
    });
  }

  Future<void> tryRedeem() async {
    if (currentUserPoints < widget.reward.rewardPoints) {
      return;
    }

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

    if (confirmed == true) {
      setState(() {
        currentUserPoints -= widget.reward.rewardPoints;
      });
      widget.onPointsUpdated(currentUserPoints);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            'Redeemed ${widget.reward.name}! Remaining points: $currentUserPoints'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final canRedeem = currentUserPoints >= widget.reward.rewardPoints;

    return Scaffold(
      appBar: AppBar(),
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
                  icon:
                      Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
                  onPressed: toggleFavorite,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '${widget.reward.rewardPoints} Points',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 24),
            Text('Detail:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            Text(
              widget.reward.rewardDesc,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
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
