import 'package:typesafe_postgrest/typesafe_postgrest.dart';

/// Provides filters to json filter column types.
extension PgJsonFilterColumnX<TableType>
    on PgFilterColumn<TableType, dynamic, PgJsonMap?> {
  /// {@macro typesafe_postgrest.PgContainedByJsonFilter}
  PgFilter<TableType> containedByJson(PgJsonMap value) =>
      PgContainedByJsonFilter(this, value, null);

  /// {@macro typesafe_postgrest.PgContainsJsonFilter}
  PgFilter<TableType> containsJson(PgJsonMap value) =>
      PgContainsJsonFilter(this, value, null);
}
