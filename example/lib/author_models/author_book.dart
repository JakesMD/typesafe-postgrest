import 'package:example/tables/books_table.dart';
import 'package:typesafe_postgrest/typesafe_postgrest.dart';

part 'author_book.g.dart';

class AuthorBook extends PgModel<BooksTable> {
  AuthorBook(super.json) : super(builder: builder);

  static final builder = PgModelBuilder<BooksTable, AuthorBook>(
    constructor: AuthorBook.new,
    columns: [
      BooksTable.id,
      BooksTable.title,
      BooksTable.pages,
    ],
  );
}
