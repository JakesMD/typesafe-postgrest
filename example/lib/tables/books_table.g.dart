// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'books_table.dart';

// **************************************************************************
// PgUpsertGenerator
// **************************************************************************

// Typedefs are self-documenting.
// ignore_for_line: public_member_api_docs
typedef BooksTableInsert = BooksTableUpsert;

/// {@template BooksTableUpsert}
///
/// Represents the data required to perform an insert or upsert operation on the
/// [BooksTable] table.
///
/// {@endtemplate}
class BooksTableUpsert extends PgUpsert<BooksTable> {
  /// {@macro BooksTableUpsert}
  BooksTableUpsert({
    required String title,
    required BigInt authorID,
    PgNullable<int>? pages,
    BigInt? id,
  }) : super([
         BooksTable.title(title),
         BooksTable.authorID(authorID),
         if (pages != null) BooksTable.pages(pages.value),
         if (id != null) BooksTable.id(id),
       ]);
}
