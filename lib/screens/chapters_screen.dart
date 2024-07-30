import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sas_study_v2/models/chapter.dart';
import 'package:sas_study_v2/services/supabase_service.dart';
import 'package:sas_study_v2/services/navigation_service.dart';
import 'package:sas_study_v2/screens/study_screen.dart';

class ChaptersScreen extends StatelessWidget {
  final int topicId;

  const ChaptersScreen({super.key, required this.topicId});

  @override
  Widget build(BuildContext context) {
    final supabaseService =
        Provider.of<SupabaseService>(context, listen: false);

    return FutureBuilder<List<Chapter>>(
      future: supabaseService.getChaptersForTopic(topicId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No chapters found for this topic'));
        }

        final chapters = snapshot.data!;
        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: chapters.length,
          itemBuilder: (context, index) {
            final chapter = chapters[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Card(
                elevation: 2.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: InkWell(
                  onTap: () {
                    Provider.of<NavigationService>(context, listen: false)
                        .navigateTo(StudyScreen(chapterId: chapter.id));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            chapter.name,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios, size: 16.0),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
