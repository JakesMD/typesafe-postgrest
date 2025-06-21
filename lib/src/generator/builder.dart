import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:typesafe_postgrest/src/generator/model_x_generator.dart';

/// The builder for the [PgModelXGenerator].
Builder pgModelXBuilder(BuilderOptions options) =>
    SharedPartBuilder([PgModelXGenerator()], 'model_x');
