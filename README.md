# typesafe-postgrest

> 🚧 **WIP!** This package is still under development. The example below is what the API currently looks like.

- [x] ⚡️ Typesafe queries
- [x] ⚡️ Foolproof filters
- [x] ⚡️ Foolproof modifiers
- [x] ⚡️ Custom models
- [x] ⚡️ Zero boilerplate
- [x] ⚡️ Optional code generation


Just provide your table:
``` dart
class AuthorsTable extends SupabaseTable<AuthorsTable> {
  AuthorsTable(super.client) : super(tableName: tableName, primaryKey: [id]);

  static const tableName = PgTableName<AuthorsTable>('authors');
  static final id = PgBigIntColumn<AuthorsTable>('id');
  static final name = PgStringColumn<AuthorsTable>('name');
  static final books = PgJoinToMany<AuthorsTable, BooksTable>(
    id,
    BooksTable.tableName
  );
}

```

Create your custom models using any of the columns in the table:
``` dart
class Author extends PgModel<AuthorsTable> {
  Author(super.json) : super(builder: builder);

  static final builder = PgModelBuilder<AuthorsTable, Author>(
    constructor: Author.new,
    columns: [
      AuthorsTable.id,
      AuthorsTable.name,
      AuthorsTable.books(AuthorBook.builder),
    ],
  );
}
```

Generate a tiny amount of code (you can even just write it yourself):
``` shell
dart run build_runner build
```

And fetch your data:
``` dart
final authorsTable = AuthorsTable(supabaseClient);

final author = await authorsTable.fetch(
  columns: Author.builder.columns,
  filter: AuthorsTable.name.equals('Michael Bond'),
  modifier: authorsTable.limit(1).single().asModel(Author.new),
);

print(author.books);
```
