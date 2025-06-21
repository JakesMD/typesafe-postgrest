import 'package:meta/meta.dart';
import 'package:postgrest/postgrest.dart';
import 'package:typesafe_postgrest/typesafe_postgrest.dart';

/// {@template typesafe_postgrest.PgNotFilter}
///
/// Don't match the filter.
///
/// A filter that only matches rows that don't satisfy the filter.
///
/// `columnName`: The name of the column to filter on.
///
/// `operator`: The operator to be negated to filter with, following PostgREST
/// syntax.
///
/// `value`: The value to filter with, following PostgREST syntax.
///
/// {@endtemplate}
class PgNotFilter<TableType> extends PgFilter<TableType> {
  /// {@macro typesafe_postgrest.PgNotFilter}
  @internal
  const PgNotFilter(
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
      builder.not(columnName, operator, value);

  @override
  PgFilter<TableType> withPreviousFilter(PgFilter<TableType> previousFilter) =>
      PgNotFilter(columnName, operator, value, previousFilter);
}

/// {@macro typesafe_postgrest.PgNotFilter}
PgFilter<TableType> pgNot<TableType>(
  String columnName,
  String operator,
  Object? value,
) => PgNotFilter(columnName, operator, value, null);
