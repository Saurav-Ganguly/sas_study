class Chapter {
  final int id;
  final int topicId;
  final String name;

  Chapter({required this.id, required this.topicId, required this.name});

  factory Chapter.fromJson(Map<String, dynamic> json) {
    return Chapter(
      id: json['id'] as int,
      topicId: json['topic_id'] as int,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'topic_id': topicId,
      'name': name,
    };
  }
}
