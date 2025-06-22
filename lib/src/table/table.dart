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
  ///
  /// [columns] The columns to select.
  ///
  /// [filter] The filter to apply to the query.
  ///
  /// [modifier] The modifier to apply to the query.
  Future<T> fetch<T>({
    required PgQueryColumnList<TableType> columns,
    required PgModifier<TableType, T, dynamic> modifier,
    PgFilter<TableType>? filter,
  }) async {
    final response = await initialQuery(_tableName)
        .select(_getQueryPattern(columns))
        .applyPgFilter(filter)
        .applyPgModifier(modifier);

    return response as T;
  }

  /// Fetches a list of models from the database.
  ///
  /// [modelBuilder] The builder of the model to return.
  ///
  /// [filter] The filter to apply to the query.
  ///
  /// [modifier] The modifier to apply to the query.
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
        .select(_getQueryPattern(modelBuilder.columns))
        .applyPgFilter(filter)
        .applyPgModifier(modelModifier);

    return _getModelsFromRepsonse(response, modelModifier);
  }

  /// Fetches a single model from the database.
  ///
  /// [modelBuilder] The builder of the model to return.
  ///
  /// [filter] The filter to apply to the query.
  ///
  /// [modifier] The modifier to apply to the query.
  Future<ModelType> fetchModel<ModelType extends PgModel<TableType>>({
    required PgModelBuilder<TableType, ModelType> modelBuilder,
    required PgModifier<TableType, PgJsonMap, dynamic> modifier,
    PgFilter<TableType>? filter,
  }) async {
    final modelModifier = PgAsModelModifier(modifier, modelBuilder.constructor);

    final response = await initialQuery(_tableName)
        .select(_getQueryPattern(modelBuilder.columns))
        .applyPgFilter(filter)
        .applyPgModifier(modelModifier);

    return _getModelFromRepsonse(response, modelModifier);
  }

  /// Fetches a single model from the database if it exists.
  ///
  /// [modelBuilder] The builder of the model to return.
  ///
  /// [filter] The filter to apply to the query.
  ///
  /// [modifier] The modifier to apply to the query.
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
        .select(_getQueryPattern(modelBuilder.columns))
        .applyPgFilter(filter)
        .applyPgModifier(modelModifier);

    return _maybeGetModelFromRepsonse(response, modelModifier);
  }

  /// Inserts data into the database and can return inserted data if specified
  /// by the modifier.
  ///
  /// [inserts] The data to insert into the database.
  ///
  /// [columns] The columns to select from the inserted data.
  ///
  /// [filter] The filter to apply to the query when fetching what was inserted.
  ///
  /// [modifier] The modifier to apply to the query when fetching what was
  ///            inserted.
  Future<T> insert<T>({
    required List<PgUpsert<TableType>> inserts,
    PgQueryColumnList<TableType>? columns,
    PgModifier<TableType, T, dynamic>? modifier,
    PgFilter<TableType>? filter,
  }) async {
    final response = await initialQuery(_tableName)
        .insert(_getMapsFromUpserts(inserts))
        .applyPgFilter(filter)
        .select(_getQueryPattern(columns ?? const []))
        .applyPgModifier(modifier ?? PgNoneModifier<TableType>(null));

    return response as T;
  }

  /// Inserts data into the database and returns the inserted data as a list of
  /// models.
  ///
  /// [inserts] The data to insert into the database.
  ///
  /// [modelBuilder] The builder of the model to return.
  ///
  /// [filter] The filter to apply to the query when fetching what was inserted.
  ///
  /// [modifier] The modifier to apply to the query when fetching what was
  ///            inserted.
  Future<List<ModelType>>
  insertAndFetchModels<ModelType extends PgModel<TableType>>({
    required List<PgUpsert<TableType>> inserts,
    required PgModelBuilder<TableType, ModelType> modelBuilder,
    required PgModifier<TableType, PgJsonList, dynamic> modifier,
    PgFilter<TableType>? filter,
  }) async {
    final modelModifier = PgAsModelsModifier(
      modifier,
      modelBuilder.constructor,
    );

    final response = await initialQuery(_tableName)
        .insert(_getMapsFromUpserts(inserts))
        .applyPgFilter(filter)
        .select(_getQueryPattern(modelBuilder.columns))
        .applyPgModifier(modelModifier);

    return _getModelsFromRepsonse(response, modelModifier);
  }

  /// Inserts data into the database and returns the inserted data as a single
  /// model.
  ///
  /// [inserts] The data to insert into the database.
  ///
  /// [modelBuilder] The builder of the model to return.
  ///
  /// [filter] The filter to apply to the query when fetching what was inserted.
  ///
  /// [modifier] The modifier to apply to the query when fetching what was
  ///            inserted.
  Future<ModelType> insertAndFetchModel<ModelType extends PgModel<TableType>>({
    required List<PgUpsert<TableType>> inserts,
    required PgModelBuilder<TableType, ModelType> modelBuilder,
    required PgModifier<TableType, PgJsonMap, dynamic> modifier,
    PgFilter<TableType>? filter,
  }) async {
    final modelModifier = PgAsModelModifier(modifier, modelBuilder.constructor);

    final response = await initialQuery(_tableName)
        .insert(_getMapsFromUpserts(inserts))
        .applyPgFilter(filter)
        .select(_getQueryPattern(modelBuilder.columns))
        .applyPgModifier(modelModifier);

    return _getModelFromRepsonse(response, modelModifier);
  }

  /// Inserts data into the database and returns the inserted data as a nullable
  /// model.
  ///
  /// [inserts] The data to insert into the database.
  ///
  /// [modelBuilder] The builder of the model to return.
  ///
  /// [filter] The filter to apply to the query when fetching what was inserted.
  ///
  /// [modifier] The modifier to apply to the query when fetching what was
  ///            inserted.
  Future<ModelType?>
  insertAndMaybeFetchModel<ModelType extends PgModel<TableType>>({
    required List<PgUpsert<TableType>> inserts,
    required PgModelBuilder<TableType, ModelType> modelBuilder,
    required PgModifier<TableType, PgJsonMap?, dynamic> modifier,
    PgFilter<TableType>? filter,
  }) async {
    final modelModifier = PgMaybeAsModelModifier(
      modifier,
      modelBuilder.constructor,
    );

    final response = await initialQuery(_tableName)
        .insert(_getMapsFromUpserts(inserts))
        .applyPgFilter(filter)
        .select(_getQueryPattern(modelBuilder.columns))
        .applyPgModifier(modelModifier);

    return _maybeGetModelFromRepsonse(response, modelModifier);
  }

  /// Inserts data into the database or updates data when rows with the same
  /// primary keys already exist. It can return upserted data if specified by
  /// the modifier.
  ///
  /// [upserts] The data to upsert into the database.
  ///
  /// [columns] The columns to select from the upserted data.
  ///
  /// [filter] The filter to apply to the query when fetching what was upserted.
  ///
  /// [modifier] The modifier to apply to the query when fetching what was
  ///            upserted.
  Future<T> upsert<T>({
    required List<PgUpsert<TableType>> upserts,
    PgQueryColumnList<TableType>? columns,
    PgModifier<TableType, T, dynamic>? modifier,
    PgFilter<TableType>? filter,
    String? onConflict,
    bool ignoreDuplicates = false,
  }) async {
    final response = await initialQuery(_tableName)
        .upsert(
          _getMapsFromUpserts(upserts),
          onConflict: onConflict,
          ignoreDuplicates: ignoreDuplicates,
        )
        .applyPgFilter(filter)
        .select(_getQueryPattern(columns ?? const []))
        .applyPgModifier(modifier ?? PgNoneModifier<TableType>(null));

    return response as T;
  }

  /// Inserts data into the database or updates data when rows with the same
  /// primary keys already exist. It returns the upserted data as a list of
  /// models.
  ///
  /// [upserts] The data to upsert into the database.
  ///
  /// [modelBuilder] The builder of the model to return.
  ///
  /// [filter] The filter to apply to the query when fetching what was upserted.
  ///
  /// [modifier] The modifier to apply to the query when fetching what was
  ///            upserted.
  ///
  /// [ignoreDuplicates] Specifies if duplicate rows should be ignored and not
  ///                    inserted.
  Future<List<ModelType>>
  upsertAndFetchModels<ModelType extends PgModel<TableType>>({
    required List<PgUpsert<TableType>> upserts,
    required PgModelBuilder<TableType, ModelType> modelBuilder,
    required PgModifier<TableType, PgJsonList, dynamic> modifier,
    PgFilter<TableType>? filter,
    String? onConflict,
    bool ignoreDuplicates = false,
  }) async {
    final modelModifier = PgAsModelsModifier(
      modifier,
      modelBuilder.constructor,
    );

    final response = await initialQuery(_tableName)
        .upsert(
          _getMapsFromUpserts(upserts),
          onConflict: onConflict,
          ignoreDuplicates: ignoreDuplicates,
        )
        .applyPgFilter(filter)
        .select(_getQueryPattern(modelBuilder.columns))
        .applyPgModifier(modelModifier);

    return _getModelsFromRepsonse(response, modelModifier);
  }

  /// Inserts data into the database or updates data when rows with the same
  /// primary keys already exist. It returns the upserted data as a single
  /// model.
  ///
  /// [upserts] The data to upsert into the database.
  ///
  /// [modelBuilder] The builder of the model to return.
  ///
  /// [filter] The filter to apply to the query when fetching what was upserted.
  ///
  /// [modifier] The modifier to apply to the query when fetching what was
  ///            upserted.
  ///
  /// [ignoreDuplicates] Specifies if duplicate rows should be ignored and not
  ///                    inserted.
  Future<ModelType> upsertAndFetchModel<ModelType extends PgModel<TableType>>({
    required List<PgUpsert<TableType>> upserts,
    required PgModelBuilder<TableType, ModelType> modelBuilder,
    required PgModifier<TableType, PgJsonMap, dynamic> modifier,
    PgFilter<TableType>? filter,
    String? onConflict,
    bool ignoreDuplicates = false,
  }) async {
    final modelModifier = PgAsModelModifier(modifier, modelBuilder.constructor);

    final response = await initialQuery(_tableName)
        .upsert(
          _getMapsFromUpserts(upserts),
          onConflict: onConflict,
          ignoreDuplicates: ignoreDuplicates,
        )
        .applyPgFilter(filter)
        .select(_getQueryPattern(modelBuilder.columns))
        .applyPgModifier(modelModifier);

    return _getModelFromRepsonse(response, modelModifier);
  }

  /// Inserts data into the database or updates data when rows with the same
  /// primary keys already exist. It returns the upserted data as a nullable
  /// model.
  ///
  /// [upserts] The data to upsert into the database.
  ///
  /// [modelBuilder] The builder of the model to return.
  ///
  /// [filter] The filter to apply to the query when fetching what was upserted.
  ///
  /// [modifier] The modifier to apply to the query when fetching what was
  ///            upserted.
  ///
  /// [ignoreDuplicates] Specifies if duplicate rows should be ignored and not
  ///                    inserted.
  Future<ModelType?>
  upsertAndMaybeFetchModel<ModelType extends PgModel<TableType>>({
    required List<PgUpsert<TableType>> upserts,
    required PgModelBuilder<TableType, ModelType> modelBuilder,
    required PgModifier<TableType, PgJsonMap?, dynamic> modifier,
    PgFilter<TableType>? filter,
    String? onConflict,
    bool ignoreDuplicates = false,
  }) async {
    final modelModifier = PgMaybeAsModelModifier(
      modifier,
      modelBuilder.constructor,
    );

    final response = await initialQuery(_tableName)
        .upsert(
          _getMapsFromUpserts(upserts),
          onConflict: onConflict,
          ignoreDuplicates: ignoreDuplicates,
        )
        .applyPgFilter(filter)
        .select(_getQueryPattern(modelBuilder.columns))
        .applyPgModifier(modelModifier);

    return _maybeGetModelFromRepsonse(response, modelModifier);
  }

  /// Updates data in the database and can return updated data if specified by
  /// the modifier.
  ///
  /// [values] The data to update in the database.
  ///
  /// [columns] The columns to select from the updated data.
  ///
  /// [filter] The filter to apply to the query when fetching what was updated.
  ///
  /// [modifier] The modifier to apply to the query when fetching what was
  ///            updated.
  Future<T> update<T>({
    required PgValuesList<TableType> values,
    required PgFilter<TableType> filter,
    PgQueryColumnList<TableType>? columns,
    PgModifier<TableType, T, dynamic>? modifier,
  }) async {
    final response = await initialQuery(_tableName)
        .update(_getMapFromValues(values))
        .applyPgFilter(filter)
        .select(_getQueryPattern(columns ?? const []))
        .applyPgModifier(modifier ?? PgNoneModifier<TableType>(null));

    return response as T;
  }

  /// Updates data in the database and returns the updated data as a list of
  /// models.
  ///
  /// [values] The data to update in the database.
  ///
  /// [modelBuilder] The builder of the model to return.
  ///
  /// [filter] The filter to apply to the query when fetching what was updated.
  ///
  /// [modifier] The modifier to apply to the query when fetching what was
  ///            updated.
  Future<List<ModelType>>
  updateAndFetchModels<ModelType extends PgModel<TableType>>({
    required PgValuesList<TableType> values,
    required PgFilter<TableType> filter,
    required PgModelBuilder<TableType, ModelType> modelBuilder,
    required PgModifier<TableType, PgJsonList, dynamic> modifier,
  }) async {
    final modelModifier = PgAsModelsModifier(
      modifier,
      modelBuilder.constructor,
    );

    final response = await initialQuery(_tableName)
        .update(_getMapFromValues(values))
        .applyPgFilter(filter)
        .select(_getQueryPattern(modelBuilder.columns))
        .applyPgModifier(modelModifier);

    return _getModelsFromRepsonse(response, modelModifier);
  }

  /// Updates data in the database and returns the updated data as a single
  /// model.
  ///
  /// [values] The data to update in the database.
  ///
  /// [modelBuilder] The builder of the model to return.
  ///
  /// [filter] The filter to apply to the query when fetching what was updated.
  ///
  /// [modifier] The modifier to apply to the query when fetching what was
  ///            updated.
  Future<ModelType> updateAndFetchModel<ModelType extends PgModel<TableType>>({
    required PgValuesList<TableType> values,
    required PgFilter<TableType>? filter,
    required PgModelBuilder<TableType, ModelType> modelBuilder,
    required PgModifier<TableType, PgJsonMap, dynamic> modifier,
  }) async {
    final modelModifier = PgAsModelModifier(modifier, modelBuilder.constructor);

    final response = await initialQuery(_tableName)
        .update(_getMapFromValues(values))
        .applyPgFilter(filter)
        .select(_getQueryPattern(modelBuilder.columns))
        .applyPgModifier(modelModifier);

    return _getModelFromRepsonse(response, modelModifier);
  }

  /// Updates data in the database and returns the updated data as a nullable
  /// model.
  ///
  /// [values] The data to update in the database.
  ///
  /// [modelBuilder] The builder of the model to return.
  ///
  /// [filter] The filter to apply to the query when fetching what was updated.
  ///
  /// [modifier] The modifier to apply to the query when fetching what was
  ///            updated.
  Future<ModelType?>
  updateAndMaybeFetchModel<ModelType extends PgModel<TableType>>({
    required PgValuesList<TableType> values,
    required PgFilter<TableType>? filter,
    required PgModelBuilder<TableType, ModelType> modelBuilder,
    required PgModifier<TableType, PgJsonMap?, dynamic> modifier,
  }) async {
    final modelModifier = PgMaybeAsModelModifier(
      modifier,
      modelBuilder.constructor,
    );

    final response = await initialQuery(_tableName)
        .update(_getMapFromValues(values))
        .applyPgFilter(filter)
        .select(_getQueryPattern(modelBuilder.columns))
        .applyPgModifier(modelModifier);

    return _maybeGetModelFromRepsonse(response, modelModifier);
  }

  /// Deletes data in the database and can return deleted data if specified by
  /// the modifier.
  ///
  /// [filter] The filter used to determine what data to delete.
  ///
  /// [columns] The columns to select from the deleted data.
  ///
  /// [modifier] The modifier to apply to the query when fetching what was
  ///            deleted.
  Future<T> delete<T>({
    required PgFilter<TableType> filter,
    PgQueryColumnList<TableType>? columns,
    PgModifier<TableType, T, dynamic>? modifier,
  }) async {
    final response = await initialQuery(_tableName)
        .delete()
        .applyPgFilter(filter)
        .select(_getQueryPattern(columns ?? const []))
        .applyPgModifier(modifier ?? PgNoneModifier<TableType>(null));

    return response as T;
  }

  /// Deletes data in the database and returns the deleted data as a list of
  /// models.
  ///
  /// [filter] The filter used to determine what data to delete.
  ///
  /// [modelBuilder] The builder of the model to return.
  ///
  /// [modifier] The modifier to apply to the query when fetching what was
  ///            deleted.
  Future<List<ModelType>>
  deleteAndFetchModels<ModelType extends PgModel<TableType>>({
    required PgFilter<TableType> filter,
    required PgModelBuilder<TableType, ModelType> modelBuilder,
    required PgModifier<TableType, PgJsonList, dynamic> modifier,
  }) async {
    final modelModifier = PgAsModelsModifier(
      modifier,
      modelBuilder.constructor,
    );

    final response = await initialQuery(_tableName)
        .delete()
        .applyPgFilter(filter)
        .select(_getQueryPattern(modelBuilder.columns))
        .applyPgModifier(modelModifier);

    return _getModelsFromRepsonse(response, modelModifier);
  }

  /// Deletes data in the database and returns the deleted data as a single
  /// model.
  ///
  /// [filter] The filter used to determine what data to delete.
  ///
  /// [modelBuilder] The builder of the model to return.
  ///
  /// [modifier] The modifier to apply to the query when fetching what was
  ///            deleted.
  Future<ModelType> deleteAndFetchModel<ModelType extends PgModel<TableType>>({
    required PgFilter<TableType>? filter,
    required PgModelBuilder<TableType, ModelType> modelBuilder,
    required PgModifier<TableType, PgJsonMap, dynamic> modifier,
  }) async {
    final modelModifier = PgAsModelModifier(modifier, modelBuilder.constructor);

    final response = await initialQuery(_tableName)
        .delete()
        .applyPgFilter(filter)
        .select(_getQueryPattern(modelBuilder.columns))
        .applyPgModifier(modelModifier);

    return _getModelFromRepsonse(response, modelModifier);
  }

  /// Deletes data in the database and returns the deleted data as a nullable
  /// model.
  ///
  /// [filter] The filter used to determine what data to delete.
  ///
  /// [modelBuilder] The builder of the model to return.
  ///
  /// [modifier] The modifier to apply to the query when fetching what was
  ///            deleted.
  Future<ModelType?>
  deleteAndMaybeFetchModel<ModelType extends PgModel<TableType>>({
    required PgFilter<TableType>? filter,
    required PgModelBuilder<TableType, ModelType> modelBuilder,
    required PgModifier<TableType, PgJsonMap?, dynamic> modifier,
  }) async {
    final modelModifier = PgMaybeAsModelModifier(
      modifier,
      modelBuilder.constructor,
    );

    final response = await initialQuery(_tableName)
        .delete()
        .applyPgFilter(filter)
        .select(_getQueryPattern(modelBuilder.columns))
        .applyPgModifier(modelModifier);

    return _maybeGetModelFromRepsonse(response, modelModifier);
  }

  List<ModelType> _getModelsFromRepsonse<ModelType extends PgModel<TableType>>(
    dynamic response,
    PgAsModelsModifier<TableType, ModelType> modelModifier,
  ) {
    if (response is PgJsonMap) return [modelModifier.fromJson(response)];
    return PgJsonList.from(
      response as List,
    ).map(modelModifier.fromJson).toList();
  }

  ModelType _getModelFromRepsonse<ModelType extends PgModel<TableType>>(
    dynamic response,
    PgAsModelModifier<TableType, ModelType> modelModifier,
  ) => modelModifier.fromJson(response as PgJsonMap);

  ModelType? _maybeGetModelFromRepsonse<ModelType extends PgModel<TableType>>(
    dynamic response,
    PgMaybeAsModelModifier<TableType, ModelType> modelModifier,
  ) {
    if (response == null) return null;
    return modelModifier.fromJson(response as PgJsonMap);
  }

  String _getQueryPattern(PgQueryColumnList<TableType> columns) =>
      columns.map((c) => c.queryPattern).join(', ');

  List<Map<String, dynamic>> _getMapsFromUpserts(
    List<PgUpsert<TableType>> upserts,
  ) => upserts.map((upsert) => _getMapFromValues(upsert.values)).toList();

  Map<String, dynamic> _getMapFromValues(PgValuesList<TableType> values) => {
    for (final value in values) value.columnName: value.toJson(),
  };
}
