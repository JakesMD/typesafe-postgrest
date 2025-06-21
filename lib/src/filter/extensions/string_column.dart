import 'package:postgrest/postgrest.dart';
import 'package:typesafe_postgrest/typesafe_postgrest.dart';

/// Provides filters to string filter column types.
extension PgStringFilterColumnX<TableType>
    on PgFilterColumn<TableType, dynamic, String?> {
  /// {@macro typesafe_postgrest.PgLikeFilter}
  PgFilter<TableType> like(String pattern, {bool isCaseSensitive = false}) =>
      PgLikeFilter(this, pattern, isCaseSensitive, null);

  /// {@macro typesafe_postgrest.PgTextSearchFilter}
  PgFilter<TableType> textSearch(
    String searchText, {
    String? config,
    TextSearchType? type,
  }) => PgTextSearchFilter(this, searchText, config, type, null);
}
