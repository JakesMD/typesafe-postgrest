import 'package:example/tables/authors_table.dart';
import 'package:typesafe_postgrest/typesafe_postgrest.dart';

part 'book_author.g.dart';

@PgModelHere()
class BookAuthor extends PgModel<AuthorsTable> {
  BookAuthor(super.json) : super(builder: builder);

  static final builder = PgModelBuilder<AuthorsTable, BookAuthor>(
    constructor: BookAuthor.new,
    columns: [AuthorsTable.id, AuthorsTable.name],
  );
}
