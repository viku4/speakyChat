import 'package:supabase_flutter/supabase_flutter.dart' hide Provider;

export 'database/database.dart';
export 'storage/storage.dart';

const _kSupabaseUrl = 'https://spxsjmwspafcsziyssyg.supabase.co';
const _kSupabaseAnonKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNweHNqbXdzcGFmY3N6aXlzc3lnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDcyMDUxMTcsImV4cCI6MjAyMjc4MTExN30.w0TvQElmATEdp799sm7qJzV5T9UCHn_n7-IlSMbkK0U';

class SupaFlow {
  SupaFlow._();

  static SupaFlow? _instance;
  static SupaFlow get instance => _instance ??= SupaFlow._();

  // final _supabase = Supabase.instance.client;
  // static SupabaseClient get client => instance._supabase;

  static Future initialize() => Supabase.initialize(
        url: _kSupabaseUrl,
        anonKey: _kSupabaseAnonKey,
        debug: false,
      );
}
