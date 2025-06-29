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
/// {@endtemplate}
class PgJoinToOne<TableType, JoinedTableType>
    extends PgJoin<TableType, JoinedTableType> {
  ///  {@macro typesafe_postgrest.PgJoinToOne}
  const PgJoinToOne({
    required super.joinColumn,
    required super.joinedTableName,
    super.foreignKey,
  });

  @override
  PgQueryColumn<TableType, ModelType, PgJsonMap>
  call<ModelType extends PgModel<JoinedTableType>>(
    PgModelBuilder<JoinedTableType, ModelType> builder,
  ) => PgColumn<TableType, ModelType, PgJsonMap>.withPatterns(
    joinedTableName.name,
    queryPattern: generateQueryPattern(builder.columns, true),
    filterPattern: joinColumn.filterPattern,
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
/// {@endtemplate}
class PgMaybeJoinToOne<TableType, JoinedTableType>
    extends PgJoin<TableType, JoinedTableType> {
  /// {@macro typesafe_postgrest.PgMaybeJoinToOne}
  PgMaybeJoinToOne({
    required super.joinColumn,
    required super.joinedTableName,
    super.foreignKey,
  });

  @override
  PgQueryColumn<TableType, ModelType?, PgJsonMap?>
  call<ModelType extends PgModel<JoinedTableType>>(
    PgModelBuilder<JoinedTableType, ModelType> builder,
  ) => PgColumn<TableType, ModelType?, PgJsonMap?>.withPatterns(
    joinedTableName.name,
    queryPattern: generateQueryPattern(builder.columns, true),
    filterPattern: joinColumn.filterPattern,
    fromJson: (json) => json != null ? builder.constructor(json) : null,
    toJson: (_) => {},
  );
}
