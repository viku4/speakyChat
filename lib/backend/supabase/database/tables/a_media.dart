// import '../database.dart';
//
// class AMediaTable extends SupabaseTable<AMediaRow> {
//   @override
//   String get tableName => 'a_media';
//
//   @override
//   AMediaRow createRow(Map<String, dynamic> data) => AMediaRow(data);
// }
//
// class AMediaRow extends SupabaseDataRow {
//   AMediaRow(Map<String, dynamic> data) : super(data);
//
//   @override
//   SupabaseTable get table => AMediaTable();
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
//   int? get messageId => getField<int>('message_id');
//   set messageId(int? value) => setField<int>('message_id', value);
//
//   String? get url => getField<String>('url');
//   set url(String? value) => setField<String>('url', value);
//
//   String? get type => getField<String>('type');
//   set type(String? value) => setField<String>('type', value);
//
//   String? get thumbnailUrl => getField<String>('thumbnail_url');
//   set thumbnailUrl(String? value) => setField<String>('thumbnail_url', value);
//
//   DateTime? get uploadTime => getField<DateTime>('upload_time');
//   set uploadTime(DateTime? value) => setField<DateTime>('upload_time', value);
// }
