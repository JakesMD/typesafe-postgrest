import 'package:postgrest/postgrest.dart';
import 'package:typesafe_postgrest/typesafe_postgrest.dart';

class PgJoinToMany<TableType, JoinedTableType> {
  PgJoinToMany(this.joinColumn, this.joinedTableName, {this.foreignKey});

  final PgColumn<TableType, dynamic, dynamic> joinColumn;

  final PgTableName<JoinedTableType> joinedTableName;

  final String? foreignKey;

  PgColumn<TableType, List<ModelType>, PostgrestList>
  call<ModelType extends PgModel<JoinedTableType>>(
    PgModelBuilder<JoinedTableType, ModelType> builder,
  ) => PgColumn<TableType, List<ModelType>, PostgrestList>.withQueryPattern(
    joinedTableName.name,
    queryPattern:
        '''${joinedTableName.name}${foreignKey != null ? '!$foreignKey' : ''}(${builder.columns.map((c) => c.queryPattern).join(', ')})''',
    fromJson: (list) => list.map((json) => builder.constructor(json)).toList(),
    toJson: (_) => [],
  );
}
