import 'package:typesafe_postgrest/typesafe_postgrest.dart';

/// {@template typesafe_postgrest.PgIntColumn}
///
/// Represents a column of type [int] in a table.
///
/// It handles the conversion from and to JSON for you.
///
/// {@endtemplate}
class PgIntColumn<TableType> extends PgColumn<TableType, int, int> {
  /// {@macro typesafe_postgrest.PgIntColumn}
  PgIntColumn(super.name)
    : super(fromJson: (jsonValue) => jsonValue, toJson: (value) => value);
}

/// {@template typesafe_postgrest.PgMaybeIntColumn}
///
/// Represents a column that can be null of type [int] in a table.
///
/// It handles the conversion from and to JSON for you.
///
/// {@endtemplate}
class PgMaybeIntColumn<TableType> extends PgColumn<TableType, int?, int?> {
  /// {@macro typesafe_postgrest.PgIntColumn}
  PgMaybeIntColumn(super.name)
    : super(fromJson: (jsonValue) => jsonValue, toJson: (value) => value);
}
