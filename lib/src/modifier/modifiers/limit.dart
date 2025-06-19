import 'package:meta/meta.dart';
import 'package:postgrest/postgrest.dart';
import 'package:typesafe_postgrest/src/modifier/modifier.dart';
import 'package:typesafe_postgrest/typesafe_postgrest.dart';

/// {@template typesafe_postgrest.PgLimitModifier}
///
/// Limits the result with the specified [count].
///
/// `count`: The maximum number of rows to return.
///
/// {@endtemplate}
class PgLimitModifier<TableType>
    extends PgModifier<TableType, PgJsonList, PgJsonList> {
  /// {@macro typesafe_postgrest.PgLimitModifier}
  @internal
  const PgLimitModifier(super.previousModifier, this.count);

  /// The maximum number of rows to return.
  final int count;

  @override
  @internal
  PgModifierBuilder<PgJsonList> build(
    PostgrestTransformBuilder<PgJsonList> builder,
  ) => PgModifierBuilder(builder.limit(count));
}
