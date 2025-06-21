import 'package:example/models/author_book.dart';
import 'package:example/tables/authors_table.dart';
import 'package:typesafe_postgrest/typesafe_postgrest.dart';

part 'author.g.dart';

@PgModelHere()
class Author extends PgModel<AuthorsTable> {
  Author(super.json) : super(builder: builder);

  static final builder = PgModelBuilder<AuthorsTable, Author>(
    constructor: Author.new,
    columns: [
      AuthorsTable.id,
      AuthorsTable.name,
      AuthorsTable.books(AuthorBook.builder),
    ],
  );
}
