// source_gen hasn't updated it's analyzer dependency yet.
// ignore_for_file: deprecated_member_use

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:typesafe_postgrest/src/generator/generators/helpers.dart';
import 'package:typesafe_postgrest/typesafe_postgrest.dart';

/// Generates an extension to a [PgModel] class.
class PgModelXGenerator extends GeneratorForAnnotation<PgModelHere> {
  @override
  Future<String> generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) async {
    final modelClass = getElementAsClass(
      element,
      const TypeChecker.fromRuntime(PgModel),
    );
    final builderField = _getBuilderField(modelClass);
    final builderDeclaration = await getElementVariableDeclaration(
      builderField,
      buildStep,
    );
    final creationExpression = getDeclarationCreationExpression(
      builderField,
      builderDeclaration,
    );
    final columnsList = _getColumnsList(builderField, creationExpression);

    final buffer = StringBuffer();
    final columnInfos = <_ColumnInfo>[];

    for (final elementInList in columnsList.elements) {
      if (elementInList is PrefixedIdentifier) {
        if (elementInList.staticType is! InterfaceType) continue;

        final superclass =
            (elementInList.staticType! as InterfaceType).superclass;

        if (elementInList.staticElement == null ||
            superclass == null ||
            superclass.typeArguments.length < 2) {
          continue;
        }

        columnInfos.add(
          _ColumnInfo(
            elementInList.staticElement!.displayName,
            elementInList.name,
            superclass.typeArguments[1].toString(),
          ),
        );
      } else if (elementInList is Expression) {
        if (elementInList.staticType is! InterfaceType) continue;

        final staticType = elementInList.staticType! as InterfaceType;

        if (staticType.typeArguments.length < 2) continue;

        columnInfos.add(
          _ColumnInfo(
            // The display name for elementInList is 'call'... so we cheat.
            // -> Book.author(Author.builder)
            // -> 'Book', 'author', '(Author.builder)'
            //               ^
            elementInList.toString().split('.')[1].split('(').first,
            elementInList.toString(),
            staticType.typeArguments[1].name == 'List'
                ? staticType.typeArguments[1].toString()
                // For some reason it finds PgModel<TableType> instead of
                // ModelType... so we cheat.
                //  -> Book.author(Author.builder)
                //  -> 'Book.author', 'Author', 'builder)'
                //                       ^
                : elementInList.toString().split('(').last.split('.').first,
          ),
        );
      }
    }

    buffer.writeln(
      '''
// The generator is not capable of fetching the documentation comments for some
// reason.
// ignore_for_file: public_member_api_docs

extension Pg${modelClass.displayName}X on ${modelClass.displayName} {
''',
    );

    for (final column in columnInfos) {
      buffer.writeln(
        '''  ${column.type} get ${column.name} => value(${column.columnReference});''',
      );
    }

    buffer.writeln('}');

    return buffer.toString();
  }

  FieldElement _getBuilderField(ClassElement modelClass) {
    const builderTypeChecker = TypeChecker.fromRuntime(PgModelBuilder);

    for (final field in modelClass.fields) {
      if (field.isStatic &&
          builderTypeChecker.isAssignableFromType(field.type)) {
        return field;
      }
    }

    throw InvalidGenerationSourceError(
      '''${modelClass.displayName} does not have a static field of type PgModelBuilder.''',
      element: modelClass,
    );
  }

  ListLiteral _getColumnsList(
    FieldElement element,
    InstanceCreationExpression creationExpression,
  ) {
    final columnsExpression = creationExpression.argumentList.arguments
        .whereType<NamedExpression>()
        .firstWhere(
          (arg) => arg.name.label.name == 'columns',
          orElse: () => throw InvalidGenerationSourceError(
            '''${element.displayName} does not have a list of columns.''',
            element: element,
          ),
        )
        .expression;

    if (columnsExpression is! ListLiteral) {
      throw InvalidGenerationSourceError(
        '''${element.displayName} does not have a list of columns.''',
        element: element,
      );
    }

    return columnsExpression;
  }
}

class _ColumnInfo {
  const _ColumnInfo(this.name, this.columnReference, this.type);

  final String name;
  final String columnReference;
  final String type;

  @override
  String toString() =>
      '''ColumnInfo{name: $name, columnReference: $columnReference, type: $type}''';
}
