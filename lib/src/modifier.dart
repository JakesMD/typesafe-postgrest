import 'package:meta/meta.dart';
import 'package:postgrest/postgrest.dart';
import 'package:typesafe_postgrest/typesafe_postgrest.dart';

extension PgPostgrestTransformBuilderX
    on PostgrestTransformBuilder<List<Map<String, dynamic>>> {
  PostgrestBuilder<dynamic, dynamic, dynamic>
  applyPgModifier<TableType, CurrentType, PreviousType, ModelType>(
    PgModifier<TableType, CurrentType, PreviousType, ModelType> modifier,
  ) {
    final modifiers = <PgModifier<TableType, dynamic, dynamic, dynamic>>[];

    PgModifier<TableType, dynamic, dynamic, dynamic>? current = modifier;

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

class PgModifierBuilder<CurrentType> {
  PgModifierBuilder(this.builder);

  final PostgrestBuilder<dynamic, dynamic, dynamic> builder;
}

/// Annoyingly the final type [ModelType] is required in order for us to map
/// the json to the model (in PgTable._castResponse).
class PgModifier<TableType, CurrentType, PreviousType, ModelType> {
  const PgModifier(this.previousModifier);

  final PgModifier<TableType, PreviousType, dynamic, dynamic>? previousModifier;

  @mustBeOverridden
  @internal
  PgModifierBuilder<CurrentType> build(
    PostgrestTransformBuilder<PreviousType> builder,
  ) => PgModifierBuilder(builder);
}

extension PgListModifierX<TableType>
    on PgModifier<TableType, PostgrestList, dynamic, dynamic> {
  PgAsCSVModifier<TableType> asCSV() => PgAsCSVModifier(this);

  PgAsModelsModifier<TableType, ModelType>
  asModels<ModelType extends PgModel<TableType>>(
    ModelType Function(PostgrestMap) fromJson,
  ) => PgAsModelsModifier(this, fromJson);

  PgAsRawModifier<TableType> asRaw() => PgAsRawModifier(this);

  PgCountModifier<TableType> count(CountOption option) =>
      PgCountModifier(this, option);

  PgLimitModifier<TableType> limit(int limit) => PgLimitModifier(this, limit);

  PgMaybeSingleModifier<TableType> maybeSingle() => PgMaybeSingleModifier(this);

  PgNoneModifier<TableType> none() => PgNoneModifier(this);

  PgOrderModifier<TableType> order(
    PgColumn<TableType, dynamic, dynamic> column, {
    bool ascending = false,
    bool nullsFirst = false,
  }) => PgOrderModifier(this, column, ascending, nullsFirst);

  PgRangeModifier<TableType> range(int start, int end) =>
      PgRangeModifier(this, start, end);

  PgSingleModifier<TableType> single() => PgSingleModifier(this);
}

extension PgMapModifierX<TableType>
    on PgModifier<TableType, PostgrestMap, dynamic, dynamic> {
  PgAsCSVModifier<TableType> asCSV() => PgAsCSVModifier(this);

  PgAsModelModifier<TableType, ModelType>
  asModel<ModelType extends PgModel<TableType>>(
    ModelType Function(PostgrestMap) fromJson,
  ) => PgAsModelModifier(this, fromJson);
}

extension PgMaybeMapModifierX<TableType>
    on PgModifier<TableType, PostgrestMap?, dynamic, dynamic> {
  PgAsCSVModifier<TableType> asCSV() => PgAsCSVModifier(this);

  PgMaybeAsModelModifier<TableType, ModelType>
  maybeAsModel<ModelType extends PgModel<TableType>>(
    ModelType Function(PostgrestMap) fromJson,
  ) => PgMaybeAsModelModifier(this, fromJson);
}
