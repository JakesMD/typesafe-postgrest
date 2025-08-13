import 'package:meta/meta.dart';
import 'package:postgrest/postgrest.dart';
import 'package:typesafe_postgrest/src/filter/filter.dart';
import 'package:typesafe_postgrest/src/modifier/modifier.dart';
import 'package:typesafe_postgrest/typesafe_postgrest.dart';

export 'table_name.dart';
export 'upsert.dart';

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
  }) : $tableName = tableName.name;

  @internal
  // This is internal.
  // ignore: public_member_api_docs
  final String $tableName;

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
    final response = await initialQuery($tableName)
        .select(_getQueryPattern(columns))
        .applyPgFilter(filter)
        .applyPgModifier(modifier);

    return response as T;
  }

  /// Fetches a list values from a single column from the database.
  ///
  /// [column] The column to fetch the values from.
  ///
  /// [filter] The filter to apply to the query.
  ///
  /// [modifier] The modifier to apply to the query.
  Future<List<T>> fetchValues<T>({
    required PgQueryColumn<TableType, T, dynamic> column,
    PgModifier<TableType, PgJsonList, dynamic>? modifier,
    PgFilter<TableType>? filter,
  }) async {
    final response = await initialQuery($tableName)
        .select(column.queryPattern)
        .applyPgFilter(filter)
        .applyPgModifier(modifier);

    return _getValuesFromRepsonse(response, column);
  }

  /// Fetches a single value from a single column from the database.
  ///
  /// [column] The column to fetch the value from.
  ///
  /// [filter] The filter to apply to the query.
  ///
  /// [modifier] The modifier to apply to the query.
  Future<T> fetchValue<T>({
    required PgQueryColumn<TableType, T, dynamic> column,
    PgModifier<TableType, PgJsonList, dynamic>? modifier,
    PgFilter<TableType>? filter,
  }) async {
    final response = await initialQuery($tableName)
        .select(column.queryPattern)
        .applyPgFilter(filter)
        .applyPgModifier(_getAsSingleModifier(modifier));

    return _getValueFromRepsonse(response, column);
  }

  /// Fetches a value from a single column from the database if it exists.
  ///
  /// [column] The column to fetch the value from.
  ///
  /// [filter] The filter to apply to the query.
  ///
  /// [modifier] The modifier to apply to the query.
  Future<T?> maybeFetchValue<T>({
    required PgQueryColumn<TableType, T, dynamic> column,
    PgModifier<TableType, PgJsonList, dynamic>? modifier,
    PgFilter<TableType>? filter,
  }) async {
    final response = await initialQuery($tableName)
        .select(column.queryPattern)
        .applyPgFilter(filter)
        .applyPgModifier(_getMaybeAsSingleModifier(modifier));

    return _maybeGetValueFromRepsonse(response, column);
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
    PgModifier<TableType, PgJsonList, dynamic>? modifier,
    PgFilter<TableType>? filter,
  }) async {
    final response = await initialQuery($tableName)
        .select(_getQueryPattern(modelBuilder.columns))
        .applyPgFilter(filter)
        .applyPgModifier(modifier);

    return _getModelsFromRepsonse(response, modelBuilder);
  }

  /// Fetches a single model from the database.
  ///
  /// [modelBuilder] The builder of the model to return.
  ///
  /// [filter] The filter to apply to the query.
  ///
  /// [modifier] The modifier to apply to the query. The limit(1).single()
  ///            modifiers are applied for you.
  Future<ModelType> fetchModel<ModelType extends PgModel<TableType>>({
    required PgModelBuilder<TableType, ModelType> modelBuilder,
    PgModifier<TableType, PgJsonList, dynamic>? modifier,
    PgFilter<TableType>? filter,
  }) async {
    final response = await initialQuery($tableName)
        .select(_getQueryPattern(modelBuilder.columns))
        .applyPgFilter(filter)
        .applyPgModifier(_getAsSingleModifier(modifier));

    return _getModelFromRepsonse(response, modelBuilder);
  }

  /// Fetches a single model from the database if it exists.
  ///
  /// [modelBuilder] The builder of the model to return.
  ///
  /// [filter] The filter to apply to the query.
  ///
  /// [modifier] The modifier to apply to the query. The limit(1).maybeSingle()
  ///            modifiers are applied for you.
  Future<ModelType?> maybeFetchModel<ModelType extends PgModel<TableType>>({
    required PgModelBuilder<TableType, ModelType> modelBuilder,
    PgModifier<TableType, PgJsonList, dynamic>? modifier,
    PgFilter<TableType>? filter,
  }) async {
    final response = await initialQuery($tableName)
        .select(_getQueryPattern(modelBuilder.columns))
        .applyPgFilter(filter)
        .applyPgModifier(_getMaybeAsSingleModifier(modifier));

    return _maybeGetModelFromRepsonse(response, modelBuilder);
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
    final response = await initialQuery($tableName)
        .insert(_getMapsFromUpserts(inserts))
        .applyPgFilter(filter)
        .select(_getQueryPattern(columns ?? const []))
        .applyPgModifier(modifier ?? PgNoneModifier<TableType>(null));

    return response as T;
  }

  /// Inserts data into the database and returns the inserted data as a list of
  /// values from a single column.
  ///
  /// [inserts] The data to insert into the database.
  ///
  /// [column] The column to select from the inserted data.
  ///
  /// [filter] The filter to apply to the query when fetching what was inserted.
  ///
  /// [modifier] The modifier to apply to the query when fetching what was
  ///            inserted.
  Future<List<T>> insertAndFetchValues<T>({
    required List<PgUpsert<TableType>> inserts,
    required PgQueryColumn<TableType, T, dynamic> column,
    PgModifier<TableType, PgJsonList, dynamic>? modifier,
    PgFilter<TableType>? filter,
  }) async {
    final response = await initialQuery($tableName)
        .insert(_getMapsFromUpserts(inserts))
        .applyPgFilter(filter)
        .select(column.queryPattern)
        .applyPgModifier(modifier);

    return _getValuesFromRepsonse(response, column);
  }

  /// Inserts data into the database and returns the inserted data as a single
  /// value from a single column.
  ///
  /// [inserts] The data to insert into the database.
  ///
  /// [column] The column to select from the inserted data.
  ///
  /// [filter] The filter to apply to the query when fetching what was inserted.
  ///
  /// [modifier] The modifier to apply to the query when fetching what was
  ///            inserted.
  Future<T> insertAndFetchValue<T>({
    required List<PgUpsert<TableType>> inserts,
    required PgQueryColumn<TableType, T, dynamic> column,
    PgModifier<TableType, PgJsonList, dynamic>? modifier,
    PgFilter<TableType>? filter,
  }) async {
    final response = await initialQuery($tableName)
        .insert(_getMapsFromUpserts(inserts))
        .applyPgFilter(filter)
        .select(column.queryPattern)
        .applyPgModifier(_getAsSingleModifier(modifier));

    return _getValueFromRepsonse(response, column);
  }

  /// Inserts data into the database and returns the inserted data as a nullable
  /// value from a single column.
  ///
  /// [inserts] The data to insert into the database.
  ///
  /// [column] The column to select from the inserted data.
  ///
  /// [filter] The filter to apply to the query when fetching what was inserted.
  ///
  /// [modifier] The modifier to apply to the query when fetching what was
  ///            inserted.
  Future<T?> insertAndMaybeFetchValue<T>({
    required List<PgUpsert<TableType>> inserts,
    required PgQueryColumn<TableType, T, dynamic> column,
    PgModifier<TableType, PgJsonList, dynamic>? modifier,
    PgFilter<TableType>? filter,
  }) async {
    final response = await initialQuery($tableName)
        .insert(_getMapsFromUpserts(inserts))
        .applyPgFilter(filter)
        .select(column.queryPattern)
        .applyPgModifier(_getMaybeAsSingleModifier(modifier));

    return _maybeGetValueFromRepsonse(response, column);
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
    PgModifier<TableType, PgJsonList, dynamic>? modifier,
    PgFilter<TableType>? filter,
  }) async {
    final response = await initialQuery($tableName)
        .insert(_getMapsFromUpserts(inserts))
        .applyPgFilter(filter)
        .select(_getQueryPattern(modelBuilder.columns))
        .applyPgModifier(modifier);

    return _getModelsFromRepsonse(response, modelBuilder);
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
  ///            inserted. The limit(1).single() modifiers are applied for you.
  Future<ModelType> insertAndFetchModel<ModelType extends PgModel<TableType>>({
    required List<PgUpsert<TableType>> inserts,
    required PgModelBuilder<TableType, ModelType> modelBuilder,
    PgModifier<TableType, PgJsonList, dynamic>? modifier,
    PgFilter<TableType>? filter,
  }) async {
    final response = await initialQuery($tableName)
        .insert(_getMapsFromUpserts(inserts))
        .applyPgFilter(filter)
        .select(_getQueryPattern(modelBuilder.columns))
        .applyPgModifier(_getAsSingleModifier(modifier));

    return _getModelFromRepsonse(response, modelBuilder);
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
  ///            inserted. The limit(1).maybeSingle() modifiers are applied for
  ///            you.
  Future<ModelType?>
  insertAndMaybeFetchModel<ModelType extends PgModel<TableType>>({
    required List<PgUpsert<TableType>> inserts,
    required PgModelBuilder<TableType, ModelType> modelBuilder,
    PgModifier<TableType, PgJsonList, dynamic>? modifier,
    PgFilter<TableType>? filter,
  }) async {
    final response = await initialQuery($tableName)
        .insert(_getMapsFromUpserts(inserts))
        .applyPgFilter(filter)
        .select(_getQueryPattern(modelBuilder.columns))
        .applyPgModifier(_getMaybeAsSingleModifier(modifier));

    return _maybeGetModelFromRepsonse(response, modelBuilder);
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
    final response = await initialQuery($tableName)
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
  /// values from a single column.
  ///
  /// [upserts] The data to upsert into the database.
  ///
  /// [column] The column to select from the upserted data.
  ///
  /// [filter] The filter to apply to the query when fetching what was upserted.
  ///
  /// [modifier] The modifier to apply to the query when fetching what was
  ///            upserted.
  ///
  /// [ignoreDuplicates] Specifies if duplicate rows should be ignored and not
  ///                    inserted.
  Future<List<T>> upsertAndFetchValues<T>({
    required List<PgUpsert<TableType>> upserts,
    required PgQueryColumn<TableType, T, dynamic> column,
    PgModifier<TableType, PgJsonList, dynamic>? modifier,
    PgFilter<TableType>? filter,
    String? onConflict,
    bool ignoreDuplicates = false,
  }) async {
    final response = await initialQuery($tableName)
        .upsert(
          _getMapsFromUpserts(upserts),
          onConflict: onConflict,
          ignoreDuplicates: ignoreDuplicates,
        )
        .applyPgFilter(filter)
        .select(column.queryPattern)
        .applyPgModifier(modifier);

    return _getValuesFromRepsonse(response, column);
  }

  /// Inserts data into the database or updates data when rows with the same
  /// primary keys already exist. It returns the upserted data as a single
  /// value from a single column.
  ///
  /// [upserts] The data to upsert into the database.
  ///
  /// [column] The column to select from the upserted data.
  ///
  /// [filter] The filter to apply to the query when fetching what was upserted.
  ///
  /// [modifier] The modifier to apply to the query when fetching what was
  ///            upserted.
  ///
  /// [ignoreDuplicates] Specifies if duplicate rows should be ignored and not
  ///                    inserted.
  Future<T> upsertAndFetchValue<T>({
    required List<PgUpsert<TableType>> upserts,
    required PgQueryColumn<TableType, T, dynamic> column,
    PgModifier<TableType, PgJsonList, dynamic>? modifier,
    PgFilter<TableType>? filter,
    String? onConflict,
    bool ignoreDuplicates = false,
  }) async {
    final response = await initialQuery($tableName)
        .upsert(
          _getMapsFromUpserts(upserts),
          onConflict: onConflict,
          ignoreDuplicates: ignoreDuplicates,
        )
        .applyPgFilter(filter)
        .select(column.queryPattern)
        .applyPgModifier(_getAsSingleModifier(modifier));

    return _getValueFromRepsonse(response, column);
  }

  /// Inserts data into the database or updates data when rows with the same
  /// primary keys already exist. It returns the upserted data as a nullable
  /// value from a single column.
  ///
  /// [upserts] The data to upsert into the database.
  ///
  /// [column] The column to select from the upserted data.
  ///
  /// [filter] The filter to apply to the query when fetching what was upserted.
  ///
  /// [modifier] The modifier to apply to the query when fetching what was
  ///            upserted.
  ///
  /// [ignoreDuplicates] Specifies if duplicate rows should be ignored and not
  ///                    inserted.
  Future<T?> upsertAndMaybeFetchValue<T>({
    required List<PgUpsert<TableType>> upserts,
    required PgQueryColumn<TableType, T, dynamic> column,
    PgModifier<TableType, PgJsonList, dynamic>? modifier,
    PgFilter<TableType>? filter,
    String? onConflict,
    bool ignoreDuplicates = false,
  }) async {
    final response = await initialQuery($tableName)
        .upsert(
          _getMapsFromUpserts(upserts),
          onConflict: onConflict,
          ignoreDuplicates: ignoreDuplicates,
        )
        .select(column.queryPattern)
        .applyPgModifier(_getMaybeAsSingleModifier(modifier));

    return _maybeGetValueFromRepsonse(response, column);
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
    PgModifier<TableType, PgJsonList, dynamic>? modifier,
    PgFilter<TableType>? filter,
    String? onConflict,
    bool ignoreDuplicates = false,
  }) async {
    final response = await initialQuery($tableName)
        .upsert(
          _getMapsFromUpserts(upserts),
          onConflict: onConflict,
          ignoreDuplicates: ignoreDuplicates,
        )
        .applyPgFilter(filter)
        .select(_getQueryPattern(modelBuilder.columns))
        .applyPgModifier(modifier);

    return _getModelsFromRepsonse(response, modelBuilder);
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
  ///            upserted. The limit(1).single() modifiers are applied for you.
  ///
  /// [ignoreDuplicates] Specifies if duplicate rows should be ignored and not
  ///                    inserted.
  Future<ModelType> upsertAndFetchModel<ModelType extends PgModel<TableType>>({
    required List<PgUpsert<TableType>> upserts,
    required PgModelBuilder<TableType, ModelType> modelBuilder,
    PgModifier<TableType, PgJsonList, dynamic>? modifier,
    PgFilter<TableType>? filter,
    String? onConflict,
    bool ignoreDuplicates = false,
  }) async {
    final response = await initialQuery($tableName)
        .upsert(
          _getMapsFromUpserts(upserts),
          onConflict: onConflict,
          ignoreDuplicates: ignoreDuplicates,
        )
        .applyPgFilter(filter)
        .select(_getQueryPattern(modelBuilder.columns))
        .applyPgModifier(_getAsSingleModifier(modifier));

    return _getModelFromRepsonse(response, modelBuilder);
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
  ///            upserted. The limit(1).maybeSingle() modifiers are applied for
  ///            you.
  ///
  /// [ignoreDuplicates] Specifies if duplicate rows should be ignored and not
  ///                    inserted.
  Future<ModelType?>
  upsertAndMaybeFetchModel<ModelType extends PgModel<TableType>>({
    required List<PgUpsert<TableType>> upserts,
    required PgModelBuilder<TableType, ModelType> modelBuilder,
    PgModifier<TableType, PgJsonList, dynamic>? modifier,
    PgFilter<TableType>? filter,
    String? onConflict,
    bool ignoreDuplicates = false,
  }) async {
    final response = await initialQuery($tableName)
        .upsert(
          _getMapsFromUpserts(upserts),
          onConflict: onConflict,
          ignoreDuplicates: ignoreDuplicates,
        )
        .applyPgFilter(filter)
        .select(_getQueryPattern(modelBuilder.columns))
        .applyPgModifier(_getMaybeAsSingleModifier(modifier));

    return _maybeGetModelFromRepsonse(response, modelBuilder);
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
    final response = await initialQuery($tableName)
        .update(_getMapFromValues(values))
        .applyPgFilter(filter)
        .select(_getQueryPattern(columns ?? const []))
        .applyPgModifier(modifier ?? PgNoneModifier<TableType>(null));

    return response as T;
  }

  /// Updates data in the database and returns the updated data as a list of
  /// values from a single column.
  ///
  /// [values] The data to update in the database.
  ///
  /// [column] The column to select from the updated data.
  ///
  /// [filter] The filter to apply to the query when fetching what was updated.
  ///
  /// [modifier] The modifier to apply to the query when fetching what was
  ///            updated.
  Future<List<T>> updateAndFetchValues<T>({
    required PgValuesList<TableType> values,
    required PgFilter<TableType> filter,
    required PgQueryColumn<TableType, T, dynamic> column,
    PgModifier<TableType, PgJsonList, dynamic>? modifier,
  }) async {
    final response = await initialQuery($tableName)
        .update(_getMapFromValues(values))
        .applyPgFilter(filter)
        .select(column.queryPattern)
        .applyPgModifier(modifier);

    return _getValuesFromRepsonse(response, column);
  }

  /// Updates data in the database and returns the updated data as a single
  /// value from a single column.
  ///
  /// [values] The data to update in the database.
  ///
  /// [column] The column to select from the updated data.
  ///
  /// [filter] The filter to apply to the query when fetching what was updated.
  ///
  /// [modifier] The modifier to apply to the query when fetching what was
  ///            updated.
  Future<T> updateAndFetchValue<T>({
    required PgValuesList<TableType> values,
    required PgFilter<TableType> filter,
    required PgQueryColumn<TableType, T, dynamic> column,
    PgModifier<TableType, PgJsonList, dynamic>? modifier,
  }) async {
    final response = await initialQuery($tableName)
        .update(_getMapFromValues(values))
        .applyPgFilter(filter)
        .select(column.queryPattern)
        .applyPgModifier(_getAsSingleModifier(modifier));

    return _getValueFromRepsonse(response, column);
  }

  /// Updates data in the database and returns the updated data as a nullable
  /// value from a single column.
  ///
  /// [values] The data to update in the database.
  ///
  /// [column] The column to select from the updated data.
  ///
  /// [filter] The filter to apply to the query when fetching what was updated.
  ///
  /// [modifier] The modifier to apply to the query when fetching what was
  ///            updated.
  Future<T?> updateAndMaybeFetchValue<T>({
    required PgValuesList<TableType> values,
    required PgFilter<TableType> filter,
    required PgQueryColumn<TableType, T, dynamic> column,
    PgModifier<TableType, PgJsonList, dynamic>? modifier,
  }) async {
    final response = await initialQuery($tableName)
        .update(_getMapFromValues(values))
        .applyPgFilter(filter)
        .select(column.queryPattern)
        .applyPgModifier(_getMaybeAsSingleModifier(modifier));

    return _maybeGetValueFromRepsonse(response, column);
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
    PgModifier<TableType, PgJsonList, dynamic>? modifier,
  }) async {
    final response = await initialQuery($tableName)
        .update(_getMapFromValues(values))
        .applyPgFilter(filter)
        .select(_getQueryPattern(modelBuilder.columns))
        .applyPgModifier(modifier);

    return _getModelsFromRepsonse(response, modelBuilder);
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
  ///            updated. The limit(1).single() modifiers are applied for you.
  Future<ModelType> updateAndFetchModel<ModelType extends PgModel<TableType>>({
    required PgValuesList<TableType> values,
    required PgFilter<TableType>? filter,
    required PgModelBuilder<TableType, ModelType> modelBuilder,
    PgModifier<TableType, PgJsonList, dynamic>? modifier,
  }) async {
    final response = await initialQuery($tableName)
        .update(_getMapFromValues(values))
        .applyPgFilter(filter)
        .select(_getQueryPattern(modelBuilder.columns))
        .applyPgModifier(_getAsSingleModifier(modifier));

    return _getModelFromRepsonse(response, modelBuilder);
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
  ///            updated. The limit(1).maybeSingle() modifiers are applied for
  ///            you.
  Future<ModelType?>
  updateAndMaybeFetchModel<ModelType extends PgModel<TableType>>({
    required PgValuesList<TableType> values,
    required PgFilter<TableType>? filter,
    required PgModelBuilder<TableType, ModelType> modelBuilder,
    PgModifier<TableType, PgJsonList, dynamic>? modifier,
  }) async {
    final response = await initialQuery($tableName)
        .update(_getMapFromValues(values))
        .applyPgFilter(filter)
        .select(_getQueryPattern(modelBuilder.columns))
        .applyPgModifier(_getMaybeAsSingleModifier(modifier));

    return _maybeGetModelFromRepsonse(response, modelBuilder);
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
    final response = await initialQuery($tableName)
        .delete()
        .applyPgFilter(filter)
        .select(_getQueryPattern(columns ?? const []))
        .applyPgModifier(modifier ?? PgNoneModifier<TableType>(null));

    return response as T;
  }

  /// Deletes data in the database and returns the deleted data as a list of
  /// values from a single column.
  ///
  /// [filter] The filter used to determine what data to delete.
  ///
  /// [column] The column to select from the deleted data.
  ///
  /// [modifier] The modifier to apply to the query when fetching what was
  ///            deleted.
  Future<List<T>> deleteAndFetchValues<T>({
    required PgFilter<TableType> filter,
    required PgQueryColumn<TableType, T, dynamic> column,
    PgModifier<TableType, PgJsonList, dynamic>? modifier,
  }) async {
    final response = await initialQuery($tableName)
        .delete()
        .applyPgFilter(filter)
        .select(column.queryPattern)
        .applyPgModifier(modifier);

    return _getValuesFromRepsonse(response, column);
  }

  /// Deletes data in the database and returns the deleted data as a single
  /// value from a single column.
  ///
  /// [filter] The filter used to determine what data to delete.
  ///
  /// [column] The column to select from the deleted data.
  ///
  /// [modifier] The modifier to apply to the query when fetching what was
  ///            deleted.
  Future<T> deleteAndFetchValue<T>({
    required PgFilter<TableType> filter,
    required PgQueryColumn<TableType, T, dynamic> column,
    PgModifier<TableType, PgJsonList, dynamic>? modifier,
  }) async {
    final response = await initialQuery($tableName)
        .delete()
        .applyPgFilter(filter)
        .select(column.queryPattern)
        .applyPgModifier(_getAsSingleModifier(modifier));

    return _getValueFromRepsonse(response, column);
  }

  /// Deletes data in the database and returns the deleted data as a nullable
  /// value from a single column.
  ///
  /// [filter] The filter used to determine what data to delete.
  ///
  /// [column] The column to select from the deleted data.
  ///
  /// [modifier] The modifier to apply to the query when fetching what was
  ///            deleted.
  Future<T?> deleteAndMaybeFetchValue<T>({
    required PgFilter<TableType> filter,
    required PgQueryColumn<TableType, T, dynamic> column,
    PgModifier<TableType, PgJsonList, dynamic>? modifier,
  }) async {
    final response = await initialQuery($tableName)
        .delete()
        .applyPgFilter(filter)
        .select(column.queryPattern)
        .applyPgModifier(_getMaybeAsSingleModifier(modifier));

    return _maybeGetValueFromRepsonse(response, column);
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
    PgModifier<TableType, PgJsonList, dynamic>? modifier,
  }) async {
    final response = await initialQuery($tableName)
        .delete()
        .applyPgFilter(filter)
        .select(_getQueryPattern(modelBuilder.columns))
        .applyPgModifier(modifier);

    return _getModelsFromRepsonse(response, modelBuilder);
  }

  /// Deletes data in the database and returns the deleted data as a single
  /// model.
  ///
  /// [filter] The filter used to determine what data to delete.
  ///
  /// [modelBuilder] The builder of the model to return.
  ///
  /// [modifier] The modifier to apply to the query when fetching what was
  ///            deleted. The limit(1).single() modifiers are applied for you.
  Future<ModelType> deleteAndFetchModel<ModelType extends PgModel<TableType>>({
    required PgFilter<TableType>? filter,
    required PgModelBuilder<TableType, ModelType> modelBuilder,
    PgModifier<TableType, PgJsonList, dynamic>? modifier,
  }) async {
    final response = await initialQuery($tableName)
        .delete()
        .applyPgFilter(filter)
        .select(_getQueryPattern(modelBuilder.columns))
        .applyPgModifier(_getAsSingleModifier(modifier));

    return _getModelFromRepsonse(response, modelBuilder);
  }

  /// Deletes data in the database and returns the deleted data as a nullable
  /// model.
  ///
  /// [filter] The filter used to determine what data to delete.
  ///
  /// [modelBuilder] The builder of the model to return.
  ///
  /// [modifier] The modifier to apply to the query when fetching what was
  ///            deleted. The limit(1).maybeSingle() modifiers are applied for
  ///            you.
  Future<ModelType?>
  deleteAndMaybeFetchModel<ModelType extends PgModel<TableType>>({
    required PgFilter<TableType>? filter,
    required PgModelBuilder<TableType, ModelType> modelBuilder,
    PgModifier<TableType, PgJsonList, dynamic>? modifier,
  }) async {
    final response = await initialQuery($tableName)
        .delete()
        .applyPgFilter(filter)
        .select(_getQueryPattern(modelBuilder.columns))
        .applyPgModifier(_getMaybeAsSingleModifier(modifier));

    return _maybeGetModelFromRepsonse(response, modelBuilder);
  }

  List<T> _getValuesFromRepsonse<T>(
    dynamic response,
    PgQueryColumn<TableType, T, dynamic> column,
  ) {
    if (response is PgJsonMap && response.containsKey(column.name)) {
      return [column.pgValueFromJson(response[column.name]).value];
    }
    if (response is PgJsonList) {
      return [
        for (final map in response)
          if (map.containsKey(column.name))
            column.pgValueFromJson(map[column.name]).value,
      ];
    }
    return <T>[];
  }

  T _getValueFromRepsonse<T>(
    dynamic response,
    PgQueryColumn<TableType, T, dynamic> column,
  ) => column.pgValueFromJson((response as PgJsonMap)[column.name]).value;

  T? _maybeGetValueFromRepsonse<T>(
    dynamic response,
    PgQueryColumn<TableType, T, dynamic> column,
  ) {
    if (response is! PgJsonMap) return null;
    if (!response.containsKey(column.name)) return null;
    return column.pgValueFromJson(response[column.name]).value;
  }

  List<ModelType> _getModelsFromRepsonse<ModelType extends PgModel<TableType>>(
    dynamic response,
    PgModelBuilder<TableType, ModelType> modelBuilder,
  ) {
    if (response is PgJsonMap) return [modelBuilder.constructor(response)];
    return PgJsonList.from(
      response as List,
    ).map(modelBuilder.constructor).toList();
  }

  ModelType _getModelFromRepsonse<ModelType extends PgModel<TableType>>(
    dynamic response,
    PgModelBuilder<TableType, ModelType> modelBuilder,
  ) => modelBuilder.constructor(response as PgJsonMap);

  ModelType? _maybeGetModelFromRepsonse<ModelType extends PgModel<TableType>>(
    dynamic response,
    PgModelBuilder<TableType, ModelType> modelBuilder,
  ) {
    if (response == null) return null;
    return modelBuilder.constructor(response as PgJsonMap);
  }

  String _getQueryPattern(PgQueryColumnList<TableType> columns) =>
      columns.map((c) => c.queryPattern).join(', ');

  List<Map<String, dynamic>> _getMapsFromUpserts(
    List<PgUpsert<TableType>> upserts,
  ) => upserts.map((upsert) => upsert.toJson()).toList();

  Map<String, dynamic> _getMapFromValues(PgValuesList<TableType> values) => {
    for (final value in values) value.columnName: value.toJson(),
  };

  PgModifier<TableType, PgJsonMap, dynamic> _getAsSingleModifier(
    PgModifier<TableType, PgJsonList, dynamic>? modifier,
  ) => PgLimitModifier(modifier, 1).single();

  PgModifier<TableType, PgJsonMap?, dynamic>
  _getMaybeAsSingleModifier<ModelType extends PgModel<TableType>>(
    PgModifier<TableType, PgJsonList, dynamic>? modifier,
  ) => PgLimitModifier(modifier, 1).maybeSingle();
}
