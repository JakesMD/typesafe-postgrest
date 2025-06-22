// typedefs are self-documenting
// ignore_for_file: public_member_api_docs

import 'package:postgrest/postgrest.dart';
import 'package:typesafe_postgrest/typesafe_postgrest.dart';

typedef PgJsonList = PostgrestList;
typedef PgJsonMap = PostgrestMap;
typedef PgQueryColumnList<TableType> =
    List<PgQueryColumn<TableType, dynamic, dynamic>>;
typedef PgValuesList<TableType> = List<PgValue<TableType, dynamic, dynamic>>;
