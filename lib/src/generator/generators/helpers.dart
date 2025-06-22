// source_gen hasn't updated it's analyzer dependency yet.
// ignore_for_file: deprecated_member_use

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:meta/meta.dart';
import 'package:source_gen/source_gen.dart';

@internal
ClassElement getElementAsClass(Element element, TypeChecker typeChecker) {
  if (element is! ClassElement) {
    throw InvalidGenerationSourceError(
      '''${element.displayName} is not a class.''',
      element: element,
    );
  }

  if (!typeChecker.isAssignableFrom(element)) {
    throw InvalidGenerationSourceError(
      '''${element.displayName} does not extend PgTable.''',
      element: element,
    );
  }

  return element;
}

@internal
InstanceCreationExpression getDeclarationCreationExpression(
  FieldElement element,
  VariableDeclaration declaration,
) {
  final expression = declaration.initializer;

  if (expression is! InstanceCreationExpression) {
    throw InvalidGenerationSourceError(
      '''${element.displayName} is not an instance creation expression.''',
      element: element,
    );
  }

  return expression;
}

@internal
Future<VariableDeclaration> getElementVariableDeclaration(
  FieldElement element,
  BuildStep buildStep,
) async {
  final declaration = await buildStep.resolver.astNodeFor(
    element,
    resolve: true,
  );

  if (declaration is! VariableDeclaration) {
    throw InvalidGenerationSourceError(
      '''${element.displayName} is not a variable declaration.''',
      element: element,
    );
  }
  return declaration;
}
