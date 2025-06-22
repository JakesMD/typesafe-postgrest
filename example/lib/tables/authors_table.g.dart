// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'authors_table.dart';

// **************************************************************************
// PgUpsertGenerator
// **************************************************************************

// Typedefs are self-documenting.
// ignore_for_line: public_member_api_docs
typedef AuthorsTableInsert = AuthorsTableUpsert;

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
