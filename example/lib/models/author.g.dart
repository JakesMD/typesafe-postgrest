// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'author.dart';

// **************************************************************************
// PgModelXGenerator
// **************************************************************************

// The generator is not capable of fetching the documentation comments for some
// reason.
// ignore_for_file: public_member_api_docs

extension PgAuthorX on Author {
  BigInt get id => value(AuthorsTable.id);
  String get name => value(AuthorsTable.name);
  List<AuthorBook> get books => value(AuthorsTable.books(AuthorBook.builder));
}
