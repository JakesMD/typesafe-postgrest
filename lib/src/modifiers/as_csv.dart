import 'package:postgrest/postgrest.dart';
import 'package:typesafe_postgrest/typesafe_postgrest.dart';

class PgAsCSVModifier<TableType>
    extends PgModifier<TableType, String, dynamic, dynamic> {
  const PgAsCSVModifier(super.previousModifier);

  @override
  PgModifierBuilder<String> build(
    PostgrestTransformBuilder<dynamic> builder,
  ) => PgModifierBuilder(builder.csv());
}
