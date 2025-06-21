import 'package:meta/meta.dart';
import 'package:postgrest/postgrest.dart';
import 'package:typesafe_postgrest/typesafe_postgrest.dart';

/// {@template typesafe_postgrest.PgFilterFilter}
///
/// Match the filter.
///
/// Match only rows which satisfy the filter. This is an escape hatch - you
/// should use the specific filter methods wherever possible.
///
/// `columnName`: The name column to filter on.
///
/// `operator`: The operator to filter with, following PostgREST syntax.
///
/// `value`: The value to filter with, following PostgREST syntax.
///
/// {@endtemplate}
class PgFilterFilter<TableType> extends PgFilter<TableType> {
  /// {@macro typesafe_postgrest.PgFilterFilter}
  @internal
  const PgFilterFilter(
    this.columnName,
    this.operator,
    this.value,
    super.previousFilter,
  );

  /// The name of column to filter on / The filter pattern.
  ///
  /// This is not a [PgFilterColumn] to allow for more flexibility.
  final String columnName;

  /// The operator to filter with, following PostgREST syntax.
  final String operator;

  /// The value to filter with, following PostgREST syntax.
  ///
  /// This is not linked to a [PgFilterColumn] to allow for more flexibility.
  final Object? value;

  @override
  PostgrestFilterBuilder<P> build<P>(PostgrestFilterBuilder<P> builder) =>
      builder.filter(columnName, operator, value);

  @override
  PgFilter<TableType> withPreviousFilter(PgFilter<TableType> previousFilter) =>
      PgFilterFilter(columnName, operator, value, previousFilter);
}

/// {@macro typesafe_postgrest.PgFilterFilter}
PgFilter<TableType> pgFilter<TableType>(
  String columnName,
  String operator,
  Object? value,
) => PgFilterFilter(columnName, operator, value, null);
