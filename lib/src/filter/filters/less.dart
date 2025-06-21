import 'package:meta/meta.dart';
import 'package:postgrest/postgrest.dart';
import 'package:typesafe_postgrest/typesafe_postgrest.dart';

/// {@template typesafe_postgrest.PgLessFilter}
///
/// Column is less than a value.
///
/// A filter that only matches rows where the column is less than [value].
///
/// `value`: The value to filter with.
///
/// {@endtemplate}
class PgLessFilter<TableType, T> extends PgFilter<TableType> {
  /// {@macro typesafe_postgrest.PgLessFilter}
  @internal
  const PgLessFilter(this.column, this.value, super.previousFilter);

  /// The column to filter by.
  final PgFilterColumn<TableType, T, dynamic> column;

  /// The value to filter with.
  final T value;

  @override
  PostgrestFilterBuilder<P> build<P>(PostgrestFilterBuilder<P> builder) =>
      builder.lt(column.filterPattern, column.toJson(value) as Object);

  @override
  PgFilter<TableType> withPreviousFilter(PgFilter<TableType> previousFilter) =>
      PgLessFilter(column, value, previousFilter);
}
