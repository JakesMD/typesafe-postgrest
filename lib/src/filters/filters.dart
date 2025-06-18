import 'package:typesafe_postgrest/typesafe_postgrest.dart';

extension PgColumnFilterX<TableType, ValueType>
    on PgColumn<TableType, ValueType, dynamic> {
  PgFilter<TableType> equals(ValueType value) => PgFilter();
}

PgFilter<TableType> where<TableType>(PgFilter<TableType> filter) => filter;
