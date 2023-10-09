// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'test.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetTestCollection on Isar {
  IsarCollection<Test> get tests => this.collection();
}

const TestSchema = CollectionSchema(
  name: r'Test',
  id: -5479267249076327074,
  properties: {
    r'allowError': PropertySchema(
      id: 0,
      name: r'allowError',
      type: IsarType.bool,
    ),
    r'flipTerms': PropertySchema(
      id: 1,
      name: r'flipTerms',
      type: IsarType.bool,
    ),
    r'lastTestDate': PropertySchema(
      id: 2,
      name: r'lastTestDate',
      type: IsarType.dateTime,
    ),
    r'title': PropertySchema(
      id: 3,
      name: r'title',
      type: IsarType.string,
    )
  },
  estimateSize: _testEstimateSize,
  serialize: _testSerialize,
  deserialize: _testDeserialize,
  deserializeProp: _testDeserializeProp,
  idName: r'id',
  indexes: {
    r'lastTestDate': IndexSchema(
      id: 8519310673598575799,
      name: r'lastTestDate',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'lastTestDate',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {
    r'questions': LinkSchema(
      id: 7337840743230316860,
      name: r'questions',
      target: r'Question',
      single: false,
      linkName: r'test',
    ),
    r'records': LinkSchema(
      id: 2446410030340982192,
      name: r'records',
      target: r'Record',
      single: false,
      linkName: r'test',
    )
  },
  embeddedSchemas: {},
  getId: _testGetId,
  getLinks: _testGetLinks,
  attach: _testAttach,
  version: '3.1.0+1',
);

int _testEstimateSize(
  Test object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.title.length * 3;
  return bytesCount;
}

void _testSerialize(
  Test object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.allowError);
  writer.writeBool(offsets[1], object.flipTerms);
  writer.writeDateTime(offsets[2], object.lastTestDate);
  writer.writeString(offsets[3], object.title);
}

Test _testDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Test(
    allowError: reader.readBoolOrNull(offsets[0]) ?? false,
    flipTerms: reader.readBoolOrNull(offsets[1]) ?? false,
    title: reader.readString(offsets[3]),
  );
  object.id = id;
  object.lastTestDate = reader.readDateTimeOrNull(offsets[2]);
  return object;
}

P _testDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 1:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 2:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _testGetId(Test object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _testGetLinks(Test object) {
  return [object.questions, object.records];
}

void _testAttach(IsarCollection<dynamic> col, Id id, Test object) {
  object.id = id;
  object.questions
      .attach(col, col.isar.collection<Question>(), r'questions', id);
  object.records.attach(col, col.isar.collection<Record>(), r'records', id);
}

extension TestQueryWhereSort on QueryBuilder<Test, Test, QWhere> {
  QueryBuilder<Test, Test, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<Test, Test, QAfterWhere> anyLastTestDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'lastTestDate'),
      );
    });
  }
}

extension TestQueryWhere on QueryBuilder<Test, Test, QWhereClause> {
  QueryBuilder<Test, Test, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Test, Test, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<Test, Test, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Test, Test, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Test, Test, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Test, Test, QAfterWhereClause> lastTestDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'lastTestDate',
        value: [null],
      ));
    });
  }

  QueryBuilder<Test, Test, QAfterWhereClause> lastTestDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'lastTestDate',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<Test, Test, QAfterWhereClause> lastTestDateEqualTo(
      DateTime? lastTestDate) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'lastTestDate',
        value: [lastTestDate],
      ));
    });
  }

  QueryBuilder<Test, Test, QAfterWhereClause> lastTestDateNotEqualTo(
      DateTime? lastTestDate) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'lastTestDate',
              lower: [],
              upper: [lastTestDate],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'lastTestDate',
              lower: [lastTestDate],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'lastTestDate',
              lower: [lastTestDate],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'lastTestDate',
              lower: [],
              upper: [lastTestDate],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Test, Test, QAfterWhereClause> lastTestDateGreaterThan(
    DateTime? lastTestDate, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'lastTestDate',
        lower: [lastTestDate],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<Test, Test, QAfterWhereClause> lastTestDateLessThan(
    DateTime? lastTestDate, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'lastTestDate',
        lower: [],
        upper: [lastTestDate],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<Test, Test, QAfterWhereClause> lastTestDateBetween(
    DateTime? lowerLastTestDate,
    DateTime? upperLastTestDate, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'lastTestDate',
        lower: [lowerLastTestDate],
        includeLower: includeLower,
        upper: [upperLastTestDate],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension TestQueryFilter on QueryBuilder<Test, Test, QFilterCondition> {
  QueryBuilder<Test, Test, QAfterFilterCondition> allowErrorEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'allowError',
        value: value,
      ));
    });
  }

  QueryBuilder<Test, Test, QAfterFilterCondition> flipTermsEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'flipTerms',
        value: value,
      ));
    });
  }

  QueryBuilder<Test, Test, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Test, Test, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Test, Test, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Test, Test, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Test, Test, QAfterFilterCondition> lastTestDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastTestDate',
      ));
    });
  }

  QueryBuilder<Test, Test, QAfterFilterCondition> lastTestDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastTestDate',
      ));
    });
  }

  QueryBuilder<Test, Test, QAfterFilterCondition> lastTestDateEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastTestDate',
        value: value,
      ));
    });
  }

  QueryBuilder<Test, Test, QAfterFilterCondition> lastTestDateGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastTestDate',
        value: value,
      ));
    });
  }

  QueryBuilder<Test, Test, QAfterFilterCondition> lastTestDateLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastTestDate',
        value: value,
      ));
    });
  }

  QueryBuilder<Test, Test, QAfterFilterCondition> lastTestDateBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastTestDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Test, Test, QAfterFilterCondition> titleEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Test, Test, QAfterFilterCondition> titleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Test, Test, QAfterFilterCondition> titleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Test, Test, QAfterFilterCondition> titleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'title',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Test, Test, QAfterFilterCondition> titleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Test, Test, QAfterFilterCondition> titleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Test, Test, QAfterFilterCondition> titleContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Test, Test, QAfterFilterCondition> titleMatches(String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'title',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Test, Test, QAfterFilterCondition> titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<Test, Test, QAfterFilterCondition> titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'title',
        value: '',
      ));
    });
  }
}

extension TestQueryObject on QueryBuilder<Test, Test, QFilterCondition> {}

extension TestQueryLinks on QueryBuilder<Test, Test, QFilterCondition> {
  QueryBuilder<Test, Test, QAfterFilterCondition> questions(
      FilterQuery<Question> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'questions');
    });
  }

  QueryBuilder<Test, Test, QAfterFilterCondition> questionsLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'questions', length, true, length, true);
    });
  }

  QueryBuilder<Test, Test, QAfterFilterCondition> questionsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'questions', 0, true, 0, true);
    });
  }

  QueryBuilder<Test, Test, QAfterFilterCondition> questionsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'questions', 0, false, 999999, true);
    });
  }

  QueryBuilder<Test, Test, QAfterFilterCondition> questionsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'questions', 0, true, length, include);
    });
  }

  QueryBuilder<Test, Test, QAfterFilterCondition> questionsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'questions', length, include, 999999, true);
    });
  }

  QueryBuilder<Test, Test, QAfterFilterCondition> questionsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'questions', lower, includeLower, upper, includeUpper);
    });
  }

  QueryBuilder<Test, Test, QAfterFilterCondition> records(
      FilterQuery<Record> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'records');
    });
  }

  QueryBuilder<Test, Test, QAfterFilterCondition> recordsLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'records', length, true, length, true);
    });
  }

  QueryBuilder<Test, Test, QAfterFilterCondition> recordsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'records', 0, true, 0, true);
    });
  }

  QueryBuilder<Test, Test, QAfterFilterCondition> recordsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'records', 0, false, 999999, true);
    });
  }

  QueryBuilder<Test, Test, QAfterFilterCondition> recordsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'records', 0, true, length, include);
    });
  }

  QueryBuilder<Test, Test, QAfterFilterCondition> recordsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'records', length, include, 999999, true);
    });
  }

  QueryBuilder<Test, Test, QAfterFilterCondition> recordsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'records', lower, includeLower, upper, includeUpper);
    });
  }
}

extension TestQuerySortBy on QueryBuilder<Test, Test, QSortBy> {
  QueryBuilder<Test, Test, QAfterSortBy> sortByAllowError() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'allowError', Sort.asc);
    });
  }

  QueryBuilder<Test, Test, QAfterSortBy> sortByAllowErrorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'allowError', Sort.desc);
    });
  }

  QueryBuilder<Test, Test, QAfterSortBy> sortByFlipTerms() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'flipTerms', Sort.asc);
    });
  }

  QueryBuilder<Test, Test, QAfterSortBy> sortByFlipTermsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'flipTerms', Sort.desc);
    });
  }

  QueryBuilder<Test, Test, QAfterSortBy> sortByLastTestDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastTestDate', Sort.asc);
    });
  }

  QueryBuilder<Test, Test, QAfterSortBy> sortByLastTestDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastTestDate', Sort.desc);
    });
  }

  QueryBuilder<Test, Test, QAfterSortBy> sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<Test, Test, QAfterSortBy> sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }
}

extension TestQuerySortThenBy on QueryBuilder<Test, Test, QSortThenBy> {
  QueryBuilder<Test, Test, QAfterSortBy> thenByAllowError() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'allowError', Sort.asc);
    });
  }

  QueryBuilder<Test, Test, QAfterSortBy> thenByAllowErrorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'allowError', Sort.desc);
    });
  }

  QueryBuilder<Test, Test, QAfterSortBy> thenByFlipTerms() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'flipTerms', Sort.asc);
    });
  }

  QueryBuilder<Test, Test, QAfterSortBy> thenByFlipTermsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'flipTerms', Sort.desc);
    });
  }

  QueryBuilder<Test, Test, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Test, Test, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Test, Test, QAfterSortBy> thenByLastTestDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastTestDate', Sort.asc);
    });
  }

  QueryBuilder<Test, Test, QAfterSortBy> thenByLastTestDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastTestDate', Sort.desc);
    });
  }

  QueryBuilder<Test, Test, QAfterSortBy> thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<Test, Test, QAfterSortBy> thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }
}

extension TestQueryWhereDistinct on QueryBuilder<Test, Test, QDistinct> {
  QueryBuilder<Test, Test, QDistinct> distinctByAllowError() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'allowError');
    });
  }

  QueryBuilder<Test, Test, QDistinct> distinctByFlipTerms() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'flipTerms');
    });
  }

  QueryBuilder<Test, Test, QDistinct> distinctByLastTestDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastTestDate');
    });
  }

  QueryBuilder<Test, Test, QDistinct> distinctByTitle(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }
}

extension TestQueryProperty on QueryBuilder<Test, Test, QQueryProperty> {
  QueryBuilder<Test, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Test, bool, QQueryOperations> allowErrorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'allowError');
    });
  }

  QueryBuilder<Test, bool, QQueryOperations> flipTermsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'flipTerms');
    });
  }

  QueryBuilder<Test, DateTime?, QQueryOperations> lastTestDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastTestDate');
    });
  }

  QueryBuilder<Test, String, QQueryOperations> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }
}
