class AnswerOption {
  final int id;
  final int questionId;
  final String answerText;
  final bool isCorrect;

  AnswerOption({
    required this.id,
    required this.questionId,
    required this.answerText,
    required this.isCorrect,
  });

  factory AnswerOption.fromJson(Map<String, dynamic> json) {
    return AnswerOption(
      id: json['id'] as int,
      questionId: json['question_id'] as int,
      answerText: json['answer_text'] as String,
      isCorrect: json['is_correct'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question_id': questionId,
      'answer_text': answerText,
      'is_correct': isCorrect,
    };
  }
}
