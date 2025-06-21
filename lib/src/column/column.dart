import 'package:meta/meta.dart';
import 'package:typesafe_postgrest/typesafe_postgrest.dart';

export 'columns/_columns.dart';
export 'filter_column.dart';
export 'query_column.dart';
export 'value.dart';

/// {@template typesafe_postgrest.PgColumn}
///
/// Represents a column in a table.
///
/// In most cases you should not need to use this class directly. This library
/// provides a set of standard columns that you can use.
///
/// However, should your column type be something custom, e.g. an enum, you can
/// use this class to define your own column.
///
/// [TableType] is used to provide type safety. Objects that require a column
/// will only allow columns of the provided [TableType]. Also, the column will
/// only generate values of the provided [TableType].
///
/// {@endtemplate}
class PgColumn<TableType, ValueType, JsonValueType>
    implements
        PgQueryColumn<TableType, ValueType, JsonValueType>,
        PgFilterColumn<TableType, ValueType, JsonValueType> {
  /// {@macro typesafe_postgrest.PgColumn}
  const PgColumn(this.name, {required this.fromJson, required this.toJson})
    : queryPattern = name,
      filterPattern = name;

  /// {@macro typesafe_postgrest.PgColumn}
  ///
  /// Constructs a [PgColumn] with a custom query pattern.
  @internal
  const PgColumn.withPatterns(
    this.name, {
    required this.queryPattern,
    required this.filterPattern,
    required this.fromJson,
    required this.toJson,
  });

  @override
  final String name;

  @override
  final String queryPattern;

  @override
  final String filterPattern;

  /// {@template typesafe_postgrest.PgColumn.fromJson}
  ///
  /// The function used to convert a JSON value to a [ValueType].
  ///
  /// {@endtemplate}
  @override
  final ValueType Function(JsonValueType jsonValue) fromJson;

  /// {@template typesafe_postgrest.PgColumn.toJson}
  ///
  /// The function used to convert a [ValueType] to a JSON value.
  ///
  /// This is used when inserting, upserting and updating a value. Should you
  /// not need this behavior, just provide a dummy function instead.
  ///
  /// {@endtemplate}
  @override
  final JsonValueType Function(ValueType value) toJson;

  /// Creates a [PgValue] from the provided [value] of the type [ValueType].
  ///
  /// This is used when inserting, upserting and updating a value.
  PgValue<TableType, ValueType> call(ValueType value) => PgValue(name, value);

  @internal
  @override
  PgValue<TableType, ValueType> pgValueFromJson(dynamic value) => PgValue(
    name,
    // Note: The value can be null when filtering in referenced tables.
    JsonValueType == PgJsonList
        ? fromJson(
            PgJsonList.from(value != null ? value as List : [])
                as JsonValueType,
          )
        : JsonValueType == PgJsonMap
        ? fromJson(
            PgJsonMap.from(value != null ? value as Map : {}) as JsonValueType,
          )
        : fromJson(value as JsonValueType),
  );
}
