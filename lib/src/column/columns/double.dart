import 'package:typesafe_postgrest/typesafe_postgrest.dart';

/// {@template typesafe_postgrest.PgDoubleColumn}
///
/// Represents a column of type [double] in a table.
///
/// It handles the conversion from and to JSON for you.
///
/// {@endtemplate}
class PgDoubleColumn<TableType> extends PgColumn<TableType, double, double> {
  /// {@macro typesafe_postgrest.PgDoubleColumn}
  PgDoubleColumn(super.name)
    : super(fromJson: (jsonValue) => jsonValue, toJson: (value) => value);
}

/// {@template typesafe_postgrest.PgMaybeDoubleColumn}
///
/// Represents a column that can be null of type [double] in a table.
///
/// It handles the conversion from and to JSON for you.
///
/// {@endtemplate}
class PgMaybeDoubleColumn<TableType>
    extends PgColumn<TableType, double?, double?> {
  /// {@macro typesafe_postgrest.PgDoubleColumn}
  PgMaybeDoubleColumn(super.name)
    : super(fromJson: (jsonValue) => jsonValue, toJson: (value) => value);
}
