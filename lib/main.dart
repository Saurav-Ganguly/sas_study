import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:sas_study_v2/app.dart';
import 'package:sas_study_v2/config/supabase_config.dart';
import 'package:sas_study_v2/services/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: ".env");

  await Supabase.initialize(
    url: SupabaseConfig.url,
    anonKey: SupabaseConfig.anonKey,
  );

  final supabaseClient = Supabase.instance.client;
  final supabaseService = SupabaseService(supabaseClient);

  runApp(
    Provider<SupabaseService>(
      create: (_) => supabaseService,
      child: const App(),
    ),
  );
}
