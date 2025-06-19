import 'package:postgrest/postgrest.dart';
import 'package:typesafe_postgrest/src/modifier/modifier.dart';
import 'package:typesafe_postgrest/typesafe_postgrest.dart';

export 'column.dart';
export 'columns/_columns.dart';
export 'join_to_many.dart';
export 'join_to_one.dart';
export 'table_name.dart';
export 'value.dart';

/// {@template typesafe_postgrest.PgTable}
///
/// Represents a table in the postgres database.
///
/// It handles fetching data from the database with filters and modifiers.
///
/// {@endtemplate}
class PgTable<TableType> {
  /// {@macro typesafe_postgrest.PgTable}
  PgTable({
    required PgTableName<TableType> tableName,
    required this.initialQuery,
  }) : _tableName = tableName.name;

  final String _tableName;

  /// The initial query to the database which allows the table to perform
  /// select, insert, update, and delete operations.
  ///
  /// An exmple for an initial query is:
  /// ``` dart
  // ignore: lines_longer_than_80_chars
  /// initialQuery: (tableName) => supabaseClient.schema('public').from(tableName)
  /// ```
  // Raw type is unnecessary here since it is only the initial query.
  // ignore: strict_raw_type
  final PostgrestQueryBuilder Function(String tableName) initialQuery;

  /// Fetches data from the database. The result type is determined by the
  /// modifier.
  Future<T> fetch<T>({
    required PgColumnList<TableType> columns,
    required PgModifier<TableType, T, dynamic> modifier,
    PgFilter<TableType>? filter,
  }) async {
    final response = await initialQuery(_tableName)
        .select(columns.map((c) => c.queryPattern).join(', '))
        .applyPgModifier(modifier);

    return response as T;
  }

  /// Fetches a list of models from the database.
  Future<List<ModelType>> fetchModels<ModelType extends PgModel<TableType>>({
    required PgModelBuilder<TableType, ModelType> modelBuilder,
    required PgModifier<TableType, PgJsonList, dynamic> modifier,
    PgFilter<TableType>? filter,
  }) async {
    final modelModifier = PgAsModelsModifier(
      modifier,
      modelBuilder.constructor,
    );

    final response = await initialQuery(_tableName)
        .select(modelBuilder.columns.map((c) => c.queryPattern).join(', '))
        .applyPgModifier(modelModifier);

    return PgJsonList.from(
      response as List,
    ).map(modelModifier.fromJson).toList();
  }

  /// Fetches a single model from the database.
  Future<ModelType> fetchModel<ModelType extends PgModel<TableType>>({
    required PgModelBuilder<TableType, ModelType> modelBuilder,
    required PgModifier<TableType, PgJsonMap, dynamic> modifier,
    PgFilter<TableType>? filter,
  }) async {
    final modelModifier = PgAsModelModifier(modifier, modelBuilder.constructor);

    final response = await initialQuery(_tableName)
        .select(modelBuilder.columns.map((c) => c.queryPattern).join(', '))
        .applyPgModifier(modelModifier);

    return modelModifier.fromJson(response as PgJsonMap);
  }

  /// Fetches a single model from the database if it exists.
  Future<ModelType?> maybeFetchModel<ModelType extends PgModel<TableType>>({
    required PgModelBuilder<TableType, ModelType> modelBuilder,
    required PgModifier<TableType, PgJsonMap?, dynamic> modifier,
    PgFilter<TableType>? filter,
  }) async {
    final modelModifier = PgMaybeAsModelModifier(
      modifier,
      modelBuilder.constructor,
    );

    final response = await initialQuery(_tableName)
        .select(modelBuilder.columns.map((c) => c.queryPattern).join(', '))
        .applyPgModifier(modelModifier);

    if (response == null) return null;

    return modelModifier.fromJson(response as PgJsonMap);
  }

  /// {@macro typesafe_postgrest.PgAsCSVModifier}
  PgAsCSVModifier<TableType> asCSV() => PgAsCSVModifier(null);

  /// {@macro typesafe_postgrest.PgAsModelsModifier}
  PgAsModelsModifier<TableType, ModelType>
  asModels<ModelType extends PgModel<TableType>>(
    ModelType Function(PgJsonMap) fromJson,
  ) => PgAsModelsModifier(null, fromJson);

  /// {@macro typesafe_postgrest.PgRawModifier}
  PgAsRawModifier<TableType> asRaw() => PgAsRawModifier(null);

  /// {@macro typesafe_postgrest.PgCountModifier}
  PgCountModifier<TableType> count(CountOption option) =>
      PgCountModifier(null, option);

  /// {@macro typesafe_postgrest.PgMaybeSingleModifier}
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
