import 'package:meta/meta.dart';
import 'package:postgrest/postgrest.dart';

export 'extensions/_extensions.dart';
export 'extensions/postgrest_transform_builder.dart';
export 'modifiers/_modifiers.dart';

/// {@template typesafe_postgrest.PgModifier}
///
/// Represents a modifier that can be applied to a postgrest query.
///
/// Filters work on the row level. That is, they allow you to return rows that
/// only match certain conditions without changing the shape of the rows.
/// Modifiers are everything that don't fit that definition—allowing you to
/// change the format of the response (e.g., returning a CSV string).
///
/// [TableType] is used to provide type safety for the modifier. Modifiers that
/// require a column will only allow columns of the provided [TableType].
///
/// [CurrentType] defines the output type of the modifier. Only modifiers that
/// accept this type as a [PreviousType] can be added to the chain. If this is
/// the last modifier in the chain, it will be the output type of the query. In
/// this case, make sure that the response is converted to [CurrentType]
/// correctly by PgTable.
///
/// {@endtemplate}
class PgModifier<TableType, CurrentType, PreviousType> {
  /// {@macro typesafe_postgrest.PgModifier}
  @internal
  const PgModifier(this.previousModifier);

  /// The modifier that was applied before this one.
  final PgModifier<TableType, PreviousType, dynamic>? previousModifier;

  /// Cascades the modifier onto the provided [builder].
  @mustBeOverridden
  @internal
  PostgrestBuilder<CurrentType, dynamic, dynamic> build(
    PostgrestTransformBuilder<PreviousType> builder,
  ) => throw UnimplementedError();
}
