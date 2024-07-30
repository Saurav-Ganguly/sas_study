class ShortNote {
  final int id;
  final int chapterId;
  final String notes;

  ShortNote({required this.id, required this.chapterId, required this.notes});

  factory ShortNote.fromJson(Map<String, dynamic> json) {
    return ShortNote(
      id: json['id'] as int,
      chapterId: json['chapter_id'] as int,
      notes: json['notes'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chapter_id': chapterId,
      'notes': notes,
    };
  }
}
