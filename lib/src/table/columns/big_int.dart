import 'package:typesafe_postgrest/typesafe_postgrest.dart';

/// {@template typesafe_postgrest.PgBigIntColumn}
///
/// Represents a column of type [BigInt] in a table.
///
/// It handles the conversion from and to JSON for you.
///
/// {@endtemplate}
class PgBigIntColumn<TableType> extends PgColumn<TableType, BigInt, int> {
  /// {@macro typesafe_postgrest.PgBigIntColumn}
  PgBigIntColumn(super.name)
    : super(fromJson: BigInt.from, toJson: (value) => value.toInt());
}

/// {@template typesafe_postgrest.PgMaybeBigIntColumn}
///
/// Represents a column that can be null of type [BigInt] in a table.
///
/// It handles the conversion from and to JSON for you.
///
/// {@endtemplate}
class PgMaybeBigIntColumn<TableType>
    extends PgColumn<TableType, BigInt?, int?> {
  /// {@macro typesafe_postgrest.PgBigIntColumn}
  PgMaybeBigIntColumn(super.name)
    : super(
        fromJson: (value) => value != null ? BigInt.from(value) : null,
        toJson: (value) => value?.toInt(),
      );
}
