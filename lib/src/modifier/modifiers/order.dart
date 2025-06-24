import 'package:meta/meta.dart';
import 'package:postgrest/postgrest.dart';
import 'package:typesafe_postgrest/typesafe_postgrest.dart';

/// {@template typesafe_postgrest.PgOrderModifier}
///
/// Orders the result with the specified [column].
///
/// `column`: The column to order by.
///
/// `ascending`: Whether to order in ascending order.
///
/// `nullsFirst`: Whether to order nulls first.
///
/// {@endtemplate}
class PgOrderModifier<TableType>
    extends PgModifier<TableType, PgJsonList, PgJsonList> {
  /// {@macro typesafe_postgrest.PgOrderModifier}
  @internal
  const PgOrderModifier(
    super.previousModifier,
    this.column,
    this.ascending,
    this.nullsFirst,
  );

  /// The column to order by.
  final PgColumn<TableType, dynamic, dynamic> column;

  /// Whether to order in ascending order.
  final bool ascending;

  /// Whether to order nulls first.
  final bool nullsFirst;

  @override
  @internal
  PostgrestTransformBuilder<PgJsonList> build(
    PostgrestTransformBuilder<PgJsonList> builder,
  ) => builder.order(column.name, ascending: ascending, nullsFirst: nullsFirst);
}
