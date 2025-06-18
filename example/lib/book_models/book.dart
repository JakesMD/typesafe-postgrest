import 'package:example/book_models/book_author.dart';
import 'package:example/tables/books_table.dart';
import 'package:typesafe_postgrest/typesafe_postgrest.dart';

part 'book.g.dart';

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
