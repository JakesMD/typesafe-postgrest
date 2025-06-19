import 'package:meta/meta.dart';
import 'package:postgrest/postgrest.dart';
import 'package:typesafe_postgrest/src/modifier/modifier.dart';
import 'package:typesafe_postgrest/typesafe_postgrest.dart';

/// {@template typesafe_postgrest.PgMaybeAsModelModifier}
///
/// Retrieves the response as a [Map<String, dynamic>?]. The response will be
/// converted to the provided [ModelType] using the provided [fromJson]
/// function if the response is not null.
///
/// This modifier should be excluded from any modifier extensions. This is so
/// that the user is forced to use [PgTable.maybeFetchModel].
///
/// {@endtemplate}
class PgMaybeAsModelModifier<TableType, ModelType extends PgModel<TableType>>
    extends PgModifier<TableType, ModelType?, PgJsonMap?> {
  /// {@macro typesafe_postgrest.PgMaybeAsModelModifier}
  @internal
  const PgMaybeAsModelModifier(super.previousModifier, this.fromJson);

  /// The function used to convert the JSON to the model.
  final ModelType Function(Map<String, dynamic>) fromJson;

  @override
  @internal
  PgModifierBuilder<ModelType?> build(
    PostgrestTransformBuilder<PgJsonMap?> builder,
  ) => PgModifierBuilder(builder);
}
