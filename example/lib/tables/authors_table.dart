import 'package:example/tables/books_table.dart';
import 'package:supabase/supabase.dart';
import 'package:typesafe_postgrest/typesafe_postgrest.dart';

class AuthorsTable extends PgTable<AuthorsTable> {
  AuthorsTable({required SupabaseClient supabaseClient})
    : super(
        tableName: tableName,
        primaryKeys: [id],
        initialQuery: supabaseClient.from,
      );

  static const tableName = PgTableName<AuthorsTable>('authors');
  static final id = PgBigIntColumn<AuthorsTable>('id');
  static final name = PgStringColumn<AuthorsTable>('name');
  static final books = PgJoinToMany<AuthorsTable, BooksTable>(
    id,
    BooksTable.tableName,
  );
}
