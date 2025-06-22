import 'package:example/tables/authors_table.dart';
import 'package:typesafe_postgrest/typesafe_postgrest.dart';
import 'package:typesafe_supabase/typesafe_supabase.dart';

part 'books_table.g.dart';

@PgTableHere()
class BooksTable extends SupabaseTable<BooksTable> {
  BooksTable(super.client) : super(tableName: tableName, primaryKey: [id]);

  static const tableName = PgTableName<BooksTable>('books');

  /// The ID of the book.
  @PgColumnHasDefault()
  static final id = PgBigIntColumn<BooksTable>('id');

  /// The title of the book.
  static final title = PgStringColumn<BooksTable>('title');

  /// The ID of the author of the book.
  static final authorID = PgBigIntColumn<BooksTable>('author_id');

  /// The number of pages in the book.
  static final pages = PgMaybeIntColumn<BooksTable>('pages');

  /// The author of the book.
  static final author = PgJoinToOne<BooksTable, AuthorsTable>(
    BooksTable.authorID,
    AuthorsTable.tableName,
  );
}
