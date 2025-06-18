import 'package:postgrest/postgrest.dart';
import 'package:typesafe_postgrest/typesafe_postgrest.dart';

class PgNoneModifier<TableType>
    extends PgModifier<TableType, void, void, dynamic> {
  const PgNoneModifier(super.previousModifier);

  @override
  PgModifierBuilder<void> build(
    PostgrestTransformBuilder<void> builder,
  ) => PgModifierBuilder(builder);
}
