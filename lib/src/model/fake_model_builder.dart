import 'package:typesafe_postgrest/typesafe_postgrest.dart';

/// Builds a fake [PgModel] from the given [fakeValues].
///
/// Used for testing purposes.
///
/// [PgModel]s do not require every field to be present in the json. Only
/// provide the values you need to test with.
///
/// To provide the values of a table join, use the [PgJoinToOne.fakeValues],
/// [PgMaybeJoinToOne.fakeValues] or [PgJoinToMany.fakeValues] methods.
ModelType buildFakePgModel<TableType, ModelType extends PgModel<TableType>>({
  required PgModelBuilder<TableType, ModelType> modelBuilder,
  required List<PgValue<TableType, dynamic, dynamic>> fakeValues,
}) => modelBuilder.constructor({
  for (final value in fakeValues) value.columnName: value.toJson(),
});
