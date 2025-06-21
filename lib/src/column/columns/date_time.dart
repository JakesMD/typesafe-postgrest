import 'package:typesafe_postgrest/typesafe_postgrest.dart';

/// {@template typesafe_postgrest.PgDateTimeColumn}
///
/// Represents a column of type [DateTime] (timestamp **without** time zone) in
/// a table.
///
/// For a timestamp **with** time zone, use [PgUTCDateTimeColumn].
///
/// The difference between [PgDateTimeColumn] and [PgUTCDateTimeColumn] is that
/// [PgUTCDateTimeColumn] converts the [DateTime] to UTC before converting it to
/// JSON where as [PgDateTimeColumn] does not.
///
/// It handles the conversion from and to JSON for you.
///
/// {@endtemplate}
class PgDateTimeColumn<TableType>
    extends PgColumn<TableType, DateTime, String> {
  /// {@macro typesafe_postgrest.PgDateTimeColumn}
  PgDateTimeColumn(super.name)
    : super(
        fromJson: DateTime.parse,
        toJson: (value) => value.toIso8601String(),
      );
}

/// {@template typesafe_postgrest.PgMaybeDateTimeColumn}
///
/// Represents a column that can be null of type [DateTime] (timestamp
/// **without** time zone) in a table.
///
/// For a timestamp **with** time zone, use [PgMaybeUTCDateTimeColumn].
///
/// The difference between [PgMaybeDateTimeColumn] and
/// [PgMaybeUTCDateTimeColumn] is that [PgMaybeUTCDateTimeColumn] converts the
/// [DateTime] to UTC before converting it to JSON where as
/// [PgMaybeDateTimeColumn] does not.
///
/// It handles the conversion from and to JSON for you.
///
/// {@endtemplate}
class PgMaybeDateTimeColumn<TableType>
    extends PgColumn<TableType, DateTime?, String?> {
  /// {@macro typesafe_postgrest.PgDateTimeColumn}
  PgMaybeDateTimeColumn(super.name)
    : super(
        fromJson: (value) => value != null ? DateTime.parse(value) : null,
        toJson: (value) => value?.toIso8601String(),
      );
}
