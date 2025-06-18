import 'package:postgrest/postgrest.dart';
import 'package:typesafe_postgrest/typesafe_postgrest.dart';

class PgAsModelsModifier<TableType, ModelType extends PgModel<TableType>>
    extends PgModifier<TableType, List<ModelType>, PostgrestList, ModelType> {
  const PgAsModelsModifier(super.previousModifier, this.fromJson);

  final ModelType Function(Map<String, dynamic>) fromJson;

  @override
  PgModifierBuilder<List<ModelType>> build(
    PostgrestTransformBuilder<PostgrestList> builder,
  ) => PgModifierBuilder(builder);
}
