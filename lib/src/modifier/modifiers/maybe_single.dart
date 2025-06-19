import 'package:meta/meta.dart';
import 'package:postgrest/postgrest.dart';
import 'package:typesafe_postgrest/src/modifier/modifier.dart';
import 'package:typesafe_postgrest/typesafe_postgrest.dart';

/// {@template typesafe_postgrest.PgMaybeSingleModifier}
///
/// Retrieves only one row from the result if there is one.
///
/// {@endtemplate}
class PgMaybeSingleModifier<TableType>
    extends PgModifier<TableType, PgJsonMap?, PgJsonList> {
  /// {@macro typesafe_postgrest.PgMaybeSingleModifier}
  @internal
  const PgMaybeSingleModifier(super.previousModifier);

  @override
  @internal
  PgModifierBuilder<PgJsonMap?> build(
    PostgrestTransformBuilder<PgJsonList> builder,
  ) => PgModifierBuilder(builder.maybeSingle());
}
