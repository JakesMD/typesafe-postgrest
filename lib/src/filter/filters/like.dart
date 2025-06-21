import 'package:meta/meta.dart';
import 'package:postgrest/postgrest.dart';
import 'package:typesafe_postgrest/typesafe_postgrest.dart';

/// {@template typesafe_postgrest.PgLikeFilter}
///
/// Column matches a pattern.
///
/// A filter that only matches rows where the [column] matches the [pattern].
///
/// `pattern`: The pattern to match with.
///
/// `isCaseSensitive`: Whether the pattern matching should be case-sensitive.
///
/// {@endtemplate}
class PgLikeFilter<TableType> extends PgFilter<TableType> {
  /// {@macro typesafe_postgrest.PgLikeFilter}
  @internal
  const PgLikeFilter(
    this.column,
    this.pattern,
    this.isCaseSensitive,
    super.previousFilter,
  );

  /// The column to filter by.
  final PgFilterColumn<TableType, dynamic, String?> column;

  /// The pattern to match with.
  final String pattern;

  /// Whether the pattern matching should be case-sensitive.
  final bool isCaseSensitive;

  @override
  @internal
  PostgrestFilterBuilder<P> build<P>(PostgrestFilterBuilder<P> builder) =>
      isCaseSensitive
      ? builder.like(column.filterPattern, pattern)
      : builder.ilike(column.filterPattern, pattern);

  @override
  PgFilter<TableType> withPreviousFilter(PgFilter<TableType> previousFilter) =>
      PgLikeFilter(column, pattern, isCaseSensitive, previousFilter);
}
