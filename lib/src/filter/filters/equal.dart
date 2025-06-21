import 'package:meta/meta.dart';
import 'package:postgrest/postgrest.dart';
import 'package:typesafe_postgrest/typesafe_postgrest.dart';

/// {@template typesafe_postgrest.PgEqualFilter}
///
/// Column is equal to a value.
///
/// A filter that only matches rows where the column is equal to [value].
///
/// This is equivalent to `isFilter` for bools and nulls and `eq` for other
/// types.
///
/// `value`: The value to filter with.
///
/// {@endtemplate}
class PgEqualFilter<TableType, T> extends PgFilter<TableType> {
  /// {@macro typesafe_postgrest.PgEqualFilter}
  @internal
  const PgEqualFilter(this.column, this.value, super.previousFilter);

  /// The column to filter by.
  final PgFilterColumn<TableType, T, dynamic> column;

  /// The value to filter with.
  final T value;

  @override
  @internal
  PostgrestFilterBuilder<P> build<P>(PostgrestFilterBuilder<P> builder) {
    if (value == null || T is bool || T is bool?) {
      return builder.isFilter(
        column.filterPattern,
        column.toJson(value) as bool?,
      );
    }
    return builder.eq(column.filterPattern, column.toJson(value) as Object);
  }

  @override
  PgFilter<TableType> withPreviousFilter(PgFilter<TableType> previousFilter) =>
      PgEqualFilter(column, value, previousFilter);
}
