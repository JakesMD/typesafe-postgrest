import 'package:meta/meta.dart';
import 'package:postgrest/postgrest.dart';
import 'package:typesafe_postgrest/src/modifier/modifier.dart';
import 'package:typesafe_postgrest/typesafe_postgrest.dart';

/// {@template typesafe_postgrest.PgAsModelsModifier}
///
/// Retrieves the response as a [List<Map<String, dynamic>>]. The response will
/// be converted to a list of the the provided [ModelType] using the provided
/// [fromJson] function.
///
/// This modifier should be excluded from any modifier extensions. This is so
/// that the user is forced to use [PgTable.fetchModels].
///
/// {@endtemplate}
class PgAsModelsModifier<TableType, ModelType extends PgModel<TableType>>
    extends PgModifier<TableType, List<ModelType>, PgJsonList> {
  /// {@macro typesafe_postgrest.PgAsModelsModifier}
  @internal
  const PgAsModelsModifier(super.previousModifier, this.fromJson);

  /// The function used to convert the JSON to the model.
  final ModelType Function(Map<String, dynamic>) fromJson;

  @override
  @internal
  PgModifierBuilder<List<ModelType>> build(
    PostgrestTransformBuilder<PgJsonList> builder,
  ) => PgModifierBuilder(builder);
}
