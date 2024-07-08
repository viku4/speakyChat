// import '../database.dart';
//
// class AChatMessagesTable extends SupabaseTable<AChatMessagesRow> {
//   @override
//   String get tableName => 'a_chat_messages';
//
//   @override
//   AChatMessagesRow createRow(Map<String, dynamic> data) =>
//       AChatMessagesRow(data);
// }
//
// class AChatMessagesRow extends SupabaseDataRow {
//   AChatMessagesRow(Map<String, dynamic> data) : super(data);
//
//   @override
//   SupabaseTable get table => AChatMessagesTable();
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
//
//   String? get message => getField<String>('message');
//   set message(String? value) => setField<String>('message', value);
//
//   List<String> get media => getListField<String>('media');
//   set media(List<String>? value) => setListField<String>('media', value);
//
//   int? get mediaId => getField<int>('media_id');
//   set mediaId(int? value) => setField<int>('media_id', value);
// }
