import 'package:typesafe_postgrest/typesafe_postgrest.dart';

/// {@template typesafe_postgrest.PgColumnHasDefault}
///
/// An annotation that marks a column as having a default value.
///
/// This assures that the [PgUpsert] generated for the table will only include
/// the value for the column as an optional parameter.
///
/// {@endtemplate}
class PgColumnHasDefault {
  /// {@macro typesafe_postgrest.PgColumnHasDefault}
  const PgColumnHasDefault();
}
