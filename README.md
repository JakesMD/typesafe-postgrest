# typesafe-postgrest
A dart package that enables type-safe PostgREST queries.

## ✨ Features
- [x] ⚡️ Typesafe queries
- [x] ⚡️ Custom models
- [x] ⚡️ Minimal boilerplate
- [x] ⚡️ Minimal code generation
- [x] ⚡️ Supabase integration with [`typesafe_supabase`](https://github.com/JakesMD/typesafe-supabase)

## 😉 Sneak peek
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

### Generate a tiny piece of code
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

---

# 🚀 Getting started

## 📦 Installing

Choose the package that best fits your needs and add it to your `pubspec.yaml`:

  * **`typesafe_postgrest`**: For generic PostgreSQL databases.

    ``` bash
    dart pub add typesafe_postgrest
    ```
  * **[`typesafe_supabase`](https://github.com/JakesMD/typesafe-supabase)**: An extension of `typesafe_postgrest` with features specifically tailored for Supabase.

    ``` bash
    dart pub add typesafe_supabase && dart pub add dev:typesafe_postgrest
    ```
    (Add `typesafe_postgrest` as a dev dependency to ensure the code generator is included in the build.)
    
---

## 🗄️ Defining your database tables

To leverage type-safety, you'll need to replicate your PostgreSQL table schemas within your Dart code.

### Creating the table class

You define a table by extending `PgTable` (or `SupabaseTable` for Supabase projects). The `@PgTableHere()` annotation tells the code generator to process this class.

```dart
// authors.dart

part 'authors.g.dart';

@PgTableHere() // Marks this class for code generation
class AuthorsTable extends PgTable<AuthorsTable> {
  AuthorsTable()
      : super(
          tableName: tableName,
          initialQuery: (tableName) => yourPostgresClient.from(tableName),
        );

  // Define the actual table name from your Postgres database.
  // It's static so other tables can easily reference it for joins.
  static const tableName = PgTableName<AuthorsTable>('authors');
}
```

#### For Supabase users:

`SupabaseTable` simplifies the setup by taking your Supabase client and primary key(s):

```dart
// authors.dart

part 'authors.g.dart';

@PgTableHere()
class AuthorsTable extends SupabaseTable<AuthorsTable> {
  AuthorsTable(super.client) : super(tableName: tableName, primaryKey: [id]);

  static const tableName = PgTableName<AuthorsTable>('authors');
}
```

### Adding columns

Representing your table columns is straightforward. Each column gets a static final field in your table class:

```dart
class AuthorsTable extends PgTable<AuthorsTable> {
  // ... existing code ...

  static final name = PgStringColumn<AuthorsTable>('name');
}
```

For columns with a default value in your PostgreSQL database, simply add the `@PgColumnHasDefault()` annotation:

```dart
class AuthorsTable extends PgTable<AuthorsTable> {
  // ... existing code ...

  @PgColumnHasDefault()
  static final id = PgBigIntColumn<AuthorsTable>('id');
}
```

#### Built-in column types

`typesafe_postgrest` provides a wide range of common column types out of the box, handling nullability automatically:

  * `PgBigIntColumn` (`BigInt`)
  * `PgMaybeBigIntColumn` (`BigInt?`)
  * `PgStringColumn` (`String`)
  * `PgMaybeStringColumn` (`String?`)
  * ...and many more for various data types like booleans, dates, numbers, and JSON.

#### Custom column types

If you have a custom data type (e.g., an enum) that isn't covered by the built-in types, you can define your own `PgColumn` and provide `fromJson` and `toJson` methods for serialization:

```dart
class AuthorsTable extends PgTable<AuthorsTable> {
  // ... existing code ...

  static final fame = PgColumn<AuthorsTable, FameEnum, String>(
    'fame',
    fromJson: FameEnum.parse,
    toJson: (value) => value.name,
  );
}
```

### Defining table joins

Relational databases thrive on relationships, and `typesafe_postgrest` makes it easy to define joins between your tables.

  * **Many-to-Many or One-to-Many Joins**: Use `PgJoinToMany`.

    ```dart
    class AuthorsTable extends PgTable<AuthorsTable> {
      // ... existing code ...

      static final books = PgJoinToMany<AuthorsTable, BooksTable>(
        joinColumn: id, // The column in AuthorsTable that links to BooksTable
        joinedTableName: BooksTable.tableName,
      );
    }
    ```

  * **One-to-One or Many-to-One Joins**: Use `PgJoinToOne`.

In some cases, especially with complex relationships, you might need to explicitly specify the foreign key:

```dart
class AuthorsTable extends PgTable<AuthorsTable> {
  // ... existing code ...

  static final books = PgJoinToMany<AuthorsTable, BooksTable>(
    joinColumn: id,
    joinedTableName: BooksTable.tableName,
    foreignKey: 'books_author_id_fkey', // Explicitly define the foreign key name
  );
}
```

---

## 📄 Defining your data models

While your table definitions map directly to your database schema, you often don't need every column for every operation. **Models** allow you to define subsets of columns, ensuring you only fetch and work with the data you need.

### Creating a model class

Extend `PgModel` and annotate it with `@PgModelHere()`:

```dart
// author.dart

part 'author.g.dart';

@PgModelHere()
class Author extends PgModel<AuthorsTable> {
  Author(super.json) : super(builder: builder);

  static final builder = PgModelBuilder<AuthorsTable, Author>(
    constructor: Author.new,
    columns: [
      AuthorsTable.id,
      AuthorsTable.name,
    ],
  );
}
```

### Including joined models

For joined relationships, you can even include models within models, creating rich data structures:

```dart
class AuthorWithBooks extends PgModel<AuthorsTable> {
  AuthorWithBooks(super.json) : super(builder: builder);

  static final builder = PgModelBuilder<AuthorsTable, AuthorWithBooks>(
    constructor: AuthorWithBooks.new,
    columns: [
      AuthorsTable.name,
      // Include the 'books' join, specifying the model builder for the joined books
      AuthorsTable.books(AuthorBook.builder),
    ],
  );
}

// Define AuthorBook as a separate model for the 'books' table in a separate file.
@PgModelHere()
class AuthorBook extends PgModel<BooksTable> {
  AuthorBook(super.json) : super(builder: builder);

  static final builder = PgModelBuilder<BooksTable, AuthorBook>(
    constructor: AuthorBook.new,
    columns: [BooksTable.id, BooksTable.title],
  );
}
```

---

## ⚙️ Generating the helpers

Once you've defined your `PgTable` and `PgModel` classes, you need to run the code generator to create the necessary extensions and helper classes.

### Add the `part` directive

For each file where you've defined a table or model (e.g., `authors_table.dart`, `author_model.dart`), you **must** add the `part` directive at the top. This tells the Dart build system where to generate the companion code. The generated file name typically follows the pattern `your_file_name.g.dart`.

For example, if your table definition is in `authors_table.dart` and your model is in `author_model.dart`:

```dart
// authors_table.dart

import 'package:typesafe_postgrest/typesafe_postgrest.dart';
part 'authors_table.g.dart'; // <--- Add this line
```
```dart
// author_model.dart

import 'package:typesafe_postgrest/typesafe_postgrest.dart';
part 'author_model.g.dart'; // <--- Add this line
```

### Run the code generator

Execute the following command in your project's root directory:

``` bash
dart run build_runner build
```

This command triggers the code generation process. You should see new files created (e.g., `authors_table.g.dart`, `author_model.g.dart`) in the same directories as your original files.

---

## 🔍 Querying your data

`typesafe_postgrest` and `typesafe_supabase` provide a comprehensive and type-safe API for interacting with your database. You can perform all standard CRUD (Create, Read, Update, Delete) operations, along with powerful filtering and modification options.

All query operations are performed directly on your **table classes** (e.g., `authorsTable`).

### Fetching data (read operations)

Fetching data is at the core of any application. You have several options for retrieving records:

  * **`fetch()`**: The most flexible method, allowing you to fetch raw data (e.g., CSV, JSON) or specific columns.

    ```dart
    // Fetch author names as a CSV string
    String csv = await authorsTable.fetch(
      columns: [AuthorsTable.name],
      modifier: authorsTable.asCSV(), // Returns data in CSV format
    );

    // Fetch raw JSON for specific columns
    List<Map<String, dynamic>> rawData = await authorsTable.fetch(
      columns: [AuthorsTable.id, AuthorsTable.name],
    );
    ```

  * **`fetchModels()`**: Retrieves a list of records mapped directly to your defined `PgModel` classes, ensuring type safety.

    ```dart
    // Fetch a list of Author models
    List<Author> authors = await authorsTable.fetchModels(
      modelBuilder: Author.builder, // Uses the model's builder to construct objects
    );
    ```

  * **`fetchModel()`**: Fetches a single record and maps it to your `PgModel`. It will throw an error if no records are found.

    ```dart
    // Fetch a single Author model
    Author author = await authorsTable.fetchModel(modelBuilder: Author.builder);
    ```

  * **`maybeFetchModel()`**: Similar to `fetchModel()`, but returns `null` if no record is found, making it safer for potentially absent data.

    ```dart
    // Fetch a single Author model, returns null if not found
    Author? author = await authorsTable.maybeFetchModel(
      modelBuilder: Author.builder,
    );
    ```

  * **`fetchValues()`**: Retrieves a list of values from a single column, ensuring type safety.

    ```dart
    // Fetch a list of author names
    List<String> names = await authorsTable.fetchValues(
      column: AuthorsTable.name,
    );
    ```

  * **`fetchValue()`**: Fetches a single value from a single column. It will throw an error if no records are found.

    ```dart
    // Fetch a single author name
    String name = await authorsTable.fetchValue(column: AuthorsTable.name);
    ```

  * **`maybeFetchValue()`**: Similar to `fetchValue()`, but returns `null` if no record is found, making it safer for potentially absent data.

    ```dart
    // Fetch a single author name, returns null if not found
    String? name = await authorsTable.maybeFetchValue(column: AuthorsTable.name);
    ```
    

### Applying filters

Filtering allows you to retrieve specific subsets of data based on various conditions. Filters are typically applied using column methods like `equals()`, `greater()`, `less()`, etc.

```dart
// Fetch an author by ID
Author author = await authorsTable.fetchModel(
  modelBuilder: Author.builder,
  filter: AuthorsTable.id.equals(BigInt.from(1)), // Filters where 'id' column equals 1
);

// Combine multiple filters using `and()` for more complex conditions
List<Book> books = await booksTable.fetchModels(
  modelBuilder: Book.builder,
  filter: booksTable
      .where(BooksTable.pages.greater(300)) // Books with more than 300 pages
      .and(BooksTable.authorID.equals(BigInt.one)), // And author ID is 1
);

// Filter by a column on a joined table (e.g., fetch books by author's name)
List<Book> booksByAuthorName = await booksTable.fetchModels(
  modelBuilder: Book.builder,
  filter: BooksTable.author.column(AuthorsTable.name).equals('Michael Bond'),
);
```

### Applying modifiers

Modifiers allow you to control how your data is returned, such as ordering, limiting, or even changing the output format.

```dart
// Order authors by name and limit to 20 results
List<Author> authors = await authorsTable.fetchModels(
  modelBuilder: Author.builder,
  modifier: authorsTable.order(AuthorsTable.name).limit(20),
);

// Return data as CSV
String csv = await authorsTable.fetch(
  columns: [AuthorsTable.name],
  modifier: authorsTable.asCSV(),
);
```

### Inserting data (create operations)

To insert new records, you use the generated "PgInsert" classes (e.g., `AuthorsTableInsert`). These classes ensure you provide all required data for your table.

```dart
// Insert multiple authors at once
await authorsTable.insert<void>(
  inserts: [
    AuthorsTableInsert(name: 'C.S. Lewis'),
    AuthorsTableInsert(name: 'J.R.R. Tolkien'),
  ],
);

// Insert a record and immediately fetch the newly inserted model
Author insertedAuthor = await authorsTable.insertAndFetchModel(
  inserts: [AuthorsTableInsert(name: 'Willard Price')],
  modelBuilder: Author.builder,
);

// insertAndFetchValues, insertAndFetchValue, insertAndMaybeFetchValue,
// insertAndFetchModels and insertAndMaybeFetchModel also exist.
```

#### Handling nullable columns

For columns that are nullable in your database but you explicitly want to set to `null`, wrap the value with `PgNullable(null)`:

```dart
BooksTableInsert(
  title: 'Paddington Here and Now',
  authorID: BigInt.one,
  pages: const PgNullable(null), // Explicitly sets 'pages' to NULL in the database
);
```

### Upserting data

**Upsert** is a powerful operation that either `INSERTs` a new row or `UPDATEs` an existing row if a conflict occurs (typically on a primary key or unique constraint). Use the generated "PgUpsert" classes (e.g., `AuthorsTableUpsert`).

```dart
// If an author with id=1 exists, their name will be updated.
// Otherwise, a new author with id=1 and the given name will be inserted.
await authorsTable.upsert<void>(
  upserts: [AuthorsTableUpsert(id: BigInt.one, name: 'Willard Price')],
);

// upsertAndFetchValues, upsertAndFetchValue, upsertAndMaybeFetchValue,
// upsertAndFetchModels, upsertAndFetchModel and upsertAndMaybeFetchModel also exist.
```

### Updating data

Update existing records by specifying the new values and a `filter` to select which rows to update.

```dart
// Update the 'name' of the author where the current name is 'Michael Bond'
await authorsTable.update<void>(
  values: [AuthorsTable.name('Mike Bond')], // The new value for the 'name' column
  filter: AuthorsTable.name.equals('Michael Bond'), // Selects rows to update
);

// updateAndFetchValues, updateAndFetchValue, updateAndMaybeFetchValue,
// updateAndFetchModels, updateAndFetchModel and updateAndMaybeFetchModel also exist.
```

### Deleting data

Delete records by providing a `filter` to specify which rows to remove from the table.

```dart
// Delete the author where the name is 'Michael Bond'
await authorsTable.delete<void>(
  filter: AuthorsTable.name.equals('Michael Bond'),
);

// deleteAndFetchValues, deleteAndFetchValue, deleteAndMaybeFetchValue,
// deleteAndFetchModels, deleteAndFetchModel and deleteAndMaybeFetchModel also exist.
```

### Streaming data (Supabase only)

For Supabase users, `typesafe_supabase` offers real-time streaming capabilities, allowing you to listen for changes in your database.

```dart
// Stream raw JSON data for books with more than 300 pages, ordered by title
Stream<List<Map<String, dynamic>>> jsonStream = booksTable.stream(
  filter: BooksTable.pages.streamGreater(300), // Real-time filter
  modifier: booksTable.orderStream(BooksTable.title) // Real-time ordering
);

// Stream individual Book models for a specific title
Stream<Book> bookStream = booksTable.streamModel(
  modelBuilder: Book.builder,
  filter: BooksTable.title.streamEquals('All about Paddington'), // Real-time filter
);
```

---

# 👋 Contributing

All contributions to `typesafe_postgrest` and `typesafe_supabase` are welcome! 

Adding filters, modifiers and column types is a piece of cake. So please don't hesitate to open an issue or PR.
