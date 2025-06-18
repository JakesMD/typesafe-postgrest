part of 'book_author.dart';

extension PgAuthorX on BookAuthor {
  BigInt get id => value(AuthorsTable.id);
  String get name => value(AuthorsTable.name);
}

class AuthorUpsert extends PgUpsert<AuthorsTable> {
  AuthorUpsert({required String name, BigInt? id})
    : super([
        AuthorsTable.name.apply(name),
        if (id != null) AuthorsTable.id.apply(id),
      ]);
}
