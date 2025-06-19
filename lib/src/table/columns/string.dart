import 'package:typesafe_postgrest/typesafe_postgrest.dart';

/// {@template typesafe_postgrest.PgStringColumn}
///
/// Represents a column of type [String] in a table.
///
/// It handles the conversion from and to JSON for you.
///
/// {@endtemplate}
class PgStringColumn<TableType> extends PgColumn<TableType, String, String> {
  /// {@macro typesafe_postgrest.PgStringColumn}
  PgStringColumn(super.name)
    : super(fromJson: (jsonValue) => jsonValue, toJson: (value) => value);
}

/// {@template typesafe_postgrest.PgMaybeStringColumn}
///
/// Represents a column that can be null of type [String] in a table.
///
/// It handles the conversion from and to JSON for you.
///
/// {@endtemplate}
class PgMaybeStringColumn<TableType>
    extends PgColumn<TableType, String?, String?> {
  /// {@macro typesafe_postgrest.PgMaybeStringColumn}
  PgMaybeStringColumn(super.name)
    : super(fromJson: (jsonValue) => jsonValue, toJson: (value) => value);
}
