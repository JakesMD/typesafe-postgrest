# typesafe-postgrest

> 🚧 **WIP!** This package is still under development. The example below is what the API currently looks like.

- [x] ⚡️ Typesafe queries
- [x] ⚡️ Foolproof filters
- [x] ⚡️ Foolproof modifiers
- [x] ⚡️ Custom models
- [x] ⚡️ Zero boilerplate
- [x] ⚡️ Optional code generation


### Define your tables
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

### Define your models
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

### Generate a few lines of code
Run the following command:
``` shell
dart run build_runner build
```

<details>
<summary>(Toggle to view the generated code)</summary>

``` dart
extension PgAuthorX on Author {
  BigInt get id => value(AuthorsTable.id);
  String get name => value(AuthorsTable.name);
  List<AuthorBook> get books => value(AuthorsTable.books(AuthorBook.builder));
}
```
``` dart
typedef AuthorsTableInsert = AuthorsTableUpsert;

class AuthorsTableUpsert extends PgUpsert<AuthorsTable> {
  AuthorsTableUpsert({required String name, BigInt? id})
    : super([AuthorsTable.name(name), if (id != null) AuthorsTable.id(id)]);
}
```
---

</details>

### Use it!
``` dart
final authorsTable = AuthorsTable(supabaseClient);

final author = await authorsTable.fetchModel(
  modelBuilder: Author.builder,
  filter: AuthorsTable.name.equals('Michael Bond'),
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