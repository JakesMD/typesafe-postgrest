import 'package:typesafe_postgrest/typesafe_postgrest.dart';

/// {@template typesafe_postgrest.PgUpsert}
///
/// Represents the data required to perform an insert or upsert operation.
///
/// Generally, you should not need to construct this class directly as it is
/// code generated.
///
/// The code generated class will have a constructor that only requires the
/// values that are not nullable and don't have a default value.
///
/// [TableType] is used to provide type safety. Objects that require an upsert
/// will only allow upserts the provided [TableType]. Also, the upsert will
/// only allow values of the provided [TableType].
///
/// {@endtemplate}
class PgUpsert<TableType> {
  /// {@macro typesafe_postgrest.PgUpsert}
  const PgUpsert(this.values);

  /// The values to insert or upsert.
  final PgValuesList<TableType> values;

  /// Returns the value of the given column.
  ValueType value<ValueType>(
    PgQueryColumn<TableType, ValueType, dynamic> column,
  ) =>
      values.firstWhere((value) => value.columnName == column.name).value
          as ValueType;
}
