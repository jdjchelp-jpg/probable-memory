import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wonderlapse/models/gift_model.dart';

class GiftPlannerService {
  static final GiftPlannerService _instance = GiftPlannerService._internal();
  static const String _prefsKey = 'gift_planner';

  factory GiftPlannerService() {
    return _instance;
  }

  GiftPlannerService._internal();

  Future<List<GiftModel>> loadGifts() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_prefsKey);

    if (json == null) {
      return [];
    }

    try {
      final List<dynamic> decoded = jsonDecode(json);
      return decoded
          .map((item) => GiftModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> saveGifts(List<GiftModel> gifts) async {
    final prefs = await SharedPreferences.getInstance();
    final json = jsonEncode(gifts.map((g) => g.toJson()).toList());
    await prefs.setString(_prefsKey, json);
  }

  Future<void> addGift(GiftModel gift) async {
    final gifts = await loadGifts();
    gifts.add(gift);
    await saveGifts(gifts);
  }

  Future<void> updateGift(GiftModel gift) async {
    final gifts = await loadGifts();
    final index = gifts.indexWhere((g) => g.id == gift.id);
    if (index != -1) {
      gifts[index] = gift;
      await saveGifts(gifts);
    }
  }

  Future<void> deleteGift(String giftId) async {
    final gifts = await loadGifts();
    gifts.removeWhere((g) => g.id == giftId);
    await saveGifts(gifts);
  }

  Future<void> togglePurchased(String giftId) async {
    final gifts = await loadGifts();
    final index = gifts.indexWhere((g) => g.id == giftId);
    if (index != -1) {
      gifts[index] = gifts[index].copyWith(isPurchased: !gifts[index].isPurchased);
      await saveGifts(gifts);
    }
  }

  Future<void> toggleWrapped(String giftId) async {
    final gifts = await loadGifts();
    final index = gifts.indexWhere((g) => g.id == giftId);
    if (index != -1) {
      gifts[index] = gifts[index].copyWith(isWrapped: !gifts[index].isWrapped);
      await saveGifts(gifts);
    }
  }

  /// Get gift statistics
  Future<GiftStats> getStats() async {
    final gifts = await loadGifts();
    final total = gifts.length;
    final purchased = gifts.where((g) => g.isPurchased).length;
    final wrapped = gifts.where((g) => g.isWrapped).length;
    final totalCost = gifts
        .where((g) => g.estimatedCost != null)
        .fold<double>(0, (sum, g) => sum + (g.estimatedCost ?? 0));

    return GiftStats(
      total: total,
      purchased: purchased,
      wrapped: wrapped,
      totalCost: totalCost,
      purchasePercentage: total > 0 ? (purchased / total * 100) : 0,
      wrappedPercentage: total > 0 ? (wrapped / total * 100) : 0,
    );
  }

  /// Get gifts by recipient
  Future<Map<String, List<GiftModel>>> getGiftsByRecipient() async {
    final gifts = await loadGifts();
    final grouped = <String, List<GiftModel>>{};

    for (final gift in gifts) {
      final recipient = gift.recipient ?? 'No recipient';
      grouped.putIfAbsent(recipient, () => []).add(gift);
    }

    return grouped;
  }

  /// Get gifts by category
  Future<Map<String, List<GiftModel>>> getGiftsByCategory() async {
    final gifts = await loadGifts();
    final grouped = <String, List<GiftModel>>{};

    for (final gift in gifts) {
      final category = gift.category ?? 'Uncategorized';
      grouped.putIfAbsent(category, () => []).add(gift);
    }

    return grouped;
  }
}

class GiftStats {
  final int total;
  final int purchased;
  final int wrapped;
  final double totalCost;
  final double purchasePercentage;
  final double wrappedPercentage;

  GiftStats({
    required this.total,
    required this.purchased,
    required this.wrapped,
    required this.totalCost,
    required this.purchasePercentage,
    required this.wrappedPercentage,
  });
}
