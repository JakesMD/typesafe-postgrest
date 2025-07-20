import 'package:typesafe_postgrest/typesafe_postgrest.dart';

/// {@template typesafe_postgrest.PgBoolColumn}
///
/// Represents a column of type [bool] in a table.
///
/// It handles the conversion from and to JSON for you.
///
/// {@endtemplate}
class PgBoolColumn<TableType> extends PgColumn<TableType, bool, bool> {
  /// {@macro typesafe_postgrest.PgBoolColumn}
  PgBoolColumn(super.name)
    : super(fromJson: (jsonValue) => jsonValue, toJson: (value) => value);
}

/// {@template typesafe_postgrest.PgMaybeBoolColumn}
///
/// Represents a column that can be null of type [bool] in a table.
///
/// It handles the conversion from and to JSON for you.
///
/// {@endtemplate}
class PgMaybeBoolColumn<TableType> extends PgColumn<TableType, bool?, bool?> {
  /// {@macro typesafe_postgrest.PgBoolColumn}
  PgMaybeBoolColumn(super.name)
    : super(fromJson: (jsonValue) => jsonValue, toJson: (value) => value);
}
