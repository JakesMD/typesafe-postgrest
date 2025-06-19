import 'package:typesafe_postgrest/typesafe_postgrest.dart';

/// {@template typesafe_postgrest.PgJoinToOne}
///
/// Represents a many-to-one or one-to-one join in a table.
///
/// The value type of the generated column will be a custom [PgModel].
///
/// For a one-to-many join or many-to-many join, use [PgJoinToMany].
///
/// It generates the fancy query pattern and handles the conversion from
/// JSON to a custom [PgModel] for you.
///
/// [TableType] is used to provide type safety. Objects that require a column
/// will only allow columns of the provided [TableType]. Also, the join will
/// only generate columns of the provided [TableType].
///
/// [JoinedTableType] is used to provide type safety. The join will only allow
/// builders of the provided [JoinedTableType] which matches the
/// [joinedTableName].
///
/// {@endtemplate}
class PgJoinToOne<TableType, JoinedTableType> {
  ///  {@macro typesafe_postgrest.PgJoinToOne}
  PgJoinToOne(this.joinColumn, this.joinedTableName, {this.foreignKey});

  /// The column in the current table that creates the foreign relationship with
  /// the joined table.
  final PgColumn<TableType, dynamic, dynamic> joinColumn;

  /// The name of the joined table.
  final PgTableName<JoinedTableType> joinedTableName;

  /// The foreign key to use for the join. This is only required in some cases.
  ///
  /// Generally, postgrest will throw an error if it cannot find the correct
  /// foreign key to use and gives recommendations on what foreign key to use.
  final String? foreignKey;

  /// Generates a 'fake' column with the [TableType] that handles the conversion
  /// from JSON to a custom [PgModel] of type [ModelType] for you.
  ///
  /// It also generates the fancy query pattern required to query the joined
  /// table.
  PgColumn<TableType, ModelType, PgJsonMap>
  call<ModelType extends PgModel<JoinedTableType>>(
    PgModelBuilder<JoinedTableType, ModelType> builder,
  ) => PgColumn<TableType, ModelType, PgJsonMap>.withQueryPattern(
    joinedTableName.name,
    queryPattern:
        '''${joinedTableName.name}${foreignKey != null ? '!$foreignKey' : ':${joinColumn.name}'}(${builder.columns.map((c) => c.queryPattern).join(', ')})''',
    fromJson: (json) => builder.constructor(json),
    toJson: (_) => {},
  );
}

/// {@template typesafe_postgrest.PgMaybeJoinToOne}
///
/// Represents a many-to-one or one-to-one join in a table that could be null.
///
/// The value type of the generated column will be a custom [PgModel] or null.
///
/// For a one-to-many join or many-to-many join, use [PgJoinToMany].
///
/// It generates the fancy query pattern and handles the conversion from
/// JSON to a custom [PgModel] for you.
///
/// [TableType] is used to provide type safety. Objects that require a column
/// will only allow columns of the provided [TableType]. Also, the join will
/// only generate columns of the provided [TableType].
///
/// [JoinedTableType] is used to provide type safety. The join will only allow
/// builders of the provided [JoinedTableType] which matches the
/// [joinedTableName].
///
/// {@endtemplate}
class PgMaybeJoinToOne<TableType, JoinedTableType> {
  /// {@macro typesafe_postgrest.PgMaybeJoinToOne}
  PgMaybeJoinToOne(this.joinColumn, this.joinedTableName, {this.foreignKey});

  /// The column in the current table that creates the foreign relationship with
  /// the joined table.
  final PgColumn<TableType, dynamic, dynamic> joinColumn;

  /// The name of the joined table.
  final PgTableName<JoinedTableType> joinedTableName;

  /// The foreign key to use for the join. This is only required in some cases.
  ///
  /// Generally, postgrest will throw an error if it cannot find the correct
  /// foreign key to use and gives recommendations on what foreign key to use.
  final String? foreignKey;

  /// Generates a 'fake' column with the [TableType] that handles the conversion
  /// from JSON to a custom [PgModel] of type [ModelType] for you.
  ///
  /// It also generates the fancy query pattern required to query the joined
  /// table.
  PgColumn<TableType, ModelType?, PgJsonMap?>
  call<ModelType extends PgModel<JoinedTableType>>(
    PgModelBuilder<JoinedTableType, ModelType> builder,
  ) => PgColumn<TableType, ModelType?, PgJsonMap?>.withQueryPattern(
    joinedTableName.name,
    queryPattern:
        '''${joinedTableName.name}${foreignKey != null ? '!$foreignKey' : ':${joinColumn.name}'}(${builder.columns.map((c) => c.queryPattern).join(', ')})''',
    fromJson: (json) => json != null ? builder.constructor(json) : null,
    toJson: (_) => {},
  );
}
