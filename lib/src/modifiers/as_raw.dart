import 'package:postgrest/postgrest.dart';
import 'package:typesafe_postgrest/typesafe_postgrest.dart';

class PgAsRawModifier<TableType>
    extends PgModifier<TableType, PostgrestList, PostgrestList, dynamic> {
  const PgAsRawModifier(super.previousModifier);

  @override
  PgModifierBuilder<PostgrestList> build(
    PostgrestTransformBuilder<PostgrestList> builder,
  ) => PgModifierBuilder(builder);
}
