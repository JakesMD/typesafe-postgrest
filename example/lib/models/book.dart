import 'package:example/models/_models.dart';
import 'package:example/tables/books_table.dart';
import 'package:typesafe_postgrest/typesafe_postgrest.dart';

class Book extends PgModel<BooksTable> {
  Book(super.json) : super(builder: builder);

  static final builder = PgModelBuilder<BooksTable, Book>(
    constructor: Book.new,
    columns: [
      BooksTable.id,
      BooksTable.title,
      BooksTable.pages,
      BooksTable.author(BookAuthor.builder),
    ],
  );
}
