import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sas_study_v2/services/supabase_service.dart';
import 'package:sas_study_v2/widgets/quiz_widget.dart';
import 'package:sas_study_v2/models/question.dart';

class QuizTab extends StatelessWidget {
  final int chapterId;

  const QuizTab({Key? key, required this.chapterId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final supabaseService =
        Provider.of<SupabaseService>(context, listen: false);

    return FutureBuilder<List<Question>>(
      future: supabaseService.getQuestionsForChapter(chapterId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
              child: Text('No questions available for this chapter.'));
        }

        final questions = snapshot.data!;
        return QuizWidget(questions: questions, chapterId: chapterId);
      },
    );
  }
}
