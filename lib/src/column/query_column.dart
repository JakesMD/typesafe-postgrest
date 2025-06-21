import 'package:typesafe_postgrest/typesafe_postgrest.dart';

/// A helper class to only allow querying certain columns.
///
/// Basically, you should not be allowed to query with [PgJoin.column],
/// but be allowed to query with [PgJoin.call].
///
/// In the same way, you should not be allowed to filter with [PgJoin.call], but
/// be allowed to filter with [PgJoin.column].
///
/// Therefore we have two classes, [PgFilterColumn] and [PgQueryColumn], which
/// are used to provide type safety. [PgColumn] implements both which means that
/// you can use the same column for filtering and querying. But [PgJoin.column]
/// returns a [PgFilterColumn] and [PgJoin.call] returns a [PgQueryColumn].
abstract class PgQueryColumn<TableType, ValueType, JsonValueType> {
  /// The name of the column in the postgres table.
  String get name;

  /// The query pattern to use when querying for this column.
  ///
  /// The query pattern is generated automatically by the library.
  ///
  /// Generally, this is the same as the name of the column.
  ///
  /// For joins and JSON references, this will be a fancy query pattern
  /// depending on the join type and referenced columns. These fancy query
  /// patterns are generated in [PgJoin.call].
  String get queryPattern;

  /// {@macro typesafe_postgrest.PgColumn.fromJson}
  ValueType Function(JsonValueType jsonValue) get fromJson;

  /// {@macro typesafe_postgrest.PgColumn.toJson}
  JsonValueType Function(ValueType value) get toJson;

  /// Creates a [PgValue] from the provided JSON [value] using the [fromJson]
  /// function.
  PgValue<TableType, ValueType> pgValueFromJson(dynamic value);
}
