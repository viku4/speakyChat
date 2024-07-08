// import '../database.dart';
//
// class AChatsTable extends SupabaseTable<AChatsRow> {
//   @override
//   String get tableName => 'a_chats';
//
//   @override
//   AChatsRow createRow(Map<String, dynamic> data) => AChatsRow(data);
// }
//
// class AChatsRow extends SupabaseDataRow {
//   AChatsRow(Map<String, dynamic> data) : super(data);
//
//   @override
//   SupabaseTable get table => AChatsTable();
//
//   int get id => getField<int>('id')!;
//   set id(int value) => setField<int>('id', value);
//
//   DateTime get createdAt => getField<DateTime>('created_at')!;
//   set createdAt(DateTime value) => setField<DateTime>('created_at', value);
//
//   String? get lastMessage => getField<String>('last_message');
//   set lastMessage(String? value) => setField<String>('last_message', value);
//
//   DateTime? get lastMessageTime => getField<DateTime>('last_message_time');
//   set lastMessageTime(DateTime? value) =>
//       setField<DateTime>('last_message_time', value);
// }
