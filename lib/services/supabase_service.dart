import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sas_study_v2/models/subject.dart';
import 'package:sas_study_v2/models/topic.dart';
import 'package:sas_study_v2/models/chapter.dart';
import 'package:sas_study_v2/models/short_note.dart';
import 'package:sas_study_v2/models/question.dart';
import 'package:sas_study_v2/models/answer_option.dart';

class SupabaseService {
  final SupabaseClient _supabaseClient;

  SupabaseService(this._supabaseClient);

  // Fetch all subjects
  Future<List<Subject>> getSubjects() async {
    final response = await _supabaseClient.from('subjects').select();

    return (response as List).map((json) => Subject.fromJson(json)).toList();
  }

  // Fetch topics for a specific subject
  Future<List<Topic>> getTopicsForSubject(int subjectId) async {
    final response = await _supabaseClient
        .from('topics')
        .select()
        .eq('subject_id', subjectId);

    return (response as List).map((json) => Topic.fromJson(json)).toList();
  }

  // Fetch chapters for a specific topic
  Future<List<Chapter>> getChaptersForTopic(int topicId) async {
    final response =
        await _supabaseClient.from('chapters').select().eq('topic_id', topicId);

    return (response as List).map((json) => Chapter.fromJson(json)).toList();
  }

  // Fetch short note for a specific chapter
  Future<ShortNote?> getShortNoteForChapter(int chapterId) async {
    final response = await _supabaseClient
        .from('short_notes')
        .select()
        .eq('chapter_id', chapterId)
        .single();

    // ignore: unnecessary_null_comparison
    return response != null ? ShortNote.fromJson(response) : null;
  }

  // Fetch questions for a specific chapter
  Future<List<Question>> getQuestionsForChapter(int chapterId) async {
    final response = await _supabaseClient
        .from('question_answers')
        .select()
        .eq('chapter_id', chapterId);

    return (response as List).map((json) => Question.fromJson(json)).toList();
  }

  // Fetch answer options for a specific question
  Future<List<AnswerOption>> getAnswerOptionsForQuestion(int questionId) async {
    final response = await _supabaseClient
        .from('answer_options')
        .select()
        .eq('question_id', questionId);

    return (response as List)
        .map((json) => AnswerOption.fromJson(json))
        .toList();
  }

  // Fetch a random question from any chapter
  Future<Map<String, dynamic>> getRandomQuestionWithDetails() async {
    final response = await _supabaseClient
        .rpc('get_random_question_with_details')
        .select()
        .single();

    final question = Question.fromJson(response['question']);
    final answerOptions = (response['answer_options'] as List)
        .map((json) => AnswerOption.fromJson(json))
        .toList();

    return {
      'question': question,
      'answerOptions': answerOptions,
      'subjectName': response['subject_name'],
      'topicName': response['topic_name'],
    };
  }
}
