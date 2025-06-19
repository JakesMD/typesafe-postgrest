import 'package:meta/meta.dart';
import 'package:postgrest/postgrest.dart';
import 'package:typesafe_postgrest/src/modifier/modifier.dart';
import 'package:typesafe_postgrest/typesafe_postgrest.dart';

/// {@template typesafe_postgrest.PgSingleModifier}
///
/// Retrieves only one row from the result. Result must be one row (e.g. using
/// limit), otherwise this will result in an error.
///
/// {@endtemplate}
class PgSingleModifier<TableType>
    extends PgModifier<TableType, PgJsonMap, PgJsonList> {
  /// {@macro typesafe_postgrest.PgSingleModifier}
  @internal
  const PgSingleModifier(super.previousModifier);

  @override
  @internal
  PgModifierBuilder<PgJsonMap> build(
    PostgrestTransformBuilder<PgJsonList> builder,
  ) => PgModifierBuilder(builder.single());
}
