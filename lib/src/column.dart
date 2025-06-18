import 'package:meta/meta.dart';
import 'package:postgrest/postgrest.dart';
import 'package:typesafe_postgrest/typesafe_postgrest.dart';

class PgColumn<TableType, ValueType, JSONValueType> {
  const PgColumn(this.name, {required this.fromJson, required this.toJson})
    : queryPattern = name;

  @internal
  const PgColumn.withQueryPattern(
    this.name, {
    required this.queryPattern,
    required this.fromJson,
    required this.toJson,
  });

  final String name;

  final String queryPattern;

  final ValueType Function(JSONValueType jsonValue) fromJson;
  final JSONValueType Function(ValueType value) toJson;

  PgValue<ValueType> apply(ValueType value) => PgValue(name, value);

  @internal
  PgValue<ValueType> pgValueFromJson(dynamic value) => PgValue(
    name,
    JSONValueType == PostgrestList
        ? fromJson(PostgrestList.from(value as List) as JSONValueType)
        : fromJson(value as JSONValueType),
  );
}

class PgStringColumn<TableType> extends PgColumn<TableType, String, String> {
  PgStringColumn(super.name)
    : super(fromJson: (jsonValue) => jsonValue, toJson: (value) => value);
}

class PgOptionalStringColumn<TableType>
    extends PgColumn<TableType, String?, String?> {
  PgOptionalStringColumn(super.name)
    : super(fromJson: (jsonValue) => jsonValue, toJson: (value) => value);
}

class PgIntColumn<TableType> extends PgColumn<TableType, int, int> {
  PgIntColumn(super.name)
    : super(fromJson: (jsonValue) => jsonValue, toJson: (value) => value);
}

class PgOptionalIntColumn<TableType> extends PgColumn<TableType, int?, int?> {
  PgOptionalIntColumn(super.name)
    : super(fromJson: (jsonValue) => jsonValue, toJson: (value) => value);
}

class PgBigIntColumn<TableType> extends PgColumn<TableType, BigInt, int> {
  PgBigIntColumn(super.name)
    : super(fromJson: BigInt.from, toJson: (value) => value.toInt());
}
