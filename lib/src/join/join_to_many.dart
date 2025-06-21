import 'package:typesafe_postgrest/typesafe_postgrest.dart';

/// {@template typesafe_postgrest.PgJoinToMany}
///
/// Represents a one-to-many or many-to-many join in a table.
///
/// The value type of the generated column will be a list of custom [PgModel]s.
///
/// For a many-to-one join or one-to-one join, use [PgJoinToOne].
///
/// It generates the fancy query pattern and handles the conversion from
/// JSON to a custom [PgModel] for you.
///
/// {@endtemplate}
class PgJoinToMany<TableType, JoinedTableType>
    extends PgJoin<TableType, JoinedTableType> {
  /// {@macro typesafe_postgrest.PgJoinToMany}
  PgJoinToMany(super.joinColumn, super.joinedTableName, {super.foreignKey});

  @override
  PgQueryColumn<TableType, List<ModelType>, PgJsonList>
  call<ModelType extends PgModel<JoinedTableType>>(
    PgModelBuilder<JoinedTableType, ModelType> builder,
  ) => PgColumn<TableType, List<ModelType>, PgJsonList>.withPatterns(
    joinedTableName.name,
    queryPattern: generateQueryPattern(builder.columns, false),
    filterPattern: joinColumn.filterPattern,
    fromJson: (list) => list.map((json) => builder.constructor(json)).toList(),
    toJson: (_) => [],
  );
}
