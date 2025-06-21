import 'package:meta/meta.dart';
import 'package:postgrest/postgrest.dart';
import 'package:typesafe_postgrest/typesafe_postgrest.dart';

/// {@template typesafe_postgrest.PgLessOrEqualFilter}
///
/// Column is less than or equal to a value
///
/// A filter that only matches rows where the column is less than or equal to
/// [value].
///
/// `value`: The value to filter with.
///
/// {@endtemplate}
class PgLessOrEqualFilter<TableType, T> extends PgFilter<TableType> {
  /// {@macro typesafe_postgrest.PgLessOrEqualFilter}
  @internal
  const PgLessOrEqualFilter(this.column, this.value, super.previousFilter);

  /// The column to filter by.
  final PgFilterColumn<TableType, T, dynamic> column;

  /// The value to filter with.
  final T value;

  @override
  PostgrestFilterBuilder<P> build<P>(PostgrestFilterBuilder<P> builder) =>
      builder.lte(column.filterPattern, column.toJson(value) as Object);

  @override
  PgFilter<TableType> withPreviousFilter(PgFilter<TableType> previousFilter) =>
      PgLessOrEqualFilter(column, value, previousFilter);
}
