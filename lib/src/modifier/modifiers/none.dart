import 'package:meta/meta.dart';
import 'package:postgrest/postgrest.dart';
import 'package:typesafe_postgrest/src/modifier/modifier.dart';

/// {@template typesafe_postgrest.PgNoneModifier}
///
/// A modifier that does not modify the query. Used for when no data needs to be
/// retrieved.
///
/// The output type of the query will be a void.
///
/// {@endtemplate}
class PgNoneModifier<TableType> extends PgModifier<TableType, void, void> {
  /// {@macro typesafe_postgrest.PgNoneModifier}
  @internal
  const PgNoneModifier(super.previousModifier);

  @override
  @internal
  PostgrestTransformBuilder<void> build(
    PostgrestTransformBuilder<void> builder,
  ) => builder;
}
