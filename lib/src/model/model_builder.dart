import 'package:typesafe_postgrest/typesafe_postgrest.dart';

/// {@template typesafe_postgrest.PgModelBuilder}
///
/// A helper class that contains all the necessary information to construct a
/// custom [PgModel] of type [ModelType] from JSON.
///
/// [TableType] is used to provide type safety. Objects that require a builder
/// will only allow builders of the provided [TableType]. Also, the builder will
/// only allow columns and constructors of the provided [TableType].
///
/// At first glance, it may seem like [ModelType] is redundant and could be
/// swapped for [PgModel<TableType>]. However, [PgJoinToMany.call] needs it to
/// create a list of the correct type.
///
/// {@endtemplate}
class PgModelBuilder<TableType, ModelType extends PgModel<TableType>> {
  /// {@macro typesafe_postgrest.PgModelBuilder}
  const PgModelBuilder({required this.constructor, required this.columns});

  /// The constructor function that creates a new instance of [ModelType] from
  /// a [PgJsonMap].
  final ModelType Function(PgJsonMap?, PgValuesList<TableType>?) constructor;

  /// The list of columns that are part of the model.
  final PgQueryColumnList<TableType> columns;
}
