import 'package:meta/meta.dart';
import 'package:postgrest/postgrest.dart';
import 'package:typesafe_postgrest/typesafe_postgrest.dart';

/// {@template typesafe_postgrest.PgGreaterFilter}
///
/// Column is greater than a value.
///
/// A filter that only matches rows where the column is greater than [value].
///
/// `value`: The value to filter with.
///
/// {@endtemplate}
class PgGreaterFilter<TableType, T> extends PgFilter<TableType> {
  /// {@macro typesafe_postgrest.PgGreaterFilter}
  @internal
  const PgGreaterFilter(this.column, this.value, super.previousFilter);

  /// The column to filter by.
  final PgFilterColumn<TableType, T, dynamic> column;

  /// The value to filter with.
  final T value;

  @override
  PostgrestFilterBuilder<P> build<P>(PostgrestFilterBuilder<P> builder) =>
      builder.gt(column.filterPattern, column.toJson(value) as Object);

  @override
  PgFilter<TableType> withPreviousFilter(PgFilter<TableType> previousFilter) =>
      PgGreaterFilter(column, value, previousFilter);
}
