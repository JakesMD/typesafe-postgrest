import 'package:meta/meta.dart';
import 'package:postgrest/postgrest.dart';

export 'extensions/_extensions.dart';
export 'filters/_filters.dart';
export 'range_type.dart';

/// {@template typesafe_postgrest.PgFilter}
///
/// Represents a filter that can be applied to a postgrest query.
///
/// Filters allow you to only return rows that match certain conditions.
///
/// Filters can be used on select(), update(), upsert(), and delete() queries.
///
/// [TableType] is used to provide type safety for the filter. Objects that
/// require a filter will only allow filters of the provided [TableType]. Also,
/// the filter will only allow columns and values of the provided [TableType].
///
/// {@endtemplate}
class PgFilter<TableType> {
  /// {@macro typesafe_postgrest.PgFilter}
  @internal
  const PgFilter(this.previousFilter);

  /// The filter that was applied before this one.
  final PgFilter<TableType>? previousFilter;

  /// Cascades the filter onto the provided [builder].
  @mustBeOverridden
  @internal
  PostgrestFilterBuilder<T> build<T>(PostgrestFilterBuilder<T> builder) =>
      builder;

  /// Returns a new filter with the provided [previousFilter].
  @mustBeOverridden
  @internal
  PgFilter<TableType> withPreviousFilter(PgFilter<TableType> previousFilter) =>
      PgFilter(previousFilter);

  /// Chains a new filter onto the current filter chain.
  PgFilter<TableType> and(PgFilter<TableType> other) =>
      other.withPreviousFilter(this);
}
