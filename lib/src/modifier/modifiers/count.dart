import 'package:meta/meta.dart';
import 'package:postgrest/postgrest.dart';
import 'package:typesafe_postgrest/typesafe_postgrest.dart';

/// {@template typesafe_postgrest.PgCountModifier}
///
/// Counts the number of records in the response.
///
/// Performs the count additionally to the select query.
///
/// It's used to retrieve the total number of rows that satisfy the query. The
/// value for count respects any filters, but ignores modifiers
/// (e.g. limit, range).
///
/// This changes the return type from the data only to a [PostgrestResponse]
/// with the data and the count.
///
/// {@endtemplate}
class PgCountModifier<TableType>
    extends PgModifier<TableType, PostgrestResponse<PgJsonList>, PgJsonList> {
  /// {@macro typesafe_postgrest.PgCountModifier}
  @internal
  const PgCountModifier(super.previousModifier, this.option);

  /// The count option to use.
  final CountOption option;

  @override
  @internal
  ResponsePostgrestBuilder<
    PostgrestResponse<PgJsonList>,
    PgJsonList,
    PgJsonList
  >
  build(PostgrestTransformBuilder<PgJsonList> builder) => builder.count(option);
}
