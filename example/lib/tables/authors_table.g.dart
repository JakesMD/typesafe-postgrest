// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'authors_table.dart';

// **************************************************************************
// PgUpsertGenerator
// **************************************************************************

/// {@template AuthorsTableUpsert}
///
/// Represents the data required to perform an insert or upsert operation on the
/// [AuthorsTable] table.
///
/// {@endtemplate}
class AuthorsTableUpsert extends PgUpsert<AuthorsTable> {
  /// {@macro AuthorsTableUpsert}
  AuthorsTableUpsert({required String name, BigInt? id})
    : super([AuthorsTable.name(name), if (id != null) AuthorsTable.id(id)]);
}
