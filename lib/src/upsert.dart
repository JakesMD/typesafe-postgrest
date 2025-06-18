import 'package:typesafe_postgrest/typesafe_postgrest.dart';

class PgUpsert<TableType> {
  PgUpsert(this.values);

  final List<PgValue<dynamic>> values;
}
