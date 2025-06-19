/// {@template typesafe_postgrest.PgTableName}
///
/// Represents the name of a table in the database.
///
/// [TableType] is used to provide type safety. Objects that require a table
/// name will only allow table names of the provided [TableType].
///
/// {@endtemplate}
class PgTableName<TableType> {
  /// {@macro typesafe_postgrest.PgTableName}
  const PgTableName(this.name);

  /// The name of the table.
  final String name;
}
