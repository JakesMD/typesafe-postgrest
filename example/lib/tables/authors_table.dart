import 'package:example/tables/books_table.dart';
import 'package:typesafe_postgrest/typesafe_postgrest.dart';
import 'package:typesafe_supabase/typesafe_supabase.dart';

class AuthorsTable extends SupabaseTable<AuthorsTable> {
  AuthorsTable(super.client) : super(tableName: tableName, primaryKey: [id]);

  static const tableName = PgTableName<AuthorsTable>('authors');
  static final id = PgBigIntColumn<AuthorsTable>('id');
  static final name = PgStringColumn<AuthorsTable>('name');
  static final books = PgJoinToMany<AuthorsTable, BooksTable>(
    id,
    BooksTable.tableName,
  );
}
