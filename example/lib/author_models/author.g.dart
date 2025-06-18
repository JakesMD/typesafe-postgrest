part of 'author.dart';

extension PgAuthorX on Author {
  BigInt get id => value(AuthorsTable.id);
  String get name => value(AuthorsTable.name);
  List<AuthorBook> get books => value(AuthorsTable.books(AuthorBook.builder));
}

class AuthorUpsert extends PgUpsert<AuthorsTable> {
  AuthorUpsert({required String name, BigInt? id})
    : super([
        AuthorsTable.name.apply(name),
        if (id != null) AuthorsTable.id.apply(id),
      ]);
}
