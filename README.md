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
@PgTableHere()
class AuthorsTable extends SupabaseTable<AuthorsTable> {
  AuthorsTable(super.client) : super(tableName: tableName, primaryKey: [id]);

  static const tableName = PgTableName<AuthorsTable>('authors');

  @PgColumnHasDefault()
  static final id = PgBigIntColumn<AuthorsTable>('id');

  static final name = PgStringColumn<AuthorsTable>('name');

  static final books = PgJoinToMany<AuthorsTable, BooksTable>(
    joinColumn: id,
    joinedTableName: BooksTable.tableName,
  );
}

```

Create your custom models using any of the columns in the table:
``` dart
@PgModelHere()
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

final author = await authorsTable.fetchModel(
  modelBuilder: Author.builder,
  filter: AuthorsTable.name.equals('Michael Bond'),
  modifier: authorsTable.limit(1).single(),
);

print(author.books);
```

## Contributing
Contributions are welcome! Please open an issue or submit a pull request.

Especially looking for:
- [ ] Missing filters
- [ ] Missing modifiers
- [ ] New column types
- [ ] Documentation improvements
- [ ] Bug fixes (especially around code generation)

Adding filters, modifiers and column types is a piece of cake. So please don't hesitate to open an issue or PR.