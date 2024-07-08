// import '../database.dart';
//
// class AContactsTable extends SupabaseTable<AContactsRow> {
//   @override
//   String get tableName => 'a_contacts';
//
//   @override
//   AContactsRow createRow(Map<String, dynamic> data) => AContactsRow(data);
// }
//
// class AContactsRow extends SupabaseDataRow {
//   AContactsRow(Map<String, dynamic> data) : super(data);
//
//   @override
//   SupabaseTable get table => AContactsTable();
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
//   int? get contactUserId => getField<int>('contact_user_id');
//   set contactUserId(int? value) => setField<int>('contact_user_id', value);
//
//   bool? get isBlocked => getField<bool>('is_blocked');
//   set isBlocked(bool? value) => setField<bool>('is_blocked', value);
// }
