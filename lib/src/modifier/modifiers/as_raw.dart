import 'package:meta/meta.dart';
import 'package:postgrest/postgrest.dart';
import 'package:typesafe_postgrest/typesafe_postgrest.dart';

/// {@template typesafe_postgrest.PgAsRawModifier}
///
/// Retrieves the response as a [List<Map<String, dynamic>>].
///
/// {@endtemplate}
class PgAsRawModifier<TableType>
    extends PgModifier<TableType, PgJsonList, PgJsonList> {
  /// {@macro typesafe_postgrest.PgAsRawModifier}
  @internal
  const PgAsRawModifier(super.previousModifier);

  @override
  @internal
  PostgrestTransformBuilder<PgJsonList> build(
    PostgrestTransformBuilder<PgJsonList> builder,
  ) => builder;
}
