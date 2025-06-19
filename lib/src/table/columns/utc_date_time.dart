import 'package:typesafe_postgrest/typesafe_postgrest.dart';

/// {@template typesafe_postgrest.PgUTCDateTimeColumn}
///
/// Represents a column of type [DateTime] (timestamp **with** time zone) in a
/// table.
///
/// For a timestamp **without** time zone, use [PgDateTimeColumn].
///
/// The difference between [PgDateTimeColumn] and [PgUTCDateTimeColumn] is that
/// [PgUTCDateTimeColumn] converts the [DateTime] to UTC before converting it to
/// JSON where as [PgDateTimeColumn] does not.
///
/// It handles the conversion from and to JSON for you.
///
/// {@endtemplate}
class PgUTCDateTimeColumn<TableType>
    extends PgColumn<TableType, DateTime, String> {
  /// {@macro typesafe_postgrest.PgUTCDateTimeColumn}
  PgUTCDateTimeColumn(super.name)
    : super(
        fromJson: DateTime.parse,
        toJson: (value) => value.toIso8601String(),
      );
}

/// {@template typesafe_postgrest.PgMaybeUTCDateTimeColumn}
///
/// Represents a column that can be null of type [DateTime] (timestamp **with**
/// time zone) in a table.
///
/// For a timestamp **without** time zone, use [PgMaybeDateTimeColumn].
///
/// The difference between [PgMaybeDateTimeColumn] and
/// [PgMaybeUTCDateTimeColumn] is that [PgMaybeUTCDateTimeColumn] converts the
/// [DateTime] to UTC before converting it to JSON where as
/// [PgMaybeDateTimeColumn] does not.
///
/// It handles the conversion from and to JSON for you.
///
/// {@endtemplate}
class PgMaybeUTCDateTimeColumn<TableType>
    extends PgColumn<TableType, DateTime?, String?> {
  /// {@macro typesafe_postgrest.PgUTCDateTimeColumn}
  PgMaybeUTCDateTimeColumn(super.name)
    : super(
        fromJson: (value) => value != null ? DateTime.parse(value) : null,
        toJson: (value) => value?.toUtc().toIso8601String(),
      );
}
