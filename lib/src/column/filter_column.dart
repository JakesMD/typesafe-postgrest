import 'package:typesafe_postgrest/typesafe_postgrest.dart';

/// A helper class to only allow filtering with certain columns.
///
/// Baciscally, you should not be allowed to filter with [PgJoin.call], but be
/// allowed to filter with [PgJoin.column].
///
/// In the same way, you should not be allowed to query with [PgJoin.column],
/// but be allowed to query with [PgJoin.call].
///
/// Therefore we have two classes, [PgFilterColumn] and [PgQueryColumn], which
/// are used to provide type safety. [PgColumn] implements both which means that
/// you can use the same column for filtering and querying. But [PgJoin.column]
/// returns a [PgFilterColumn] and [PgJoin.call] returns a [PgQueryColumn].
abstract class PgFilterColumn<TableType, ValueType, JsonValueType> {
  /// The filter pattern to use when filtering with this column.
  ///
  /// The filter pattern is generated automatically by the library.
  ///
  /// Generally, this is the same as the name of the column.
  ///
  /// For joins and JSON references, this will be a fancy filter pattern
  /// depending on the join type and referenced columns. These fancy filter
  /// patterns are generated in [PgJoin.column].
  String get filterPattern;

  /// {@macro typesafe_postgrest.PgColumn.toJson}
  JsonValueType Function(ValueType value) get toJson;
}
