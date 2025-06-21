// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book.dart';

// **************************************************************************
// PgModelXGenerator
// **************************************************************************

// The generator is not capable of fetching the documentation comments for some
// reason.
// ignore_for_file: public_member_api_docs

extension PgBookX on Book {
  BigInt get id => value(BooksTable.id);
  String get title => value(BooksTable.title);
  int? get pages => value(BooksTable.pages);
  BookAuthor get author => value(BooksTable.author(BookAuthor.builder));
}
