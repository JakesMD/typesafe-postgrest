import 'package:typesafe_postgrest/typesafe_postgrest.dart';

/// Provides modifiers that can start the modifier chain.
extension PgTableModifierX<TableType> on PgTable<TableType> {
  /// {@macro typesafe_postgrest.PgAsCSVModifier}
  PgAsCSVModifier<TableType> asCSV() => PgAsCSVModifier(null);

  /// {@macro typesafe_postgrest.PgAsRawModifier}
  PgAsRawModifier<TableType> asRaw() => PgAsRawModifier(null);

  /// {@macro typesafe_postgrest.PgCountModifier}
  PgCountModifier<TableType> count(CountOption option) =>
      PgCountModifier(null, option);

  /// {@macro typesafe_postgrest.PgLimitModifier}
  PgLimitModifier<TableType> limit(int limit) => PgLimitModifier(null, limit);

  /// {@macro typesafe_postgrest.PgMaybeSingleModifier}
  PgMaybeSingleModifier<TableType> maybeSingle() => PgMaybeSingleModifier(null);

  /// {@macro typesafe_postgrest.PgNoneModifier}
  PgNoneModifier<TableType> none() => PgNoneModifier(null);

  /// {@macro typesafe_postgrest.PgOrderModifier}
  PgOrderModifier<TableType> order(
    PgColumn<TableType, dynamic, dynamic> column, {
    bool ascending = false,
    bool nullsFirst = false,
  }) => PgOrderModifier(null, column, ascending, nullsFirst);

  /// {@macro typesafe_postgrest.PgRangeModifier}
  PgRangeModifier<TableType> range(int start, int end) =>
      PgRangeModifier(null, start, end);

  /// {@macro typesafe_postgrest.PgSingleModifier}
  PgSingleModifier<TableType> single() => PgSingleModifier(null);
}
