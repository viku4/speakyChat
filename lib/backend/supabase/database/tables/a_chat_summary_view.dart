// import '../database.dart';
//
// class AChatSummaryViewTable extends SupabaseTable<AChatSummaryViewRow> {
//   @override
//   String get tableName => 'a_chat_summary_view';
//
//   @override
//   AChatSummaryViewRow createRow(Map<String, dynamic> data) =>
//       AChatSummaryViewRow(data);
// }
//
// class AChatSummaryViewRow extends SupabaseDataRow {
//   AChatSummaryViewRow(Map<String, dynamic> data) : super(data);
//
//   @override
//   SupabaseTable get table => AChatSummaryViewTable();
//
//   int? get chatId => getField<int>('chat_id');
//   set chatId(int? value) => setField<int>('chat_id', value);
//
//   List<String> get nicknames => getListField<String>('nicknames');
//   set nicknames(List<String>? value) =>
//       setListField<String>('nicknames', value);
//
//   List<String> get userIds => getListField<String>('user_ids');
//   set userIds(List<String>? value) => setListField<String>('user_ids', value);
//
//   String? get lastMessage => getField<String>('last_message');
//   set lastMessage(String? value) => setField<String>('last_message', value);
//
//   DateTime? get lastMessageTime => getField<DateTime>('last_message_time');
//   set lastMessageTime(DateTime? value) =>
//       setField<DateTime>('last_message_time', value);
// }
