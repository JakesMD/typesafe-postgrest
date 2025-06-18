import 'package:typesafe_postgrest/typesafe_postgrest.dart';

class PgModel<TableType> {
  /// Creates a new model from the given JSON.
  PgModel(
    Map<String, dynamic> json, {
    required PgModelBuilder<TableType, PgModel<TableType>> builder,
  }) : values = json.entries.map((entry) {
         final column = builder.columns.firstWhere(
           (column) => column.name == entry.key,
         );
         return column.pgValueFromJson(entry.value);
       }).toList();

  PgModel.fromValues(this.values);

  /// The values of the columns.
  final List<PgValue<dynamic>> values;

  /// Returns the value of the given column.
  ValueType value<ValueType>(PgColumn<TableType, ValueType, dynamic> column) =>
      values.firstWhere((value) => value.name == column.name).value
          as ValueType;
}
