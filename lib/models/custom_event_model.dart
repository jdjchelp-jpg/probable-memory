class CustomEventModel {
  final String id;
  final String name;
  final DateTime targetDate;
  final String icon;
  final String themeId;
  final bool isPinned;
  final String? description;
  final DateTime createdAt;

  CustomEventModel({
    required this.id,
    required this.name,
    required this.targetDate,
    required this.icon,
    required this.themeId,
    this.isPinned = false,
    this.description,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  CustomEventModel copyWith({
    String? id,
    String? name,
    DateTime? targetDate,
    String? icon,
    String? themeId,
    bool? isPinned,
    String? description,
    DateTime? createdAt,
  }) {
    return CustomEventModel(
      id: id ?? this.id,
      name: name ?? this.name,
      targetDate: targetDate ?? this.targetDate,
      icon: icon ?? this.icon,
      themeId: themeId ?? this.themeId,
      isPinned: isPinned ?? this.isPinned,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'targetDate': targetDate.toIso8601String(),
      'icon': icon,
      'themeId': themeId,
      'isPinned': isPinned,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory CustomEventModel.fromJson(Map<String, dynamic> json) {
    return CustomEventModel(
      id: json['id'] as String,
      name: json['name'] as String,
      targetDate: DateTime.parse(json['targetDate'] as String),
      icon: json['icon'] as String,
      themeId: json['themeId'] as String,
      isPinned: json['isPinned'] as bool? ?? false,
      description: json['description'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
