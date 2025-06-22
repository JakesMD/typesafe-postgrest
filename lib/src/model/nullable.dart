/// {@template typesafe_postgrest.PgNullable}
///
/// A nullable value.
///
/// This allows Dart to distinguish between an optional parameter and a value
/// set to null.
///
/// {@endtemplate}
class PgNullable<T> {
  /// {@macro typesafe_postgrest.PgNullable}
  const PgNullable(this.value);

  /// The value that may be null but is not an optional parameter.
  final T? value;
}
