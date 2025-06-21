import 'package:typesafe_postgrest/typesafe_postgrest.dart';

/// {@template typesafe_postgrest.PgModelHere}
///
/// An annotation that marks a class as a [PgModel] for which an extension
/// should be generated.
///
/// The extension will contain the getter methods for the model's properties.
///
/// The annotated class must have a static [PgModelBuilder] field.
///
/// {@endtemplate}
class PgModelHere {
  /// {@macro typesafe_postgrest.PgModelHere}
  const PgModelHere();
}
