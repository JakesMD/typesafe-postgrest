import 'package:typesafe_postgrest/typesafe_postgrest.dart';

/// Provides modifiers that can be chained onto a map modifier.
///
/// Notice that `asModel` is missing. This is so that the user is forced to use
/// [PgTable.fetchModel].
extension PgMapModifierX<TableType>
    on PgModifier<TableType, PgJsonMap, dynamic> {
  /// {@macro typesafe_postgrest.PgAsCSVModifier}
  PgAsCSVModifier<TableType> asCSV() => PgAsCSVModifier(this);
}
