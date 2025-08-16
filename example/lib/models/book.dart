import 'package:example/models/_models.dart';
import 'package:example/tables/books_table.dart';
import 'package:typesafe_postgrest/typesafe_postgrest.dart';

part 'book.g.dart';

@PgModelHere()
class Book extends PgModel<BooksTable> {
  Book(super.json, super.values) : super(builder: builder);

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
