// typedefs are self-documenting
// ignore_for_file: public_member_api_docs

import 'package:postgrest/postgrest.dart';
import 'package:typesafe_postgrest/typesafe_postgrest.dart';

typedef PgJsonList = PostgrestList;
typedef PgJsonMap = PostgrestMap;
typedef PgColumnList<TableType> = List<PgColumn<TableType, dynamic, dynamic>>;
