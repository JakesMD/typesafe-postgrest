import 'package:example/tables/books_table.dart';
import 'package:typesafe_postgrest/typesafe_postgrest.dart';
import 'package:typesafe_supabase/typesafe_supabase.dart';

part 'authors_table.g.dart';

@PgTableHere()
class AuthorsTable extends SupabaseTable<AuthorsTable> {
  AuthorsTable(super.client) : super(tableName: tableName, primaryKey: [id]);

  static const tableName = PgTableName<AuthorsTable>('authors');

  /// The ID of the author.
  @PgColumnHasDefault()
  static final id = PgBigIntColumn<AuthorsTable>('id');

  /// The name of the author.
  static final name = PgStringColumn<AuthorsTable>('name');

  /// The books written by the author.
  static final books = PgJoinToMany<AuthorsTable, BooksTable>(
    id,
    BooksTable.tableName,
  );
}
