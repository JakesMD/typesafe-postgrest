import 'package:typesafe_postgrest/typesafe_postgrest.dart';

/// Provides filters to all filter column types.
extension PgAllFilterColumnsX<TableType, ValueType, JsonValueType>
    on PgFilterColumn<TableType, ValueType, JsonValueType> {
  /// {@macro typesafe_postgrest.PgContainedByRangeFilter}
  PgFilter<TableType> containedByRange<J extends Object>(
    J lowerBound,
    J upperBound, {
    PgRangeType rangeType = PgRangeType.inclusiveInclusive,
  }) => PgContainedByRangeFilter(this, lowerBound, upperBound, rangeType, null);

  /// {@macro typesafe_postgrest.PgContainsRangeFilter}
  PgFilter<TableType> containsRange<J extends Object>(
    J lowerBound,
    J upperBound, {
    PgRangeType rangeType = PgRangeType.inclusiveInclusive,
  }) => PgContainsRangeFilter(this, lowerBound, upperBound, rangeType, null);

  /// {@macro typesafe_postgrest.PgEqualFilter}
  PgFilter<TableType> equals(ValueType value) =>
      PgEqualFilter(this, value, null);

  /// {@macro typesafe_postgrest.PgGreaterOrEqualFilter}
  PgFilter<TableType> greaterOrEqual(ValueType value) =>
      PgGreaterOrEqualFilter(this, value, null);

  /// {@macro typesafe_postgrest.PgGreaterFilter}
  PgFilter<TableType> greater(ValueType value) =>
      PgGreaterFilter(this, value, null);

  /// {@macro typesafe_postgrest.PgIncludedInFilter}
  PgFilter<TableType> includedIn(List<ValueType> values) =>
      PgIncludedInFilter(this, values, null);

  /// {@macro typesafe_postgrest.PgLessOrEqualFilter}
  PgFilter<TableType> lessOrEqual(ValueType value) =>
      PgLessOrEqualFilter(this, value, null);

  /// {@macro typesafe_postgrest.PgLessFilter}
  PgFilter<TableType> less(ValueType value) => PgLessFilter(this, value, null);

  /// {@macro typesafe_postgrest.PgNotEqualFilter}
  PgFilter<TableType> notEqual(ValueType value) =>
      PgNotEqualFilter(this, value, null);

  /// {@macro typesafe_postgrest.PgOverlapsRangeFilter}
  PgFilter<TableType> overlapsRange<J extends Object>(
    J lowerBound,
    J upperBound, {
    PgRangeType rangeType = PgRangeType.inclusiveInclusive,
  }) => PgOverlapsRangeFilter(this, lowerBound, upperBound, rangeType, null);

  /// {@macro typesafe_postgrest.PgRangeAdjacentFilter}
  PgFilter<TableType> rangeAdjacent<J extends Object>(
    J lowerBound,
    J upperBound, {
    PgRangeType rangeType = PgRangeType.inclusiveInclusive,
  }) => PgRangeAdjacentFilter(this, lowerBound, upperBound, rangeType, null);

  /// {@macro typesafe_postgrest.PgRangeGreaterOrEqualFilter}
  PgFilter<TableType> rangeGreaterOrEqual<J extends Object>(
    J lowerBound,
    J upperBound, {
    PgRangeType rangeType = PgRangeType.inclusiveInclusive,
  }) => PgRangeGreaterOrEqualFilter(
    this,
    lowerBound,
    upperBound,
    rangeType,
    null,
  );

  /// {@macro typesafe_postgrest.PgRangeGreaterFilter}
  PgFilter<TableType> rangeGreater<J extends Object>(
    J lowerBound,
    J upperBound, {
    PgRangeType rangeType = PgRangeType.inclusiveInclusive,
  }) => PgRangeGreaterFilter(this, lowerBound, upperBound, rangeType, null);

  /// {@macro typesafe_postgrest.PgRangeLessOrEqualFilter}
  PgFilter<TableType> rangeLessOrEqual<J extends Object>(
    J lowerBound,
    J upperBound, {
    PgRangeType rangeType = PgRangeType.inclusiveInclusive,
  }) => PgRangeLessOrEqualFilter(this, lowerBound, upperBound, rangeType, null);

  /// {@macro typesafe_postgrest.PgRangeLessFilter}
  PgFilter<TableType> rangeLess<J extends Object>(
    J lowerBound,
    J upperBound, {
    PgRangeType rangeType = PgRangeType.inclusiveInclusive,
  }) => PgRangeLessFilter(this, lowerBound, upperBound, rangeType, null);
}
