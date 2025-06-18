import 'package:postgrest/postgrest.dart';
import 'package:typesafe_postgrest/typesafe_postgrest.dart';

class PgLimitModifier<TableType>
    extends PgModifier<TableType, PostgrestList, PostgrestList, dynamic> {
  const PgLimitModifier(super.previousModifier, this.count);

  final int count;

  @override
  PgModifierBuilder<PostgrestList> build(
    PostgrestTransformBuilder<PostgrestList> builder,
  ) => PgModifierBuilder(builder.limit(count));
}
