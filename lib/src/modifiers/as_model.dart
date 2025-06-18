import 'package:postgrest/postgrest.dart';
import 'package:typesafe_postgrest/typesafe_postgrest.dart';

class PgAsModelModifier<TableType, ModelType extends PgModel<TableType>>
    extends PgModifier<TableType, ModelType, PostgrestMap, ModelType> {
  const PgAsModelModifier(super.previousModifier, this.fromJson);

  final ModelType Function(Map<String, dynamic>) fromJson;

  @override
  PgModifierBuilder<ModelType> build(
    PostgrestTransformBuilder<PostgrestMap> builder,
  ) => PgModifierBuilder(builder);
}
