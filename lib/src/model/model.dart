import 'package:typesafe_postgrest/typesafe_postgrest.dart';

export 'model_builder.dart';
export 'nullable.dart';

/// {@template typesafe_postgrest.PgModel}
///
/// A custom return type for a query.
///
/// [TableType] is used to provide type safety. Objects that require a model
/// will only allow models of the provided [TableType]. Also, the model will
/// only allow columns, values and builders of the provided [TableType].
///
/// {@endtemplate}
class PgModel<TableType> {
  /// {@macro typesafe_postgrest.PgModel}
  ///
  /// It generates the values from the given JSON and builder's columns.
  PgModel(
    Map<String, dynamic>? json,
    PgValuesList<TableType>? values, {
    required PgModelBuilder<TableType, PgModel<TableType>> builder,
  }) : values =
           values ??
           json?.entries.map((entry) {
             final column = builder.columns.firstWhere(
               (column) => column.name == entry.key,
             );
             return column.pgValueFromJson(entry.value);
           }).toList() ??
           [];

  /// The values of the columns.
  final PgValuesList<TableType> values;

  /// Returns the value of the given column.
  ///
  /// Generally, you shouldn't need to use this method directly, as it is used
  /// in the generated code.
  ValueType value<ValueType>(
    PgQueryColumn<TableType, ValueType, dynamic> column,
  ) {
    try {
      return values.firstWhere((value) => value.columnName == column.name).value
          as ValueType;
      // We're catching a StateError.
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      throw PgMissingDataException(column.name);
    }
  }
}
