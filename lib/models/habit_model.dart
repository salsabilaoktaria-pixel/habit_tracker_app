import 'dart:convert';

class Habit {
  final int? id;
  final String title;
  final String description;
  final int targetDays;
  final int progress;
  final DateTime createdAt;
  final String category;
  final String? lastCompletedDate;
  final bool isCompleted;
  final int currentStreak;
  final int bestStreak;

  Habit({
    this.id,
    required this.title,
    this.description = '',
    required this.targetDays,
    this.progress = 0,
    required this.createdAt,
    this.category = 'Lainnya',
    this.lastCompletedDate,
    this.isCompleted = false,
    this.currentStreak = 0,
    this.bestStreak = 0,
  });

  // --- GETTER TAMBAHAN UNTUK LOGIKA UI ---
  
  /// Mengecek apakah habit sudah diperbarui hari ini.
  /// Ini memperbaiki error "The getter 'isCompletedToday' isn't defined".
  bool get isCompletedToday {
    if (lastCompletedDate == null || lastCompletedDate!.isEmpty) return false;
    
    final now = DateTime.now();
    // Format YYYY-M-D agar sinkron dengan yang disimpan di Controller
    final todayStr = "${now.year}-${now.month}-${now.day}";
    return lastCompletedDate == todayStr;
  }

  // --- IMUTABILITAS DATA ---

  Habit copyWith({
    int? id,
    String? title,
    String? description,
    int? targetDays,
    int? progress,
    DateTime? createdAt,
    String? category,
    String? lastCompletedDate,
    bool? isCompleted,
    int? currentStreak,
    int? bestStreak,
  }) {
    return Habit(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      targetDays: targetDays ?? this.targetDays,
      progress: progress ?? this.progress,
      createdAt: createdAt ?? this.createdAt,
      category: category ?? this.category,
      lastCompletedDate: lastCompletedDate ?? this.lastCompletedDate,
      // Logika otomatis: jika progress baru >= target, isCompleted otomatis true
      isCompleted: isCompleted ?? (progress != null ? progress >= (targetDays ?? this.targetDays) : this.isCompleted),
      currentStreak: currentStreak ?? this.currentStreak,
      bestStreak: bestStreak ?? this.bestStreak,
    );
  }

  // --- KONVERSI DATA (SQLITE/JSON) ---

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'targetDays': targetDays,
      'progress': progress,
      'createdAt': createdAt.toIso8601String(),
      'category': category,
      'lastCompletedDate': lastCompletedDate,
      'isCompleted': isCompleted ? 1 : 0, 
      'currentStreak': currentStreak,
      'bestStreak': bestStreak,
    };
  }

  factory Habit.fromMap(Map<String, dynamic> map) {
    return Habit(
      id: map['id'] as int?,
      title: map['title']?.toString() ?? '',
      description: map['description']?.toString() ?? '',
      targetDays: (map['targetDays'] as num?)?.toInt() ?? 0,
      progress: (map['progress'] as num?)?.toInt() ?? 0,
      createdAt: map['createdAt'] != null 
          ? DateTime.tryParse(map['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
      category: map['category']?.toString() ?? 'Lainnya',
      lastCompletedDate: map['lastCompletedDate']?.toString(),
      isCompleted: map['isCompleted'] == 1 || map['isCompleted'] == true,
      currentStreak: (map['currentStreak'] as num?)?.toInt() ?? 0,
      bestStreak: (map['bestStreak'] as num?)?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());
  factory Habit.fromJson(String source) => Habit.fromMap(json.decode(source));
}