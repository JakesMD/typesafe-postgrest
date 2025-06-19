import 'package:meta/meta.dart';
import 'package:postgrest/postgrest.dart';

/// {@template typesafe_postgrest.PgModifierBuilder}
///
/// A wrapper around a [PostgrestBuilder] that allows for differing types.
///
/// The [builder] will generate its own type, but the [PgModifierBuilder] must
/// have its [CurrentType] specified.
///
/// Generally, [CurrentType] will match the [builder]'s type. An example for
/// when they differ is when the query should return a list of models. The
/// builder in this case returns a [List<Map<String, dynamic>>].
///
/// If [CurrentType] and the [builder]'s type differ, the modifier will be
/// forced to be the last one in the chain. [CurrentType] will therefore be
/// the output type of the query. Make sure that the response is converted to
/// [CurrentType] correctly by PgTable.
///
/// {@endtemplate}
class PgModifierBuilder<CurrentType> {
  /// {@macro typesafe_postgrest.PgModifierBuilder}
  @internal
  const PgModifierBuilder(this.builder);

  /// The postgrest builder that will generate the query.
  final PostgrestBuilder<dynamic, dynamic, dynamic> builder;
}
