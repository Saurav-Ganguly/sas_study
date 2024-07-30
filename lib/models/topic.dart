class Topic {
  final int id;
  final int subjectId;
  final String name;

  Topic({required this.id, required this.subjectId, required this.name});

  factory Topic.fromJson(Map<String, dynamic> json) {
    return Topic(
      id: json['id'] as int,
      subjectId: json['subject_id'] as int,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subject_id': subjectId,
      'name': name,
    };
  }
}
