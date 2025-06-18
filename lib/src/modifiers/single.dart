import 'package:postgrest/postgrest.dart';
import 'package:typesafe_postgrest/typesafe_postgrest.dart';

class PgSingleModifier<TableType>
    extends PgModifier<TableType, PostgrestMap, PostgrestList, dynamic> {
  const PgSingleModifier(super.previousModifier);

  @override
  PgModifierBuilder<PostgrestMap> build(
    PostgrestTransformBuilder<PostgrestList> builder,
  ) => PgModifierBuilder(builder.single());
}
