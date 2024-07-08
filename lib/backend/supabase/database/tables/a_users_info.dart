// import '../database.dart';
//
// class AUsersInfoTable extends SupabaseTable<AUsersInfoRow> {
//   @override
//   String get tableName => 'a_users_info';
//
//   @override
//   AUsersInfoRow createRow(Map<String, dynamic> data) => AUsersInfoRow(data);
// }
//
// class AUsersInfoRow extends SupabaseDataRow {
//   AUsersInfoRow(Map<String, dynamic> data) : super(data);
//
//   @override
//   SupabaseTable get table => AUsersInfoTable();
//
//   int get id => getField<int>('id')!;
//   set id(int value) => setField<int>('id', value);
//
//   DateTime get createdAt => getField<DateTime>('created_at')!;
//   set createdAt(DateTime value) => setField<DateTime>('created_at', value);
//
//   String? get userId => getField<String>('user_id');
//   set userId(String? value) => setField<String>('user_id', value);
//
//   String? get nickname => getField<String>('nickname');
//   set nickname(String? value) => setField<String>('nickname', value);
//
//   String? get profilePicUrl => getField<String>('profile_pic_url ');
//   set profilePicUrl(String? value) =>
//       setField<String>('profile_pic_url ', value);
//
//   String? get statusText => getField<String>('status_text ');
//   set statusText(String? value) => setField<String>('status_text ', value);
//
//   DateTime? get lastSeen => getField<DateTime>('last_seen ');
//   set lastSeen(DateTime? value) => setField<DateTime>('last_seen ', value);
//
//   dynamic? get privacySettings => getField<dynamic>('privacy_settings ');
//   set privacySettings(dynamic? value) =>
//       setField<dynamic>('privacy_settings ', value);
// }
