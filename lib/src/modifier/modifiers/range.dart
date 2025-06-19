import 'package:meta/meta.dart';
import 'package:postgrest/postgrest.dart';
import 'package:typesafe_postgrest/src/modifier/modifier.dart';
import 'package:typesafe_postgrest/typesafe_postgrest.dart';

/// {@template typesafe_postgrest.PgRangeModifier}
///
/// Limits the result to rows within the specified range, inclusive.
///
/// `from`: The starting index from which to limit the result.
///
/// `to`: The last index to which to limit the result.
///
/// {@endtemplate}
class PgRangeModifier<TableType>
    extends PgModifier<TableType, PgJsonList, PgJsonList> {
  /// {@macro typesafe_postgrest.PgRangeModifier}
  @internal
  const PgRangeModifier(super.previousModifier, this.from, this.to);

  /// The starting index from which to limit the result.
  final int from;

  /// The last index to which to limit the result.
  final int to;

  @override
  @internal
  PgModifierBuilder<PgJsonList> build(
    PostgrestTransformBuilder<PgJsonList> builder,
  ) => PgModifierBuilder(builder.range(from, to));
}
