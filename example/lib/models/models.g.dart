part of '_models.dart';

extension PgAuthorX on Author {
  BigInt get id => value(AuthorsTable.id);
  String get name => value(AuthorsTable.name);
  List<AuthorBook> get books => value(AuthorsTable.books(AuthorBook.builder));
}

class AuthorUpsert extends PgUpsert<AuthorsTable> {
  AuthorUpsert({required String name, BigInt? id})
    : super([
        AuthorsTable.name(name),
        if (id != null) AuthorsTable.id(id),
      ]);
}

extension PgAuthorBookX on AuthorBook {
  BigInt get id => value(BooksTable.id);
  String get title => value(BooksTable.title);
  int? get pages => value(BooksTable.pages);
}

class AuthorBookUpsert extends PgUpsert<BooksTable> {
  AuthorBookUpsert({
    required String title,
    BigInt? id,
    int? pages,
  }) : super([
         BooksTable.title(title),
         if (id != null) BooksTable.id(id),
         if (pages != null) BooksTable.pages(pages),
       ]);
}

extension PgBookX on Book {
  BigInt get id => value(BooksTable.id);
  String get title => value(BooksTable.title);
  int? get pages => value(BooksTable.pages);
  BookAuthor get authors => value(BooksTable.author(BookAuthor.builder));
}

class BookUpsert extends PgUpsert<BooksTable> {
  BookUpsert({
    required String title,
    BigInt? id,
    int? pages,
  }) : super([
         BooksTable.title(title),
         if (id != null) BooksTable.id(id),
         if (pages != null) BooksTable.pages(pages),
       ]);
}

extension PgBookAuthorX on BookAuthor {
  BigInt get id => value(AuthorsTable.id);
  String get name => value(AuthorsTable.name);
}

class BookAuthorUpsert extends PgUpsert<AuthorsTable> {
  BookAuthorUpsert({required String name, BigInt? id})
    : super([
        AuthorsTable.name(name),
        if (id != null) AuthorsTable.id(id),
      ]);
}
