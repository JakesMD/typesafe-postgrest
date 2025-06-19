import 'package:meta/meta.dart';
import 'package:postgrest/postgrest.dart';
import 'package:typesafe_postgrest/typesafe_postgrest.dart';

/// Provided methods on a [PostgrestTransformBuilder] in order to apply custom
/// modifiers.
extension PgPostgrestTransformBuilderX
    on PostgrestTransformBuilder<PgJsonList> {
  /// Applies the provided [PgModifier] to the transform builder.
  @internal
  PostgrestBuilder<dynamic, dynamic, dynamic>
  applyPgModifier<TableType, CurrentType, PreviousType>(
    PgModifier<TableType, CurrentType, PreviousType> modifier,
  ) {
    final modifiers = <PgModifier<TableType, dynamic, dynamic>>[];

    PgModifier<TableType, dynamic, dynamic>? current = modifier;

    while (current != null) {
      modifiers.insert(0, current);
      current = current.previousModifier;
    }

    return modifiers.fold<PostgrestBuilder<dynamic, dynamic, dynamic>>(
      this,
      (prev, modifier) =>
          modifier.build(prev as PostgrestTransformBuilder).builder,
    );
  }
}
