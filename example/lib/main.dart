import 'dart:io';

import 'package:example/models/_models.dart';
import 'package:example/secrets.dart';
import 'package:example/tables/authors_table.dart';
import 'package:example/tables/books_table.dart';
import 'package:supabase/supabase.dart';
import 'package:typesafe_supabase/typesafe_supabase.dart';

void main() async {
  final supabaseClient = SupabaseClient(
    SUPABASE_PROJECT_URL,
    SUPABASE_ANON_KEY,
  );
  final booksTable = BooksTable(supabaseClient);
  final authorsTable = AuthorsTable(supabaseClient);

  final books = await booksTable.fetchModels(
    modelBuilder: Book.builder,
    filter: BooksTable.title.equals('All About Paddington'),
    modifier: booksTable.asRaw(),
  );

  print(books);

  final author = await authorsTable.fetchModel(
    modelBuilder: Author.builder,
    modifier: authorsTable.limit(1).single(),
  );

  print(author.books);

  await booksTable.insert<void>(
    inserts: [
      BooksTableInsert(
        title: 'Hello',
        authorID: BigInt.one,
        pages: const PgNullable(500),
      ),
    ],
  );

  exit(0);
}
