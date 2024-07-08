// import '../database.dart';
//
// class AChatUsersTable extends SupabaseTable<AChatUsersRow> {
//   @override
//   String get tableName => 'a_chat_users';
//
//   @override
//   AChatUsersRow createRow(Map<String, dynamic> data) => AChatUsersRow(data);
// }
//
// class AChatUsersRow extends SupabaseDataRow {
//   AChatUsersRow(Map<String, dynamic> data) : super(data);
//
//   @override
//   SupabaseTable get table => AChatUsersTable();
//
//   int get id => getField<int>('id')!;
//   set id(int value) => setField<int>('id', value);
//
//   DateTime get createdAt => getField<DateTime>('created_at')!;
//   set createdAt(DateTime value) => setField<DateTime>('created_at', value);
//
//   int? get chatId => getField<int>('chat_id');
//   set chatId(int? value) => setField<int>('chat_id', value);
//
//   int? get userId => getField<int>('user_id');
//   set userId(int? value) => setField<int>('user_id', value);
// }
