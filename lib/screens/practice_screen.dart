import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sas_study_v2/services/supabase_service.dart';
import 'package:sas_study_v2/models/question.dart';
import 'package:sas_study_v2/models/answer_option.dart';

class PracticeScreen extends StatefulWidget {
  const PracticeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PracticeScreenState createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  late Future<Map<String, dynamic>> _questionFuture;
  bool _answerSelected = false;

  @override
  void initState() {
    super.initState();
    _loadNewQuestion();
  }

  void _loadNewQuestion() {
    final supabaseService =
        Provider.of<SupabaseService>(context, listen: false);
    setState(() {
      _questionFuture = supabaseService.getRandomQuestionWithDetails();
      _answerSelected = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>>(
        future: _questionFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No questions available.'));
          }

          final data = snapshot.data!;
          final question = data['question'] as Question;
          final answerOptions = data['answerOptions'] as List<AnswerOption>;
          final subjectName = data['subjectName'] as String;
          final topicName = data['topicName'] as String;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildInfoCard(subjectName, topicName),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  question.question,
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: answerOptions.length,
                  itemBuilder: (context, index) {
                    return _buildAnswerOption(answerOptions[index]);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: _answerSelected ? _loadNewQuestion : null,
                  child: const Text('Next Question'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildInfoCard(String subjectName, String topicName) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Subject: $subjectName',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Topic: $topicName'),
          ],
        ),
      ),
    );
  }

  Widget _buildAnswerOption(AnswerOption option) {
    Color? backgroundColor;
    if (_answerSelected) {
      backgroundColor =
          option.isCorrect ? Colors.green.shade100 : Colors.red.shade100;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: InkWell(
        onTap: _answerSelected ? null : () => _selectAnswer(option),
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

  void _selectAnswer(AnswerOption selectedOption) {
    setState(() {
      _answerSelected = true;
    });
  }
}
