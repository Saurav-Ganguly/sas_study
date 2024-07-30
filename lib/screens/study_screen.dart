import 'package:flutter/material.dart';
import 'package:sas_study_v2/widgets/short_notes_tab.dart';
import 'package:sas_study_v2/widgets/quiz_tab.dart';

class StudyScreen extends StatelessWidget {
  final int chapterId;

  const StudyScreen({super.key, required this.chapterId});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const TabBar(
            tabs: [
              Tab(text: 'Short Notes'),
              Tab(text: 'Quiz'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                ShortNotesTab(chapterId: chapterId),
                QuizTab(chapterId: chapterId),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
