import 'package:postgrest/postgrest.dart';
import 'package:typesafe_postgrest/typesafe_postgrest.dart';

class PgCountModifier<TableType>
    extends PgModifier<TableType, int, PostgrestList, dynamic> {
  const PgCountModifier(super.previousModifier, this.option);

  final CountOption option;

  @override
  PgModifierBuilder<int> build(
    PostgrestTransformBuilder<PostgrestList> builder,
  ) => PgModifierBuilder(builder.count(option));
}
