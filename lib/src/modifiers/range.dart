import 'package:postgrest/postgrest.dart';
import 'package:typesafe_postgrest/typesafe_postgrest.dart';

class PgRangeModifier<TableType>
    extends PgModifier<TableType, PostgrestList, PostgrestList, dynamic> {
  const PgRangeModifier(super.previousModifier, this.from, this.to);

  final int from;

  final int to;

  @override
  PgModifierBuilder<PostgrestList> build(
    PostgrestTransformBuilder<PostgrestList> builder,
  ) => PgModifierBuilder(builder.range(from, to));
}
