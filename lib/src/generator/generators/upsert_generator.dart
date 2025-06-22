// source_gen hasn't updated it's analyzer dependency yet.
// ignore_for_file: deprecated_member_use

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:typesafe_postgrest/src/generator/generators/helpers.dart';
import 'package:typesafe_postgrest/typesafe_postgrest.dart';

/// Generates an upsert for a table.
class PgUpsertGenerator extends GeneratorForAnnotation<PgTableHere> {
  @override
  Future<String> generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) async {
    final tableClass = getElementAsClass(
      element,
      const TypeChecker.fromRuntime(PgTable),
    );
    final columnFields = _getColumnFields(tableClass);

    final columnInfos = <_ColumnInfo>[];
    final buffer = StringBuffer();

    for (final columnField in columnFields) {
      final declaration = await getElementVariableDeclaration(
        columnField,
        buildStep,
      );
      final creationExpression = getDeclarationCreationExpression(
        columnField,
        declaration,
      );

      final staticType = creationExpression.staticType;

      if (staticType is! InterfaceType) continue;

      final superclass =
          (creationExpression.staticType! as InterfaceType).superclass;

      if (superclass == null || superclass.typeArguments.length < 2) {
        continue;
      }

      columnInfos.add(
        _ColumnInfo(
          columnField.displayName,
          superclass.typeArguments[1].toString(),
          _hasDefaultAnnotation(columnField),
        ),
      );
    }

    columnInfos.sort((a, b) => a.hasDefault ? 1 : -1);

    buffer.writeln('''
/// {@template ${tableClass.displayName}Upsert}
/// 
/// Represents the data required to perform an insert or upsert operation on the
/// [${tableClass.displayName}] table.
/// 
/// {@endtemplate}
class ${tableClass.displayName}Upsert extends PgUpsert<${tableClass.displayName}> {
  /// {@macro ${tableClass.displayName}Upsert}
  ${tableClass.displayName}Upsert({
''');

    for (final columnInfo in columnInfos) {
      buffer.writeln(
        '''    ${columnInfo.isRequired ? 'required ' : ''}${columnInfo.isOptionalNullable ? 'PgNullable<${columnInfo.type.replaceFirst('?', '')}' : columnInfo.type}${columnInfo.isOptionalNullable ? '>' : ''}${!columnInfo.isRequired ? '?' : ''} ${columnInfo.name},''',
      );
    }

    buffer.writeln('  }) : super([');

    for (final columnInfo in columnInfos) {
      buffer.writeln(
        '''         ${!columnInfo.isRequired ? 'if(${columnInfo.name} != null) ' : ''}${tableClass.displayName}.${columnInfo.name}(${columnInfo.name}${columnInfo.isOptionalNullable ? '.value' : ''}),''',
      );
    }

    buffer.writeln('    ]);\n}');

    return buffer.toString();
  }

  List<FieldElement> _getColumnFields(ClassElement tableClass) {
    final columns = <FieldElement>[];
    const columnTypeChecker = TypeChecker.fromRuntime(PgColumn);

    for (final field in tableClass.fields) {
      if (field.isStatic &&
          columnTypeChecker.isAssignableFromType(field.type)) {
        columns.add(field);
      }
    }

    return columns;
  }

  bool _hasDefaultAnnotation(FieldElement field) =>
      const TypeChecker.fromRuntime(
        PgColumnHasDefault,
      ).hasAnnotationOfExact(field);
}

class _ColumnInfo {
  const _ColumnInfo(
    this.name,
    this.type,
    this.hasDefault,
  );

  final String name;
  final String type;
  final bool hasDefault;

  bool get isRequired => !isNullable && !hasDefault;
  bool get isOptionalNullable => isNullable && !isRequired;
  bool get isNullable => type.endsWith('?');

  @override
  String toString() =>
      '''ColumnInfo{name: $name, type: $type, hasDefault: $hasDefault}''';
}
