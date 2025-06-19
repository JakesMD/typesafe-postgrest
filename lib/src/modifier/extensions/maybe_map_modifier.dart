import 'package:typesafe_postgrest/typesafe_postgrest.dart';

/// Provides modifiers that can be chained onto a nullable map modifier.
///
/// Notice that `maybeAsModel` is missing. This is so that the user is forced to
/// use [PgTable.maybeFetchModel].
extension PgMaybeMapModifierX<TableType>
    on PgModifier<TableType, PgJsonMap?, dynamic> {
  /// {@macro typesafe_postgrest.PgAsCSVModifier}
  PgAsCSVModifier<TableType> asCSV() => PgAsCSVModifier(this);
}
