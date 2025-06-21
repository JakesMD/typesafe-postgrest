import 'package:meta/meta.dart';
import 'package:postgrest/postgrest.dart';
import 'package:typesafe_postgrest/typesafe_postgrest.dart';

@internal
extension PgPostgrestFilterBuilderX<T> on PostgrestFilterBuilder<T> {
  PostgrestFilterBuilder<T> applyPgFilter<TableType>(
    PgFilter<TableType>? filter,
  ) {
    if (filter == null) return this;

    final filters = <PgFilter<TableType>>[];
    PgFilter<TableType>? current = filter;

    while (current != null) {
      filters.insert(0, current);
      current = current.previousFilter;
    }

    return filters.fold(this, (prev, filter) => filter.build(prev));
  }
}
