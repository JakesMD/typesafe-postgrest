import 'package:typesafe_postgrest/typesafe_postgrest.dart';

/// Provides methods to start the filter chain.
extension PgTableFilterX<TableType> on PgTable<TableType> {
  /// Starts the filter chain in a more readable way.
  PgFilter<TableType> where(PgFilter<TableType> filter) => filter;
}
