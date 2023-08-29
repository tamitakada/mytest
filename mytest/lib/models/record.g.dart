// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetRecordCollection on Isar {
  IsarCollection<Record> get records => this.collection();
}

const RecordSchema = CollectionSchema(
  name: r'Record',
  id: -5560585825827271694,
  properties: {
    r'time': PropertySchema(
      id: 0,
      name: r'time',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _recordEstimateSize,
  serialize: _recordSerialize,
  deserialize: _recordDeserialize,
  deserializeProp: _recordDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {
    r'test': LinkSchema(
      id: 2239523053908241963,
      name: r'test',
      target: r'Test',
      single: true,
    ),
    r'correctQuestions': LinkSchema(
      id: -5384535177894071325,
      name: r'correctQuestions',
      target: r'Question',
      single: false,
    ),
    r'incorrectQuestions': LinkSchema(
      id: 5700770298333593106,
      name: r'incorrectQuestions',
      target: r'Question',
      single: false,
    )
  },
  embeddedSchemas: {},
  getId: _recordGetId,
  getLinks: _recordGetLinks,
  attach: _recordAttach,
  version: '3.1.0+1',
);

int _recordEstimateSize(
  Record object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _recordSerialize(
  Record object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.time);
}

Record _recordDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Record(
    time: reader.readDateTime(offsets[0]),
  );
  object.id = id;
  return object;
}

P _recordDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _recordGetId(Record object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _recordGetLinks(Record object) {
  return [object.test, object.correctQuestions, object.incorrectQuestions];
}

void _recordAttach(IsarCollection<dynamic> col, Id id, Record object) {
  object.id = id;
  object.test.attach(col, col.isar.collection<Test>(), r'test', id);
  object.correctQuestions
      .attach(col, col.isar.collection<Question>(), r'correctQuestions', id);
  object.incorrectQuestions
      .attach(col, col.isar.collection<Question>(), r'incorrectQuestions', id);
}

extension RecordQueryWhereSort on QueryBuilder<Record, Record, QWhere> {
  QueryBuilder<Record, Record, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension RecordQueryWhere on QueryBuilder<Record, Record, QWhereClause> {
  QueryBuilder<Record, Record, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Record, Record, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Record, Record, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Record, Record, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Record, Record, QAfterWhereClause> idBetween(
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
}

extension RecordQueryFilter on QueryBuilder<Record, Record, QFilterCondition> {
  QueryBuilder<Record, Record, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Record, Record, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Record, Record, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Record, Record, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Record, Record, QAfterFilterCondition> timeEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'time',
        value: value,
      ));
    });
  }

  QueryBuilder<Record, Record, QAfterFilterCondition> timeGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'time',
        value: value,
      ));
    });
  }

  QueryBuilder<Record, Record, QAfterFilterCondition> timeLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'time',
        value: value,
      ));
    });
  }

  QueryBuilder<Record, Record, QAfterFilterCondition> timeBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'time',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension RecordQueryObject on QueryBuilder<Record, Record, QFilterCondition> {}

extension RecordQueryLinks on QueryBuilder<Record, Record, QFilterCondition> {
  QueryBuilder<Record, Record, QAfterFilterCondition> test(
      FilterQuery<Test> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'test');
    });
  }

  QueryBuilder<Record, Record, QAfterFilterCondition> testIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'test', 0, true, 0, true);
    });
  }

  QueryBuilder<Record, Record, QAfterFilterCondition> correctQuestions(
      FilterQuery<Question> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'correctQuestions');
    });
  }

  QueryBuilder<Record, Record, QAfterFilterCondition>
      correctQuestionsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'correctQuestions', length, true, length, true);
    });
  }

  QueryBuilder<Record, Record, QAfterFilterCondition>
      correctQuestionsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'correctQuestions', 0, true, 0, true);
    });
  }

  QueryBuilder<Record, Record, QAfterFilterCondition>
      correctQuestionsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'correctQuestions', 0, false, 999999, true);
    });
  }

  QueryBuilder<Record, Record, QAfterFilterCondition>
      correctQuestionsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'correctQuestions', 0, true, length, include);
    });
  }

  QueryBuilder<Record, Record, QAfterFilterCondition>
      correctQuestionsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'correctQuestions', length, include, 999999, true);
    });
  }

  QueryBuilder<Record, Record, QAfterFilterCondition>
      correctQuestionsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'correctQuestions', lower, includeLower, upper, includeUpper);
    });
  }

  QueryBuilder<Record, Record, QAfterFilterCondition> incorrectQuestions(
      FilterQuery<Question> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'incorrectQuestions');
    });
  }

  QueryBuilder<Record, Record, QAfterFilterCondition>
      incorrectQuestionsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'incorrectQuestions', length, true, length, true);
    });
  }

  QueryBuilder<Record, Record, QAfterFilterCondition>
      incorrectQuestionsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'incorrectQuestions', 0, true, 0, true);
    });
  }

  QueryBuilder<Record, Record, QAfterFilterCondition>
      incorrectQuestionsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'incorrectQuestions', 0, false, 999999, true);
    });
  }

  QueryBuilder<Record, Record, QAfterFilterCondition>
      incorrectQuestionsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'incorrectQuestions', 0, true, length, include);
    });
  }

  QueryBuilder<Record, Record, QAfterFilterCondition>
      incorrectQuestionsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'incorrectQuestions', length, include, 999999, true);
    });
  }

  QueryBuilder<Record, Record, QAfterFilterCondition>
      incorrectQuestionsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'incorrectQuestions', lower, includeLower, upper, includeUpper);
    });
  }
}

extension RecordQuerySortBy on QueryBuilder<Record, Record, QSortBy> {
  QueryBuilder<Record, Record, QAfterSortBy> sortByTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'time', Sort.asc);
    });
  }

  QueryBuilder<Record, Record, QAfterSortBy> sortByTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'time', Sort.desc);
    });
  }
}

extension RecordQuerySortThenBy on QueryBuilder<Record, Record, QSortThenBy> {
  QueryBuilder<Record, Record, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Record, Record, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Record, Record, QAfterSortBy> thenByTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'time', Sort.asc);
    });
  }

  QueryBuilder<Record, Record, QAfterSortBy> thenByTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'time', Sort.desc);
    });
  }
}

extension RecordQueryWhereDistinct on QueryBuilder<Record, Record, QDistinct> {
  QueryBuilder<Record, Record, QDistinct> distinctByTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'time');
    });
  }
}

extension RecordQueryProperty on QueryBuilder<Record, Record, QQueryProperty> {
  QueryBuilder<Record, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Record, DateTime, QQueryOperations> timeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'time');
    });
  }
}
