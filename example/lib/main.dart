import 'dart:io';

import 'package:example/models/_models.dart';
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
  final booksTable = BooksTable(supabaseClient);
  final authorsTable = AuthorsTable(supabaseClient);

  final books = await booksTable.fetchModels(
    modelBuilder: Book.builder,
    modifier: booksTable.asRaw(),
  );

  print(books);

  final author = await authorsTable.fetchModel(
    modelBuilder: Author.builder,
    modifier: authorsTable.limit(1).single(),
  );

  print(author.books);

  exit(0);
}
