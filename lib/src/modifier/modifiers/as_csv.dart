import 'package:meta/meta.dart';
import 'package:postgrest/postgrest.dart';
import 'package:typesafe_postgrest/src/modifier/modifier.dart';

/// {@template typesafe_postgrest.PgAsCSVModifier}
///
/// Retrieves the response as a CSV string.
///
/// {@endtemplate}
class PgAsCSVModifier<TableType>
    extends PgModifier<TableType, String, dynamic> {
  /// {@macro typesafe_postgrest.PgAsCSVModifier}
  @internal
  const PgAsCSVModifier(super.previousModifier);

  @override
  @internal
  PostgrestTransformBuilder<String> build(
    PostgrestTransformBuilder<dynamic> builder,
  ) => builder.csv();
}
