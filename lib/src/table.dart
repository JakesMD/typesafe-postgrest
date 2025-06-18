import 'package:postgrest/postgrest.dart';
import 'package:typesafe_postgrest/typesafe_postgrest.dart';

class PgTable<TableType> {
  PgTable({
    required PgTableName<TableType> tableName,
    required this.primaryKeys,
    required this.initialQuery,
  }) : _tableName = tableName.name;

  final String _tableName;

  final PgColumnList primaryKeys;

  // Raw type is unnecessary here since it is only the initial query.
  // ignore: strict_raw_type
  final PostgrestQueryBuilder Function(String tableName) initialQuery;

  Future<T> fetch<T, ModelType>({
    required PgColumnList columns,
    required PgModifier<TableType, T, dynamic, ModelType> modifier,

    PgFilter<TableType>? filter,
  }) async {
    final response = await initialQuery(_tableName)
        .select(columns.map((c) => c.queryPattern).join(', '))
        .applyPgModifier(modifier);

    return _castResponse(modifier, response);
  }

  T _castResponse<T, ModelType>(
    PgModifier<TableType, T, dynamic, ModelType> modifier,
    dynamic response,
  ) {
    if (modifier is PgAsModelModifier) {
      return (modifier as PgAsModelModifier).fromJson(response as PostgrestMap)
          as T;
    }

    if (modifier is PgAsModelsModifier) {
      return (response as PostgrestList)
              .map(
                (json) =>
                    (modifier as PgAsModelsModifier).fromJson(json)
                        as ModelType, // This is why the ModelType is required.
              )
              .toList()
          as T;
    }

    if (modifier is PgMaybeAsModelModifier) {
      if (response == null) return null as T;

      return (modifier as PgMaybeAsModelModifier).fromJson(
            response as PostgrestMap,
          )
          as T;
    }

    if (modifier is PgCountModifier) {
      return (response as PostgrestResponse).count as T;
    }

    return response as T;
  }

  PgAsCSVModifier<TableType> asCSV() => PgAsCSVModifier(null);

  PgAsModelsModifier<TableType, ModelType>
  asModels<ModelType extends PgModel<TableType>>(
    ModelType Function(PostgrestMap) fromJson,
  ) => PgAsModelsModifier(null, fromJson);

  PgAsRawModifier<TableType> asRaw() => PgAsRawModifier(null);

  PgCountModifier<TableType> count(CountOption option) =>
      PgCountModifier(null, option);

  PgLimitModifier<TableType> limit(int limit) => PgLimitModifier(null, limit);

  PgMaybeSingleModifier<TableType> maybeSingle() => PgMaybeSingleModifier(null);

  PgNoneModifier<TableType> none() => PgNoneModifier(null);

  PgOrderModifier<TableType> order(
    PgColumn<TableType, dynamic, dynamic> column, {
    bool ascending = false,
    bool nullsFirst = false,
  }) => PgOrderModifier(null, column, ascending, nullsFirst);

  PgRangeModifier<TableType> range(int start, int end) =>
      PgRangeModifier(null, start, end);

  PgSingleModifier<TableType> single() => PgSingleModifier(null);
}
