import 'package:typesafe_postgrest/typesafe_postgrest.dart';

/// Provides filters to list filter column types.
extension PgListFilterColumnX<TableType, T>
    on PgFilterColumn<TableType, List<T>?, List<dynamic>?> {
  /// {@macro typesafe_postgrest.PgContainedByArrayFilter}
  PgFilter<TableType> containedByArray(List<T> value) =>
      PgContainedByArrayFilter(this, value, null);

  /// {@macro typesafe_postgrest.PgContainsArrayFilter}
  PgFilter<TableType> containsArray(List<T> values) =>
      PgContainsArrayFilter(this, values, null);

  /// {@macro typesafe_postgrest.PgOverlapsArrayFilter}
  PgFilter<TableType> overlapsArray(List<T> values) =>
      PgOverlapsArrayFilter(this, values, null);
}
