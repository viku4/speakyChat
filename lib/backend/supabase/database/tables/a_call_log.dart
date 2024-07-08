// import '../database.dart';
//
// class ACallLogTable extends SupabaseTable<ACallLogRow> {
//   @override
//   String get tableName => 'a_call_log';
//
//   @override
//   ACallLogRow createRow(Map<String, dynamic> data) => ACallLogRow(data);
// }
//
// class ACallLogRow extends SupabaseDataRow {
//   ACallLogRow(Map<String, dynamic> data) : super(data);
//
//   @override
//   SupabaseTable get table => ACallLogTable();
//
//   int get id => getField<int>('id')!;
//   set id(int value) => setField<int>('id', value);
//
//   DateTime get createdAt => getField<DateTime>('created_at')!;
//   set createdAt(DateTime value) => setField<DateTime>('created_at', value);
//
//   int? get callerId => getField<int>('caller_id');
//   set callerId(int? value) => setField<int>('caller_id', value);
//
//   int? get receiverId => getField<int>('receiver_id');
//   set receiverId(int? value) => setField<int>('receiver_id', value);
//
//   DateTime? get startTime => getField<DateTime>('start_time');
//   set startTime(DateTime? value) => setField<DateTime>('start_time', value);
//
//   DateTime? get endTime => getField<DateTime>('end_time');
//   set endTime(DateTime? value) => setField<DateTime>('end_time', value);
//
//   String? get type => getField<String>('type');
//   set type(String? value) => setField<String>('type', value);
//
//   String? get status => getField<String>('status');
//   set status(String? value) => setField<String>('status', value);
// }
