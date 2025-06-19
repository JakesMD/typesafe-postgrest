import 'package:postgrest/postgrest.dart';
import 'package:typesafe_postgrest/typesafe_postgrest.dart';

/// Provides modifiers that can be chained onto a list modifier.
///
/// All these methods must be added to [PgTable].
///
/// Notice that `asModels` is missing. This is so that the user is forced to use
/// [PgTable.fetchModels].
extension PgListModifierX<TableType>
    on PgModifier<TableType, PgJsonList, dynamic> {
  /// {@macro typesafe_postgrest.PgAsCSVModifier}
  PgAsCSVModifier<TableType> asCSV() => PgAsCSVModifier(this);

  /// {@macro typesafe_postgrest.PgRawModifier}
  PgAsRawModifier<TableType> asRaw() => PgAsRawModifier(this);

  /// {@macro typesafe_postgrest.PgCountModifier}
  PgCountModifier<TableType> count(CountOption option) =>
      PgCountModifier(this, option);

  /// {@macro typesafe_postgrest.PgMaybeSingleModifier}
  PgLimitModifier<TableType> limit(int limit) => PgLimitModifier(this, limit);

  /// {@macro typesafe_postgrest.PgMaybeSingleModifier}
  PgMaybeSingleModifier<TableType> maybeSingle() => PgMaybeSingleModifier(this);

  /// {@macro typesafe_postgrest.PgNoneModifier}
  PgNoneModifier<TableType> none() => PgNoneModifier(this);

  /// {@macro typesafe_postgrest.PgOrderModifier}
  PgOrderModifier<TableType> order(
    PgColumn<TableType, dynamic, dynamic> column, {
    bool ascending = false,
    bool nullsFirst = false,
  }) => PgOrderModifier(this, column, ascending, nullsFirst);

  /// {@macro typesafe_postgrest.PgRangeModifier}
  PgRangeModifier<TableType> range(int start, int end) =>
      PgRangeModifier(this, start, end);

  /// {@macro typesafe_postgrest.PgSingleModifier}
  PgSingleModifier<TableType> single() => PgSingleModifier(this);
}
