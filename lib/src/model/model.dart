import 'package:typesafe_postgrest/typesafe_postgrest.dart';

export 'fake_model_builder.dart';
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
    Map<String, dynamic> json, {
    required PgModelBuilder<TableType, PgModel<TableType>> builder,
  }) : values = json.entries.map((entry) {
         final column = builder.columns.firstWhere(
           (column) => column.name == entry.key,
         );
         return column.pgValueFromJson(entry.value);
       }).toList();

  /// Creates a new model from the given values.
  ///
  /// Generally, you shouldn't need to use this constructor directly. However,
  /// if you need to create your own instance of a model, you can use this.
  PgModel.fromValues(this.values);

  /// The values of the columns.
  final PgValuesList<TableType> values;

  /// Returns the value of the given column.
  ///
  /// Generally, you shouldn't need to use this method directly, as it is used
  /// in the generated code.
  ValueType value<ValueType>(
    PgQueryColumn<TableType, ValueType, dynamic> column,
  ) =>
      values.firstWhere((value) => value.columnName == column.name).value
          as ValueType;
}
