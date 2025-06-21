import 'package:meta/meta.dart';
import 'package:postgrest/postgrest.dart';
import 'package:typesafe_postgrest/typesafe_postgrest.dart';

/// {@template typesafe_postgrest.PgNotEqualFilter}
///
/// Column is not equal to a value.
///
/// A filter that only matches rows where the column is not equal to [value].
///
/// `value`: The value to filter with.
///
/// {@endtemplate}
class PgNotEqualFilter<TableType, T> extends PgFilter<TableType> {
  /// {@macro typesafe_postgrest.PgNotEqualFilter}
  @internal
  const PgNotEqualFilter(this.column, this.value, super.previousFilter);

  /// The column to filter by.
  final PgFilterColumn<TableType, T, dynamic> column;

  /// The value to filter with.
  final T value;

  @override
  @internal
  PostgrestFilterBuilder<P> build<P>(PostgrestFilterBuilder<P> builder) =>
      builder.neq(column.filterPattern, column.toJson(value) as Object);

  @override
  PgFilter<TableType> withPreviousFilter(PgFilter<TableType> previousFilter) =>
      PgNotEqualFilter(column, value, previousFilter);
}
