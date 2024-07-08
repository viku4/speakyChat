// import '../database.dart';
//
// class AChatMessagesInfoViewTable
//     extends SupabaseTable<AChatMessagesInfoViewRow> {
//   @override
//   String get tableName => 'a_chat_messages_info_view';
//
//   @override
//   AChatMessagesInfoViewRow createRow(Map<String, dynamic> data) =>
//       AChatMessagesInfoViewRow(data);
// }
//
// class AChatMessagesInfoViewRow extends SupabaseDataRow {
//   AChatMessagesInfoViewRow(Map<String, dynamic> data) : super(data);
//
//   @override
//   SupabaseTable get table => AChatMessagesInfoViewTable();
//
//   int? get chatId => getField<int>('chat_id');
//   set chatId(int? value) => setField<int>('chat_id', value);
//
//   DateTime? get createdAt => getField<DateTime>('created_at');
//   set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
//
//   String? get nickname => getField<String>('nickname');
//   set nickname(String? value) => setField<String>('nickname', value);
//
//   String? get userId => getField<String>('user_id');
//   set userId(String? value) => setField<String>('user_id', value);
//
//   String? get message => getField<String>('message');
//   set message(String? value) => setField<String>('message', value);
//
//   List<String> get media => getListField<String>('media');
//   set media(List<String>? value) => setListField<String>('media', value);
//
//   int? get messageId => getField<int>('message_id');
//   set messageId(int? value) => setField<int>('message_id', value);
//
//   int? get receiverId => getField<int>('receiver_id');
//   set receiverId(int? value) => setField<int>('receiver_id', value);
//
//   DateTime? get readAt => getField<DateTime>('read_at');
//   set readAt(DateTime? value) => setField<DateTime>('read_at', value);
//
//   DateTime? get receivedAt => getField<DateTime>('received_at');
//   set receivedAt(DateTime? value) => setField<DateTime>('received_at', value);
// }
