import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:typesafe_postgrest/src/generator/generators/model_x_generator.dart';
import 'package:typesafe_postgrest/src/generator/generators/upsert_generator.dart';

export 'generators/_generators.dart';

/// The builder for the [PgModelXGenerator].
Builder pgModelXBuilder(BuilderOptions options) =>
    SharedPartBuilder([PgModelXGenerator()], 'model_x_generator');

/// The builder for the [PgUpsertGenerator].
Builder pgUpsertBuilder(BuilderOptions options) =>
    SharedPartBuilder([PgUpsertGenerator()], 'upsert_generator');
