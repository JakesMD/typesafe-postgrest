part of 'author_book.dart';

extension PgBookX on AuthorBook {
  BigInt get id => value(BooksTable.id);
  String get title => value(BooksTable.title);
  int? get pages => value(BooksTable.pages);
}

class BookUpsert extends PgUpsert<BooksTable> {
  BookUpsert({
    required String title,
    BigInt? id,
    int? pages,
  }) : super([
         BooksTable.title.apply(title),
         if (id != null) BooksTable.id.apply(id),
         if (pages != null) BooksTable.pages.apply(pages),
       ]);
}
