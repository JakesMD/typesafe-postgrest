import 'package:example/tables/authors_table.dart';
import 'package:supabase/supabase.dart';
import 'package:typesafe_postgrest/typesafe_postgrest.dart';

class BooksTable extends PgTable<BooksTable> {
  BooksTable({required SupabaseClient supabaseClient})
    : super(
        tableName: tableName,
        primaryKeys: [title],
        initialQuery: supabaseClient.from,
      );

  static const tableName = PgTableName<BooksTable>('books');

  static final id = PgBigIntColumn<BooksTable>('id');
  static final title = PgStringColumn<BooksTable>('title');
  static final authorID = PgBigIntColumn<BooksTable>('author_id');
  static final pages = PgOptionalIntColumn<BooksTable>('pages');

  static final author = PgJoinToOne<BooksTable, AuthorsTable>(
    BooksTable.authorID,
    AuthorsTable.tableName,
  );
}
