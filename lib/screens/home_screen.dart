import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sas_study_v2/models/subject.dart';
import 'package:sas_study_v2/models/topic.dart';
import 'package:sas_study_v2/services/navigation_service.dart';
import 'package:sas_study_v2/services/supabase_service.dart';
import 'package:sas_study_v2/screens/chapters_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Subject>> _subjectsFuture;
  final Map<int, List<Topic>> _topicsMap = {};

  @override
  void initState() {
    super.initState();
    _subjectsFuture =
        Provider.of<SupabaseService>(context, listen: false).getSubjects();
  }

  Future<void> _loadTopicsForSubject(int subjectId) async {
    if (_topicsMap.containsKey(subjectId)) return;

    final supabaseService =
        Provider.of<SupabaseService>(context, listen: false);
    final topics = await supabaseService.getTopicsForSubject(subjectId);
    setState(() {
      _topicsMap[subjectId] = topics;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Subject>>(
      future: _subjectsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No subjects found'));
        }

        final subjects = snapshot.data!;

        return ListView.builder(
          itemCount: subjects.length,
          itemBuilder: (context, index) {
            final subject = subjects[index];
            return ExpansionTile(
              title: Text(subject.name),
              onExpansionChanged: (expanded) {
                if (expanded) {
                  _loadTopicsForSubject(subject.id);
                }
              },
              children: [
                if (_topicsMap.containsKey(subject.id))
                  ..._topicsMap[subject.id]!.map((topic) => ListTile(
                        title: Text(topic.name),
                        onTap: () {
                          Provider.of<NavigationService>(context, listen: false)
                              .navigateTo(ChaptersScreen(topicId: topic.id));
                        },
                      ))
                else
                  const Center(child: CircularProgressIndicator()),
              ],
            );
          },
        );
      },
    );
  }
}
