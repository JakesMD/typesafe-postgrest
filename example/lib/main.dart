import 'dart:io';

import 'package:example/author_models/author.dart';
import 'package:example/book_models/book.dart';
import 'package:example/secrets.dart';
import 'package:example/tables/authors_table.dart';
import 'package:example/tables/books_table.dart';
import 'package:supabase/supabase.dart';
import 'package:typesafe_postgrest/typesafe_postgrest.dart';

void main() async {
  final supabaseClient = SupabaseClient(
    SUPABASE_PROJECT_URL,
    SUPABASE_ANON_KEY,
  );
  final booksTable = BooksTable(supabaseClient: supabaseClient);
  final authorsTable = AuthorsTable(supabaseClient: supabaseClient);

  final book = await booksTable.fetch(
    columns: Book.builder.columns,
    filter: BooksTable.title.equals(''),
    modifier: booksTable.limit(1).single().asModel(Book.new),
  );

  print(book.authors);

  final author = await authorsTable.fetch(
    columns: Author.builder.columns,
    filter: AuthorsTable.name.equals(''),
    modifier: authorsTable.limit(1).single().asModel(Author.new),
  );

  print(author.books);

  exit(0);
}
