import 'package:postgrest/postgrest.dart';
import 'package:typesafe_postgrest/typesafe_postgrest.dart';

class PgOrderModifier<TableType>
    extends PgModifier<TableType, PostgrestList, PostgrestList, dynamic> {
  const PgOrderModifier(
    super.previousModifier,
    this.column,
    this.ascending,
    this.nullsFirst,
  );

  final PgColumn<TableType, dynamic, dynamic> column;

  final bool ascending;

  final bool nullsFirst;

  @override
  PgModifierBuilder<PostgrestList> build(
    PostgrestTransformBuilder<PostgrestList> builder,
  ) => PgModifierBuilder(
    builder.order(column.name, ascending: ascending, nullsFirst: nullsFirst),
  );
}
