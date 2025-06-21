import 'package:meta/meta.dart';
import 'package:typesafe_postgrest/typesafe_postgrest.dart';

export 'join_to_many.dart';
export 'join_to_one.dart';

/// {@template typesafe_postgrest.PgJoin}
///
/// Represents a join between two tables.
///
/// [TableType] is used to provide type safety. Objects that require a join
/// will only allow joins of the provided [TableType]. Also, the join will
/// only allow columns and constructors of the provided [TableType].
///
/// [JoinedTableType] is used to provide type safety. The join will only allow
/// builders of the provided [JoinedTableType] which matches the
/// [joinedTableName].
///
/// {@endtemplate}
abstract class PgJoin<TableType, JoinedTableType> {
  /// {@macro typesafe_postgrest.PgJoin}
  const PgJoin(this.joinColumn, this.joinedTableName, {this.foreignKey});

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

  /// Generates a [PgQueryColumn] with the [TableType] that handles the
  /// conversion from JSON to a custom [PgModel] of type [ModelType] for you.
  ///
  /// It also generates the fancy query pattern required to query the joined
  /// table.
  @mustBeOverridden
  PgQueryColumn<TableType, dynamic, dynamic>
  call<ModelType extends PgModel<JoinedTableType>>(
    PgModelBuilder<JoinedTableType, ModelType> builder,
  ) => throw UnimplementedError();

  /// Passes through the provided [column] from the joined table as a
  /// [PgFilterColumn] with [TableType].
  PgFilterColumn<TableType, ValueType, JsonValueType>
  column<ValueType, JsonValueType>(
    PgColumn<JoinedTableType, ValueType, JsonValueType> column,
  ) => PgColumn.withPatterns(
    column.name,
    queryPattern: column.queryPattern,
    filterPattern: '${joinedTableName.name}.${column.name}',
    fromJson: column.fromJson,
    toJson: column.toJson,
  );

  /// Generates the fancy query pattern for the join.
  @internal
  String generateQueryPattern(
    PgQueryColumnList<JoinedTableType> columns,
    bool isToOne,
  ) {
    var foreignKeyPart = '';

    if (foreignKey != null) {
      foreignKeyPart = '!$foreignKey';
    } else if (isToOne) {
      foreignKeyPart = ':${joinColumn.name}';
    }

    final subColumnsPart = columns.map((c) => c.queryPattern).join(', ');

    return '${joinedTableName.name}$foreignKeyPart($subColumnsPart)';
  }
}
