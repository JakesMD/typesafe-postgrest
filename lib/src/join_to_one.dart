import 'package:postgrest/postgrest.dart';
import 'package:typesafe_postgrest/typesafe_postgrest.dart';

class PgJoinToOne<TableType, JoinedTableType> {
  PgJoinToOne(this.joinColumn, this.joinedTableName, {this.foreignKey});

  final PgColumn<TableType, dynamic, dynamic> joinColumn;

  final PgTableName<JoinedTableType> joinedTableName;

  final String? foreignKey;

  PgColumn<TableType, ModelType, PostgrestMap>
  call<ModelType extends PgModel<JoinedTableType>>(
    PgModelBuilder<JoinedTableType, ModelType> builder,
  ) => PgColumn<TableType, ModelType, PostgrestMap>.withQueryPattern(
    joinedTableName.name,
    queryPattern:
        '''${joinedTableName.name}${foreignKey != null ? '!$foreignKey' : ':${joinColumn.name}'}(${builder.columns.map((c) => c.queryPattern).join(', ')})''',
    fromJson: (json) => builder.constructor(json),
    toJson: (_) => {},
  );
}
