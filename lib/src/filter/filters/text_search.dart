import 'package:meta/meta.dart';
import 'package:postgrest/postgrest.dart';
import 'package:typesafe_postgrest/typesafe_postgrest.dart';

/// {@template typesafe_postgrest.PgTextSearchFilter}
///
/// Match a string.
///
/// A filter that only matches rows where the column contains [searchText].
///
/// `searchText`: The query text to filter with.
///
/// `config`: The text search configuration to use.
///
/// `type`: Change how the query text is interpreted.
///
/// {@endtemplate}
class PgTextSearchFilter<TableType> extends PgFilter<TableType> {
  /// {@macro typesafe_postgrest.PgTextSearchFilter}
  @internal
  const PgTextSearchFilter(
    this.column,
    this.searchText,
    this.config,
    this.type,
    super.previousFilter,
  );

  /// The column to filter by.
  final PgFilterColumn<TableType, dynamic, String?> column;

  /// The query text to filter with.
  final String searchText;

  /// The text search configuration to use.
  final String? config;

  /// Change how the query text is interpreted.
  final TextSearchType? type;

  @override
  @internal
  PostgrestFilterBuilder<P> build<P>(PostgrestFilterBuilder<P> builder) =>
      builder.textSearch(
        column.filterPattern,
        column.toJson(searchText) ?? '',
        config: config,
        type: type,
      );

  @override
  PgFilter<TableType> withPreviousFilter(PgFilter<TableType> previousFilter) =>
      PgTextSearchFilter(column, searchText, config, type, previousFilter);
}
