import 'package:postgrest/postgrest.dart';
import 'package:typesafe_postgrest/src/filter/filter.dart';
import 'package:typesafe_postgrest/src/modifier/modifier.dart';
import 'package:typesafe_postgrest/typesafe_postgrest.dart';

export 'table_name.dart';

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
    required PgQueryColumnList<TableType> columns,
    required PgModifier<TableType, T, dynamic> modifier,
    PgFilter<TableType>? filter,
  }) async {
    final response = await initialQuery(_tableName)
        .select(columns.map((c) => c.queryPattern).join(', '))
        .applyPgFilter(filter)
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
        .applyPgFilter(filter)
        .applyPgModifier(modelModifier);

    if (response is PgJsonMap) {
      return [modelModifier.fromJson(response)];
    }

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
        .applyPgFilter(filter)
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
        .applyPgFilter(filter)
        .applyPgModifier(modelModifier);

    if (response == null) return null;

    return modelModifier.fromJson(response as PgJsonMap);
  }
}
