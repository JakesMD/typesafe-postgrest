import 'package:postgrest/postgrest.dart';
import 'package:typesafe_postgrest/typesafe_postgrest.dart';

class PgModelBuilder<TableType, ModelType extends PgModel<TableType>> {
  const PgModelBuilder({
    required this.constructor,
    required this.columns,
  });

  final ModelType Function(PostgrestMap) constructor;

  final PgColumnList columns;
}
