import 'package:meta/meta.dart';
import 'package:postgrest/postgrest.dart';
import 'package:typesafe_postgrest/typesafe_postgrest.dart';

@internal
extension PgPostgrestTransformBuilderX
    on PostgrestTransformBuilder<PgJsonList> {
  /// Applies the provided [PgModifier] to the transform builder.
  PostgrestBuilder<dynamic, dynamic, dynamic>
  applyPgModifier<TableType, CurrentType, PreviousType>(
    PgModifier<TableType, CurrentType, PreviousType>? modifier,
  ) {
    if (modifier == null) return this;

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
