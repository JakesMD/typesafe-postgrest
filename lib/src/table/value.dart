import 'package:meta/meta.dart';

/// {@template typesafe_postgrest.PgValue}
///
/// Represents the value of a column in a table.
///
/// [TableType] is used to provide type safety. Objects that require a value
/// will only allow values of the provided [TableType].
///
/// {@endtemplate}
class PgValue<TableType, ValueType> {
  /// {@macro typesafe_postgrest.PgValue}
  @internal
  const PgValue(this.columnName, this.value);

  /// The name of the column this value is for.
  final String columnName;

  /// The value of the column.
  final ValueType value;
}
