import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sas_study_v2/models/question.dart';
import 'package:sas_study_v2/models/answer_option.dart';
import 'package:sas_study_v2/services/supabase_service.dart';

class QuizWidget extends StatefulWidget {
  final List<Question> questions;
  final int chapterId;

  const QuizWidget(
      {super.key, required this.questions, required this.chapterId});

  @override
  // ignore: library_private_types_in_public_api
  _QuizWidgetState createState() => _QuizWidgetState();
}

class _QuizWidgetState extends State<QuizWidget> {
  int currentQuestionIndex = 0;
  List<AnswerOption>? currentAnswerOptions;
  bool questionAnswered = false;

  @override
  void initState() {
    super.initState();
    _loadAnswerOptions();
  }

  Future<void> _loadAnswerOptions() async {
    final supabaseService =
        Provider.of<SupabaseService>(context, listen: false);
    final options = await supabaseService
        .getAnswerOptionsForQuestion(widget.questions[currentQuestionIndex].id);
    setState(() {
      currentAnswerOptions = options;
    });
  }

  void _handleAnswer(AnswerOption selectedAnswer) {
    setState(() {
      questionAnswered = true;
    });
  }

  void _nextQuestion() {
    if (currentQuestionIndex < widget.questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        questionAnswered = false;
        currentAnswerOptions = null;
      });
      _loadAnswerOptions();
    } else {
      _showQuizCompletionDialog();
    }
  }

  void _showQuizCompletionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Quiz Completed'),
          content: const Text('You have completed the quiz!'),
          actions: <Widget>[
            TextButton(
              child: const Text('Retry Quiz'),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  currentQuestionIndex = 0;
                  questionAnswered = false;
                  currentAnswerOptions = null;
                });
                _loadAnswerOptions();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (currentAnswerOptions == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            widget.questions[currentQuestionIndex].question,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        ...currentAnswerOptions!.map((option) => AnswerOptionWidget(
              option: option,
              onTap: _handleAnswer,
              showFeedback: questionAnswered,
            )),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: questionAnswered ? _nextQuestion : null,
          child: const Text('Next Question'),
        ),
      ],
    );
  }
}

class AnswerOptionWidget extends StatelessWidget {
  final AnswerOption option;
  final Function(AnswerOption) onTap;
  final bool showFeedback;

  const AnswerOptionWidget({
    super.key,
    required this.option,
    required this.onTap,
    required this.showFeedback,
  });

  @override
  Widget build(BuildContext context) {
    Color? backgroundColor;
    if (showFeedback) {
      backgroundColor =
          option.isCorrect ? Colors.green.shade100 : Colors.red.shade100;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: InkWell(
        onTap: showFeedback ? null : () => onTap(option),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: backgroundColor,
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Text(option.answerText),
        ),
      ),
    );
  }
}
