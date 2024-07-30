import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:sas_study_v2/services/supabase_service.dart';
import 'package:sas_study_v2/models/short_note.dart';

class ShortNotesTab extends StatelessWidget {
  final int chapterId;

  const ShortNotesTab({super.key, required this.chapterId});

  @override
  Widget build(BuildContext context) {
    final supabaseService =
        Provider.of<SupabaseService>(context, listen: false);

    return FutureBuilder<ShortNote?>(
      future: supabaseService.getShortNoteForChapter(chapterId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data == null) {
          return const Center(
              child: Text('No short notes available for this chapter.'));
        }

        final shortNote = snapshot.data!;
        return Markdown(data: shortNote.notes);
      },
    );
  }
}
