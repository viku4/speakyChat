// import '../database.dart';
//
// class AStatusesTable extends SupabaseTable<AStatusesRow> {
//   @override
//   String get tableName => 'a_statuses';
//
//   @override
//   AStatusesRow createRow(Map<String, dynamic> data) => AStatusesRow(data);
// }
//
// class AStatusesRow extends SupabaseDataRow {
//   AStatusesRow(Map<String, dynamic> data) : super(data);
//
//   @override
//   SupabaseTable get table => AStatusesTable();
//
//   int get id => getField<int>('id')!;
//   set id(int value) => setField<int>('id', value);
//
//   DateTime get createdAt => getField<DateTime>('created_at')!;
//   set createdAt(DateTime value) => setField<DateTime>('created_at', value);
//
//   int? get userId => getField<int>('user_id');
//   set userId(int? value) => setField<int>('user_id', value);
//
//   String? get contentUrl => getField<String>('content_url');
//   set contentUrl(String? value) => setField<String>('content_url', value);
//
//   String? get caption => getField<String>('caption');
//   set caption(String? value) => setField<String>('caption', value);
//
//   int? get visibilityDuration => getField<int>('visibility_duration');
//   set visibilityDuration(int? value) =>
//       setField<int>('visibility_duration', value);
//
//   DateTime? get uploadTime => getField<DateTime>('upload_time');
//   set uploadTime(DateTime? value) => setField<DateTime>('upload_time', value);
// }
