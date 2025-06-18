import 'package:postgrest/postgrest.dart';
import 'package:typesafe_postgrest/typesafe_postgrest.dart';

class PgMaybeSingleModifier<TableType>
    extends PgModifier<TableType, PostgrestMap?, PostgrestList, dynamic> {
  const PgMaybeSingleModifier(super.previousModifier);

  @override
  PgModifierBuilder<PostgrestMap?> build(
    PostgrestTransformBuilder<PostgrestList> builder,
  ) => PgModifierBuilder(builder.maybeSingle());
}
