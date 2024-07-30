class Question {
  final int id;
  final int chapterId;
  final String question;

  Question({required this.id, required this.chapterId, required this.question});

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] as int,
      chapterId: json['chapter_id'] as int,
      question: json['question'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chapter_id': chapterId,
      'question': question,
    };
  }
}
