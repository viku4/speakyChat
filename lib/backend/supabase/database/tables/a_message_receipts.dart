// import '../database.dart';
//
// class AMessageReceiptsTable extends SupabaseTable<AMessageReceiptsRow> {
//   @override
//   String get tableName => 'a_message_receipts';
//
//   @override
//   AMessageReceiptsRow createRow(Map<String, dynamic> data) =>
//       AMessageReceiptsRow(data);
// }
//
// class AMessageReceiptsRow extends SupabaseDataRow {
//   AMessageReceiptsRow(Map<String, dynamic> data) : super(data);
//
//   @override
//   SupabaseTable get table => AMessageReceiptsTable();
//
//   int get id => getField<int>('id')!;
//   set id(int value) => setField<int>('id', value);
//
//   DateTime get createdAt => getField<DateTime>('created_at')!;
//   set createdAt(DateTime value) => setField<DateTime>('created_at', value);
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
