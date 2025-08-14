// typedefs are self-documenting
// ignore_for_file: public_member_api_docs

import 'package:postgrest/postgrest.dart';
import 'package:typesafe_postgrest/typesafe_postgrest.dart';

typedef PgJsonList = PostgrestList;
typedef PgJsonMap = PostgrestMap;
typedef PgQueryColumnList<TableType> =
    List<PgQueryColumn<TableType, dynamic, dynamic>>;
typedef PgValuesList<TableType> = List<PgValue<TableType, dynamic, dynamic>>;

/// {@template typesafe_postgrest.PgMissingDataException}
///
/// An exception thrown when a value that is missing in the JSON data is
/// requested from a model.
///
/// {@endtemplate}
class PgMissingDataException implements Exception {
  /// {@macro typesafe_postgrest.PgMissingDataException}
  PgMissingDataException(this.columnName);

  final String columnName;

  @override
  String toString() =>
      '''PgMissingDataException: The key '$columnName' was not found in the JSON data.''';
}
