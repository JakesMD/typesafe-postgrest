import 'package:meta/meta.dart';
import 'package:postgrest/postgrest.dart';
import 'package:typesafe_postgrest/typesafe_postgrest.dart';

/// {@template typesafe_postgrest.PgOrFilter}
///
/// Match at least one filter.
///
/// A filter that only matches rows satisfying at least one of the filters.
///
/// `filters`: The filters to use, following PostgREST syntax.
///
/// `referencedTableName`: Set this to filter on referenced tables instead of
/// the parent table.
///
/// {@endtemplate}
class PgOrFilter<TableType> extends PgFilter<TableType> {
  /// {@macro typesafe_postgrest.PgOrFilter}
  @internal
  const PgOrFilter(
    this.filters,
    this.referencedTableName,
    super.previousFilter,
  );

  /// The filters to use, following PostgREST syntax.
  final String filters;

  /// Set this to filter on referenced tables instead of the parent table.
  final PgTableName<dynamic>? referencedTableName;

  @override
  PostgrestFilterBuilder<P> build<P>(PostgrestFilterBuilder<P> builder) =>
      builder.or(filters, referencedTable: referencedTableName?.name);

  @override
  PgFilter<TableType> withPreviousFilter(PgFilter<TableType> previousFilter) =>
      PgOrFilter(filters, referencedTableName, previousFilter);
}

/// {@macro typesafe_postgrest.pgOr}
PgFilter<TableType> pgOr<TableType>(
  String filters, {
  PgTableName<dynamic>? referencedTableName,
}) => PgOrFilter(filters, referencedTableName, null);
