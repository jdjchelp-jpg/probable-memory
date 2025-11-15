class GiftModel {
  final String id;
  final String name;
  final String? recipient;
  final String? category;
  final double? estimatedCost;
  final bool isPurchased;
  final bool isWrapped;
  final String? notes;
  final DateTime createdAt;

  GiftModel({
    required this.id,
    required this.name,
    this.recipient,
    this.category,
    this.estimatedCost,
    this.isPurchased = false,
    this.isWrapped = false,
    this.notes,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  GiftModel copyWith({
    String? id,
    String? name,
    String? recipient,
    String? category,
    double? estimatedCost,
    bool? isPurchased,
    bool? isWrapped,
    String? notes,
    DateTime? createdAt,
  }) {
    return GiftModel(
      id: id ?? this.id,
      name: name ?? this.name,
      recipient: recipient ?? this.recipient,
      category: category ?? this.category,
      estimatedCost: estimatedCost ?? this.estimatedCost,
      isPurchased: isPurchased ?? this.isPurchased,
      isWrapped: isWrapped ?? this.isWrapped,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'recipient': recipient,
      'category': category,
      'estimatedCost': estimatedCost,
      'isPurchased': isPurchased,
      'isWrapped': isWrapped,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory GiftModel.fromJson(Map<String, dynamic> json) {
    return GiftModel(
      id: json['id'] as String,
      name: json['name'] as String,
      recipient: json['recipient'] as String?,
      category: json['category'] as String?,
      estimatedCost: (json['estimatedCost'] as num?)?.toDouble(),
      isPurchased: json['isPurchased'] as bool? ?? false,
      isWrapped: json['isWrapped'] as bool? ?? false,
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
