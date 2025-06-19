import 'package:example/tables/authors_table.dart';
import 'package:typesafe_postgrest/typesafe_postgrest.dart';
import 'package:typesafe_supabase/typesafe_supabase.dart';

class BooksTable extends SupabaseTable<BooksTable> {
  BooksTable(super.client) : super(tableName: tableName, primaryKey: [id]);

  static const tableName = PgTableName<BooksTable>('books');

  static final id = PgBigIntColumn<BooksTable>('id');
  static final title = PgStringColumn<BooksTable>('title');
  static final authorID = PgBigIntColumn<BooksTable>('author_id');
  static final pages = PgMaybeIntColumn<BooksTable>('pages');

  static final author = PgJoinToOne<BooksTable, AuthorsTable>(
    BooksTable.authorID,
    AuthorsTable.tableName,
  );
}
