import 'package:typesafe_postgrest/typesafe_postgrest.dart';

/// {@template typesafe_postgrest.PgJsonColumn}
///
/// Represents a column of type [Map<String, dynamic>] in a table.
///
/// It handles the conversion from and to JSON for you.
///
/// {@endtemplate}
class PgJsonColumn<TableType>
    extends PgColumn<TableType, PgJsonMap, PgJsonMap> {
  /// {@macro typesafe_postgrest.PgJsonColumn}
  PgJsonColumn(super.name)
    : super(fromJson: (jsonValue) => jsonValue, toJson: (value) => value);
}

/// {@template typesafe_postgrest.PgMaybeJsonColumn}
///
/// Represents a column that can be null of type [Map<String, dynamic>] in a
/// table.
///
/// It handles the conversion from and to JSON for you.
///
/// {@endtemplate}
class PgMaybeJsonColumn<TableType>
    extends PgColumn<TableType, PgJsonMap?, PgJsonMap?> {
  /// {@macro typesafe_postgrest.PgMaybeJsonColumn}
  PgMaybeJsonColumn(super.name)
    : super(fromJson: (jsonValue) => jsonValue, toJson: (value) => value);
}
