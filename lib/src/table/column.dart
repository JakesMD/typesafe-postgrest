import 'package:meta/meta.dart';
import 'package:typesafe_postgrest/typesafe_postgrest.dart';

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
class PgColumn<TableType, ValueType, JsonValueType> {
  /// {@macro typesafe_postgrest.PgColumn}
  const PgColumn(this.name, {required this.fromJson, required this.toJson})
    : queryPattern = name;

  /// {@macro typesafe_postgrest.PgColumn}
  ///
  /// Constructs a [PgColumn] with a custom query pattern.
  @internal
  const PgColumn.withQueryPattern(
    this.name, {
    required this.queryPattern,
    required this.fromJson,
    required this.toJson,
  });

  /// The name of the column in the postgres table.
  final String name;

  /// The query pattern to use when querying for this column.
  ///
  /// The query pattern is generated automatically by the library.
  ///
  /// Generally, this is the same as the name of the column.
  ///
  /// For joins and JSON references, this will be a fancy query pattern
  /// depending on the join type and referenced columns. These fancy query
  /// patterns are generated in [PgJoinToOne.call], [PgMaybeJoinToOne.call] and
  /// [PgJoinToMany.call].
  final String queryPattern;

  /// The function used to convert a JSON value to a [ValueType].
  final ValueType Function(JsonValueType jsonValue) fromJson;

  /// The function used to convert a [ValueType] to a JSON value.
  ///
  /// This is used when inserting, upserting and updating a value. Should you
  /// not need this behavior, just provide a dummy function instead.
  final JsonValueType Function(ValueType value) toJson;

  /// Creates a [PgValue] from the provided [value] of the type [ValueType].
  ///
  /// This is used when inserting, upserting and updating a value.
  PgValue<TableType, ValueType> call(ValueType value) => PgValue(name, value);

  /// Creates a [PgValue] from the provided JSON [value] using the [fromJson]
  /// function.
  @internal
  PgValue<TableType, ValueType> pgValueFromJson(dynamic value) => PgValue(
    name,
    JsonValueType == PgJsonList
        ? fromJson(PgJsonList.from(value as List) as JsonValueType)
        : fromJson(value as JsonValueType),
  );
}
