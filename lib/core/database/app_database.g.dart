// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CardsTable extends Cards with TableInfo<$CardsTable, CardData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CardsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 40),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _colorHexMeta =
      const VerificationMeta('colorHex');
  @override
  late final GeneratedColumn<String> colorHex = GeneratedColumn<String>(
      'color_hex', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('#D52B1E'));
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _positionMeta =
      const VerificationMeta('position');
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
      'position', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('active'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, colorHex, type, position, status, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cards';
  @override
  VerificationContext validateIntegrity(Insertable<CardData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('color_hex')) {
      context.handle(_colorHexMeta,
          colorHex.isAcceptableOrUnknown(data['color_hex']!, _colorHexMeta));
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('position')) {
      context.handle(_positionMeta,
          position.isAcceptableOrUnknown(data['position']!, _positionMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CardData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CardData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      colorHex: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}color_hex'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      position: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}position'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $CardsTable createAlias(String alias) {
    return $CardsTable(attachedDatabase, alias);
  }
}

class CardData extends DataClass implements Insertable<CardData> {
  final int id;
  final String name;
  final String colorHex;
  final String type;
  final int position;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  const CardData(
      {required this.id,
      required this.name,
      required this.colorHex,
      required this.type,
      required this.position,
      required this.status,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['color_hex'] = Variable<String>(colorHex);
    map['type'] = Variable<String>(type);
    map['position'] = Variable<int>(position);
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  CardsCompanion toCompanion(bool nullToAbsent) {
    return CardsCompanion(
      id: Value(id),
      name: Value(name),
      colorHex: Value(colorHex),
      type: Value(type),
      position: Value(position),
      status: Value(status),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory CardData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CardData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      colorHex: serializer.fromJson<String>(json['colorHex']),
      type: serializer.fromJson<String>(json['type']),
      position: serializer.fromJson<int>(json['position']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'colorHex': serializer.toJson<String>(colorHex),
      'type': serializer.toJson<String>(type),
      'position': serializer.toJson<int>(position),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  CardData copyWith(
          {int? id,
          String? name,
          String? colorHex,
          String? type,
          int? position,
          String? status,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      CardData(
        id: id ?? this.id,
        name: name ?? this.name,
        colorHex: colorHex ?? this.colorHex,
        type: type ?? this.type,
        position: position ?? this.position,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  CardData copyWithCompanion(CardsCompanion data) {
    return CardData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      colorHex: data.colorHex.present ? data.colorHex.value : this.colorHex,
      type: data.type.present ? data.type.value : this.type,
      position: data.position.present ? data.position.value : this.position,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CardData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('colorHex: $colorHex, ')
          ..write('type: $type, ')
          ..write('position: $position, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, name, colorHex, type, position, status, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CardData &&
          other.id == this.id &&
          other.name == this.name &&
          other.colorHex == this.colorHex &&
          other.type == this.type &&
          other.position == this.position &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class CardsCompanion extends UpdateCompanion<CardData> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> colorHex;
  final Value<String> type;
  final Value<int> position;
  final Value<String> status;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const CardsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.colorHex = const Value.absent(),
    this.type = const Value.absent(),
    this.position = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  CardsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.colorHex = const Value.absent(),
    required String type,
    this.position = const Value.absent(),
    this.status = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
  })  : name = Value(name),
        type = Value(type),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<CardData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? colorHex,
    Expression<String>? type,
    Expression<int>? position,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (colorHex != null) 'color_hex': colorHex,
      if (type != null) 'type': type,
      if (position != null) 'position': position,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  CardsCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String>? colorHex,
      Value<String>? type,
      Value<int>? position,
      Value<String>? status,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return CardsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      colorHex: colorHex ?? this.colorHex,
      type: type ?? this.type,
      position: position ?? this.position,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (colorHex.present) {
      map['color_hex'] = Variable<String>(colorHex.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CardsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('colorHex: $colorHex, ')
          ..write('type: $type, ')
          ..write('position: $position, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $SessionsTable extends Sessions
    with TableInfo<$SessionsTable, SessionData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _cardIdMeta = const VerificationMeta('cardId');
  @override
  late final GeneratedColumn<int> cardId = GeneratedColumn<int>(
      'card_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES cards (id)'));
  static const VerificationMeta _timerTypeMeta =
      const VerificationMeta('timerType');
  @override
  late final GeneratedColumn<String> timerType = GeneratedColumn<String>(
      'timer_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('completed'));
  static const VerificationMeta _startedAtMeta =
      const VerificationMeta('startedAt');
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
      'started_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _endedAtMeta =
      const VerificationMeta('endedAt');
  @override
  late final GeneratedColumn<DateTime> endedAt = GeneratedColumn<DateTime>(
      'ended_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _totalWorkSecondsMeta =
      const VerificationMeta('totalWorkSeconds');
  @override
  late final GeneratedColumn<int> totalWorkSeconds = GeneratedColumn<int>(
      'total_work_seconds', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _totalBreakSecondsMeta =
      const VerificationMeta('totalBreakSeconds');
  @override
  late final GeneratedColumn<int> totalBreakSeconds = GeneratedColumn<int>(
      'total_break_seconds', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _pomodoroRoundsCompletedMeta =
      const VerificationMeta('pomodoroRoundsCompleted');
  @override
  late final GeneratedColumn<int> pomodoroRoundsCompleted =
      GeneratedColumn<int>('pomodoro_rounds_completed', aliasedName, false,
          type: DriftSqlType.int,
          requiredDuringInsert: false,
          defaultValue: const Constant(0));
  static const VerificationMeta _deepWorkPauseSecondsMeta =
      const VerificationMeta('deepWorkPauseSeconds');
  @override
  late final GeneratedColumn<int> deepWorkPauseSeconds = GeneratedColumn<int>(
      'deep_work_pause_seconds', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        cardId,
        timerType,
        status,
        startedAt,
        endedAt,
        totalWorkSeconds,
        totalBreakSeconds,
        pomodoroRoundsCompleted,
        deepWorkPauseSeconds,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sessions';
  @override
  VerificationContext validateIntegrity(Insertable<SessionData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('card_id')) {
      context.handle(_cardIdMeta,
          cardId.isAcceptableOrUnknown(data['card_id']!, _cardIdMeta));
    } else if (isInserting) {
      context.missing(_cardIdMeta);
    }
    if (data.containsKey('timer_type')) {
      context.handle(_timerTypeMeta,
          timerType.isAcceptableOrUnknown(data['timer_type']!, _timerTypeMeta));
    } else if (isInserting) {
      context.missing(_timerTypeMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('started_at')) {
      context.handle(_startedAtMeta,
          startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta));
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('ended_at')) {
      context.handle(_endedAtMeta,
          endedAt.isAcceptableOrUnknown(data['ended_at']!, _endedAtMeta));
    } else if (isInserting) {
      context.missing(_endedAtMeta);
    }
    if (data.containsKey('total_work_seconds')) {
      context.handle(
          _totalWorkSecondsMeta,
          totalWorkSeconds.isAcceptableOrUnknown(
              data['total_work_seconds']!, _totalWorkSecondsMeta));
    }
    if (data.containsKey('total_break_seconds')) {
      context.handle(
          _totalBreakSecondsMeta,
          totalBreakSeconds.isAcceptableOrUnknown(
              data['total_break_seconds']!, _totalBreakSecondsMeta));
    }
    if (data.containsKey('pomodoro_rounds_completed')) {
      context.handle(
          _pomodoroRoundsCompletedMeta,
          pomodoroRoundsCompleted.isAcceptableOrUnknown(
              data['pomodoro_rounds_completed']!,
              _pomodoroRoundsCompletedMeta));
    }
    if (data.containsKey('deep_work_pause_seconds')) {
      context.handle(
          _deepWorkPauseSecondsMeta,
          deepWorkPauseSeconds.isAcceptableOrUnknown(
              data['deep_work_pause_seconds']!, _deepWorkPauseSecondsMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SessionData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SessionData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      cardId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}card_id'])!,
      timerType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}timer_type'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      startedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}started_at'])!,
      endedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}ended_at'])!,
      totalWorkSeconds: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}total_work_seconds'])!,
      totalBreakSeconds: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}total_break_seconds'])!,
      pomodoroRoundsCompleted: attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}pomodoro_rounds_completed'])!,
      deepWorkPauseSeconds: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}deep_work_pause_seconds'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $SessionsTable createAlias(String alias) {
    return $SessionsTable(attachedDatabase, alias);
  }
}

class SessionData extends DataClass implements Insertable<SessionData> {
  final int id;
  final int cardId;
  final String timerType;
  final String status;
  final DateTime startedAt;
  final DateTime endedAt;
  final int totalWorkSeconds;
  final int totalBreakSeconds;
  final int pomodoroRoundsCompleted;
  final int deepWorkPauseSeconds;
  final DateTime createdAt;
  const SessionData(
      {required this.id,
      required this.cardId,
      required this.timerType,
      required this.status,
      required this.startedAt,
      required this.endedAt,
      required this.totalWorkSeconds,
      required this.totalBreakSeconds,
      required this.pomodoroRoundsCompleted,
      required this.deepWorkPauseSeconds,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['card_id'] = Variable<int>(cardId);
    map['timer_type'] = Variable<String>(timerType);
    map['status'] = Variable<String>(status);
    map['started_at'] = Variable<DateTime>(startedAt);
    map['ended_at'] = Variable<DateTime>(endedAt);
    map['total_work_seconds'] = Variable<int>(totalWorkSeconds);
    map['total_break_seconds'] = Variable<int>(totalBreakSeconds);
    map['pomodoro_rounds_completed'] = Variable<int>(pomodoroRoundsCompleted);
    map['deep_work_pause_seconds'] = Variable<int>(deepWorkPauseSeconds);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SessionsCompanion toCompanion(bool nullToAbsent) {
    return SessionsCompanion(
      id: Value(id),
      cardId: Value(cardId),
      timerType: Value(timerType),
      status: Value(status),
      startedAt: Value(startedAt),
      endedAt: Value(endedAt),
      totalWorkSeconds: Value(totalWorkSeconds),
      totalBreakSeconds: Value(totalBreakSeconds),
      pomodoroRoundsCompleted: Value(pomodoroRoundsCompleted),
      deepWorkPauseSeconds: Value(deepWorkPauseSeconds),
      createdAt: Value(createdAt),
    );
  }

  factory SessionData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SessionData(
      id: serializer.fromJson<int>(json['id']),
      cardId: serializer.fromJson<int>(json['cardId']),
      timerType: serializer.fromJson<String>(json['timerType']),
      status: serializer.fromJson<String>(json['status']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      endedAt: serializer.fromJson<DateTime>(json['endedAt']),
      totalWorkSeconds: serializer.fromJson<int>(json['totalWorkSeconds']),
      totalBreakSeconds: serializer.fromJson<int>(json['totalBreakSeconds']),
      pomodoroRoundsCompleted:
          serializer.fromJson<int>(json['pomodoroRoundsCompleted']),
      deepWorkPauseSeconds:
          serializer.fromJson<int>(json['deepWorkPauseSeconds']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'cardId': serializer.toJson<int>(cardId),
      'timerType': serializer.toJson<String>(timerType),
      'status': serializer.toJson<String>(status),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'endedAt': serializer.toJson<DateTime>(endedAt),
      'totalWorkSeconds': serializer.toJson<int>(totalWorkSeconds),
      'totalBreakSeconds': serializer.toJson<int>(totalBreakSeconds),
      'pomodoroRoundsCompleted':
          serializer.toJson<int>(pomodoroRoundsCompleted),
      'deepWorkPauseSeconds': serializer.toJson<int>(deepWorkPauseSeconds),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  SessionData copyWith(
          {int? id,
          int? cardId,
          String? timerType,
          String? status,
          DateTime? startedAt,
          DateTime? endedAt,
          int? totalWorkSeconds,
          int? totalBreakSeconds,
          int? pomodoroRoundsCompleted,
          int? deepWorkPauseSeconds,
          DateTime? createdAt}) =>
      SessionData(
        id: id ?? this.id,
        cardId: cardId ?? this.cardId,
        timerType: timerType ?? this.timerType,
        status: status ?? this.status,
        startedAt: startedAt ?? this.startedAt,
        endedAt: endedAt ?? this.endedAt,
        totalWorkSeconds: totalWorkSeconds ?? this.totalWorkSeconds,
        totalBreakSeconds: totalBreakSeconds ?? this.totalBreakSeconds,
        pomodoroRoundsCompleted:
            pomodoroRoundsCompleted ?? this.pomodoroRoundsCompleted,
        deepWorkPauseSeconds: deepWorkPauseSeconds ?? this.deepWorkPauseSeconds,
        createdAt: createdAt ?? this.createdAt,
      );
  SessionData copyWithCompanion(SessionsCompanion data) {
    return SessionData(
      id: data.id.present ? data.id.value : this.id,
      cardId: data.cardId.present ? data.cardId.value : this.cardId,
      timerType: data.timerType.present ? data.timerType.value : this.timerType,
      status: data.status.present ? data.status.value : this.status,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      endedAt: data.endedAt.present ? data.endedAt.value : this.endedAt,
      totalWorkSeconds: data.totalWorkSeconds.present
          ? data.totalWorkSeconds.value
          : this.totalWorkSeconds,
      totalBreakSeconds: data.totalBreakSeconds.present
          ? data.totalBreakSeconds.value
          : this.totalBreakSeconds,
      pomodoroRoundsCompleted: data.pomodoroRoundsCompleted.present
          ? data.pomodoroRoundsCompleted.value
          : this.pomodoroRoundsCompleted,
      deepWorkPauseSeconds: data.deepWorkPauseSeconds.present
          ? data.deepWorkPauseSeconds.value
          : this.deepWorkPauseSeconds,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SessionData(')
          ..write('id: $id, ')
          ..write('cardId: $cardId, ')
          ..write('timerType: $timerType, ')
          ..write('status: $status, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('totalWorkSeconds: $totalWorkSeconds, ')
          ..write('totalBreakSeconds: $totalBreakSeconds, ')
          ..write('pomodoroRoundsCompleted: $pomodoroRoundsCompleted, ')
          ..write('deepWorkPauseSeconds: $deepWorkPauseSeconds, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      cardId,
      timerType,
      status,
      startedAt,
      endedAt,
      totalWorkSeconds,
      totalBreakSeconds,
      pomodoroRoundsCompleted,
      deepWorkPauseSeconds,
      createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SessionData &&
          other.id == this.id &&
          other.cardId == this.cardId &&
          other.timerType == this.timerType &&
          other.status == this.status &&
          other.startedAt == this.startedAt &&
          other.endedAt == this.endedAt &&
          other.totalWorkSeconds == this.totalWorkSeconds &&
          other.totalBreakSeconds == this.totalBreakSeconds &&
          other.pomodoroRoundsCompleted == this.pomodoroRoundsCompleted &&
          other.deepWorkPauseSeconds == this.deepWorkPauseSeconds &&
          other.createdAt == this.createdAt);
}

class SessionsCompanion extends UpdateCompanion<SessionData> {
  final Value<int> id;
  final Value<int> cardId;
  final Value<String> timerType;
  final Value<String> status;
  final Value<DateTime> startedAt;
  final Value<DateTime> endedAt;
  final Value<int> totalWorkSeconds;
  final Value<int> totalBreakSeconds;
  final Value<int> pomodoroRoundsCompleted;
  final Value<int> deepWorkPauseSeconds;
  final Value<DateTime> createdAt;
  const SessionsCompanion({
    this.id = const Value.absent(),
    this.cardId = const Value.absent(),
    this.timerType = const Value.absent(),
    this.status = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.endedAt = const Value.absent(),
    this.totalWorkSeconds = const Value.absent(),
    this.totalBreakSeconds = const Value.absent(),
    this.pomodoroRoundsCompleted = const Value.absent(),
    this.deepWorkPauseSeconds = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  SessionsCompanion.insert({
    this.id = const Value.absent(),
    required int cardId,
    required String timerType,
    this.status = const Value.absent(),
    required DateTime startedAt,
    required DateTime endedAt,
    this.totalWorkSeconds = const Value.absent(),
    this.totalBreakSeconds = const Value.absent(),
    this.pomodoroRoundsCompleted = const Value.absent(),
    this.deepWorkPauseSeconds = const Value.absent(),
    required DateTime createdAt,
  })  : cardId = Value(cardId),
        timerType = Value(timerType),
        startedAt = Value(startedAt),
        endedAt = Value(endedAt),
        createdAt = Value(createdAt);
  static Insertable<SessionData> custom({
    Expression<int>? id,
    Expression<int>? cardId,
    Expression<String>? timerType,
    Expression<String>? status,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? endedAt,
    Expression<int>? totalWorkSeconds,
    Expression<int>? totalBreakSeconds,
    Expression<int>? pomodoroRoundsCompleted,
    Expression<int>? deepWorkPauseSeconds,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (cardId != null) 'card_id': cardId,
      if (timerType != null) 'timer_type': timerType,
      if (status != null) 'status': status,
      if (startedAt != null) 'started_at': startedAt,
      if (endedAt != null) 'ended_at': endedAt,
      if (totalWorkSeconds != null) 'total_work_seconds': totalWorkSeconds,
      if (totalBreakSeconds != null) 'total_break_seconds': totalBreakSeconds,
      if (pomodoroRoundsCompleted != null)
        'pomodoro_rounds_completed': pomodoroRoundsCompleted,
      if (deepWorkPauseSeconds != null)
        'deep_work_pause_seconds': deepWorkPauseSeconds,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  SessionsCompanion copyWith(
      {Value<int>? id,
      Value<int>? cardId,
      Value<String>? timerType,
      Value<String>? status,
      Value<DateTime>? startedAt,
      Value<DateTime>? endedAt,
      Value<int>? totalWorkSeconds,
      Value<int>? totalBreakSeconds,
      Value<int>? pomodoroRoundsCompleted,
      Value<int>? deepWorkPauseSeconds,
      Value<DateTime>? createdAt}) {
    return SessionsCompanion(
      id: id ?? this.id,
      cardId: cardId ?? this.cardId,
      timerType: timerType ?? this.timerType,
      status: status ?? this.status,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      totalWorkSeconds: totalWorkSeconds ?? this.totalWorkSeconds,
      totalBreakSeconds: totalBreakSeconds ?? this.totalBreakSeconds,
      pomodoroRoundsCompleted:
          pomodoroRoundsCompleted ?? this.pomodoroRoundsCompleted,
      deepWorkPauseSeconds: deepWorkPauseSeconds ?? this.deepWorkPauseSeconds,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (cardId.present) {
      map['card_id'] = Variable<int>(cardId.value);
    }
    if (timerType.present) {
      map['timer_type'] = Variable<String>(timerType.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (endedAt.present) {
      map['ended_at'] = Variable<DateTime>(endedAt.value);
    }
    if (totalWorkSeconds.present) {
      map['total_work_seconds'] = Variable<int>(totalWorkSeconds.value);
    }
    if (totalBreakSeconds.present) {
      map['total_break_seconds'] = Variable<int>(totalBreakSeconds.value);
    }
    if (pomodoroRoundsCompleted.present) {
      map['pomodoro_rounds_completed'] =
          Variable<int>(pomodoroRoundsCompleted.value);
    }
    if (deepWorkPauseSeconds.present) {
      map['deep_work_pause_seconds'] =
          Variable<int>(deepWorkPauseSeconds.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SessionsCompanion(')
          ..write('id: $id, ')
          ..write('cardId: $cardId, ')
          ..write('timerType: $timerType, ')
          ..write('status: $status, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('totalWorkSeconds: $totalWorkSeconds, ')
          ..write('totalBreakSeconds: $totalBreakSeconds, ')
          ..write('pomodoroRoundsCompleted: $pomodoroRoundsCompleted, ')
          ..write('deepWorkPauseSeconds: $deepWorkPauseSeconds, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CardsTable cards = $CardsTable(this);
  late final $SessionsTable sessions = $SessionsTable(this);
  late final CardDao cardDao = CardDao(this as AppDatabase);
  late final SessionDao sessionDao = SessionDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [cards, sessions];
}

typedef $$CardsTableCreateCompanionBuilder = CardsCompanion Function({
  Value<int> id,
  required String name,
  Value<String> colorHex,
  required String type,
  Value<int> position,
  Value<String> status,
  required DateTime createdAt,
  required DateTime updatedAt,
});
typedef $$CardsTableUpdateCompanionBuilder = CardsCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String> colorHex,
  Value<String> type,
  Value<int> position,
  Value<String> status,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

final class $$CardsTableReferences
    extends BaseReferences<_$AppDatabase, $CardsTable, CardData> {
  $$CardsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$SessionsTable, List<SessionData>>
      _sessionsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.sessions,
              aliasName: $_aliasNameGenerator(db.cards.id, db.sessions.cardId));

  $$SessionsTableProcessedTableManager get sessionsRefs {
    final manager = $$SessionsTableTableManager($_db, $_db.sessions)
        .filter((f) => f.cardId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_sessionsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$CardsTableFilterComposer extends Composer<_$AppDatabase, $CardsTable> {
  $$CardsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get colorHex => $composableBuilder(
      column: $table.colorHex, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get position => $composableBuilder(
      column: $table.position, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  Expression<bool> sessionsRefs(
      Expression<bool> Function($$SessionsTableFilterComposer f) f) {
    final $$SessionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.sessions,
        getReferencedColumn: (t) => t.cardId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SessionsTableFilterComposer(
              $db: $db,
              $table: $db.sessions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$CardsTableOrderingComposer
    extends Composer<_$AppDatabase, $CardsTable> {
  $$CardsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get colorHex => $composableBuilder(
      column: $table.colorHex, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get position => $composableBuilder(
      column: $table.position, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$CardsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CardsTable> {
  $$CardsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get colorHex =>
      $composableBuilder(column: $table.colorHex, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> sessionsRefs<T extends Object>(
      Expression<T> Function($$SessionsTableAnnotationComposer a) f) {
    final $$SessionsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.sessions,
        getReferencedColumn: (t) => t.cardId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SessionsTableAnnotationComposer(
              $db: $db,
              $table: $db.sessions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$CardsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CardsTable,
    CardData,
    $$CardsTableFilterComposer,
    $$CardsTableOrderingComposer,
    $$CardsTableAnnotationComposer,
    $$CardsTableCreateCompanionBuilder,
    $$CardsTableUpdateCompanionBuilder,
    (CardData, $$CardsTableReferences),
    CardData,
    PrefetchHooks Function({bool sessionsRefs})> {
  $$CardsTableTableManager(_$AppDatabase db, $CardsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CardsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CardsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CardsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> colorHex = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<int> position = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              CardsCompanion(
            id: id,
            name: name,
            colorHex: colorHex,
            type: type,
            position: position,
            status: status,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<String> colorHex = const Value.absent(),
            required String type,
            Value<int> position = const Value.absent(),
            Value<String> status = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
          }) =>
              CardsCompanion.insert(
            id: id,
            name: name,
            colorHex: colorHex,
            type: type,
            position: position,
            status: status,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$CardsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({sessionsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (sessionsRefs) db.sessions],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (sessionsRefs)
                    await $_getPrefetchedData<CardData, $CardsTable,
                            SessionData>(
                        currentTable: table,
                        referencedTable:
                            $$CardsTableReferences._sessionsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$CardsTableReferences(db, table, p0).sessionsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.cardId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$CardsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CardsTable,
    CardData,
    $$CardsTableFilterComposer,
    $$CardsTableOrderingComposer,
    $$CardsTableAnnotationComposer,
    $$CardsTableCreateCompanionBuilder,
    $$CardsTableUpdateCompanionBuilder,
    (CardData, $$CardsTableReferences),
    CardData,
    PrefetchHooks Function({bool sessionsRefs})>;
typedef $$SessionsTableCreateCompanionBuilder = SessionsCompanion Function({
  Value<int> id,
  required int cardId,
  required String timerType,
  Value<String> status,
  required DateTime startedAt,
  required DateTime endedAt,
  Value<int> totalWorkSeconds,
  Value<int> totalBreakSeconds,
  Value<int> pomodoroRoundsCompleted,
  Value<int> deepWorkPauseSeconds,
  required DateTime createdAt,
});
typedef $$SessionsTableUpdateCompanionBuilder = SessionsCompanion Function({
  Value<int> id,
  Value<int> cardId,
  Value<String> timerType,
  Value<String> status,
  Value<DateTime> startedAt,
  Value<DateTime> endedAt,
  Value<int> totalWorkSeconds,
  Value<int> totalBreakSeconds,
  Value<int> pomodoroRoundsCompleted,
  Value<int> deepWorkPauseSeconds,
  Value<DateTime> createdAt,
});

final class $$SessionsTableReferences
    extends BaseReferences<_$AppDatabase, $SessionsTable, SessionData> {
  $$SessionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CardsTable _cardIdTable(_$AppDatabase db) => db.cards
      .createAlias($_aliasNameGenerator(db.sessions.cardId, db.cards.id));

  $$CardsTableProcessedTableManager get cardId {
    final $_column = $_itemColumn<int>('card_id')!;

    final manager = $$CardsTableTableManager($_db, $_db.cards)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_cardIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$SessionsTableFilterComposer
    extends Composer<_$AppDatabase, $SessionsTable> {
  $$SessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get timerType => $composableBuilder(
      column: $table.timerType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
      column: $table.startedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get endedAt => $composableBuilder(
      column: $table.endedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get totalWorkSeconds => $composableBuilder(
      column: $table.totalWorkSeconds,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get totalBreakSeconds => $composableBuilder(
      column: $table.totalBreakSeconds,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get pomodoroRoundsCompleted => $composableBuilder(
      column: $table.pomodoroRoundsCompleted,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get deepWorkPauseSeconds => $composableBuilder(
      column: $table.deepWorkPauseSeconds,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$CardsTableFilterComposer get cardId {
    final $$CardsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.cardId,
        referencedTable: $db.cards,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CardsTableFilterComposer(
              $db: $db,
              $table: $db.cards,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $SessionsTable> {
  $$SessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get timerType => $composableBuilder(
      column: $table.timerType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
      column: $table.startedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get endedAt => $composableBuilder(
      column: $table.endedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get totalWorkSeconds => $composableBuilder(
      column: $table.totalWorkSeconds,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get totalBreakSeconds => $composableBuilder(
      column: $table.totalBreakSeconds,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get pomodoroRoundsCompleted => $composableBuilder(
      column: $table.pomodoroRoundsCompleted,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get deepWorkPauseSeconds => $composableBuilder(
      column: $table.deepWorkPauseSeconds,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$CardsTableOrderingComposer get cardId {
    final $$CardsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.cardId,
        referencedTable: $db.cards,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CardsTableOrderingComposer(
              $db: $db,
              $table: $db.cards,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SessionsTable> {
  $$SessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get timerType =>
      $composableBuilder(column: $table.timerType, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get endedAt =>
      $composableBuilder(column: $table.endedAt, builder: (column) => column);

  GeneratedColumn<int> get totalWorkSeconds => $composableBuilder(
      column: $table.totalWorkSeconds, builder: (column) => column);

  GeneratedColumn<int> get totalBreakSeconds => $composableBuilder(
      column: $table.totalBreakSeconds, builder: (column) => column);

  GeneratedColumn<int> get pomodoroRoundsCompleted => $composableBuilder(
      column: $table.pomodoroRoundsCompleted, builder: (column) => column);

  GeneratedColumn<int> get deepWorkPauseSeconds => $composableBuilder(
      column: $table.deepWorkPauseSeconds, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$CardsTableAnnotationComposer get cardId {
    final $$CardsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.cardId,
        referencedTable: $db.cards,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CardsTableAnnotationComposer(
              $db: $db,
              $table: $db.cards,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SessionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SessionsTable,
    SessionData,
    $$SessionsTableFilterComposer,
    $$SessionsTableOrderingComposer,
    $$SessionsTableAnnotationComposer,
    $$SessionsTableCreateCompanionBuilder,
    $$SessionsTableUpdateCompanionBuilder,
    (SessionData, $$SessionsTableReferences),
    SessionData,
    PrefetchHooks Function({bool cardId})> {
  $$SessionsTableTableManager(_$AppDatabase db, $SessionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> cardId = const Value.absent(),
            Value<String> timerType = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<DateTime> startedAt = const Value.absent(),
            Value<DateTime> endedAt = const Value.absent(),
            Value<int> totalWorkSeconds = const Value.absent(),
            Value<int> totalBreakSeconds = const Value.absent(),
            Value<int> pomodoroRoundsCompleted = const Value.absent(),
            Value<int> deepWorkPauseSeconds = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              SessionsCompanion(
            id: id,
            cardId: cardId,
            timerType: timerType,
            status: status,
            startedAt: startedAt,
            endedAt: endedAt,
            totalWorkSeconds: totalWorkSeconds,
            totalBreakSeconds: totalBreakSeconds,
            pomodoroRoundsCompleted: pomodoroRoundsCompleted,
            deepWorkPauseSeconds: deepWorkPauseSeconds,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int cardId,
            required String timerType,
            Value<String> status = const Value.absent(),
            required DateTime startedAt,
            required DateTime endedAt,
            Value<int> totalWorkSeconds = const Value.absent(),
            Value<int> totalBreakSeconds = const Value.absent(),
            Value<int> pomodoroRoundsCompleted = const Value.absent(),
            Value<int> deepWorkPauseSeconds = const Value.absent(),
            required DateTime createdAt,
          }) =>
              SessionsCompanion.insert(
            id: id,
            cardId: cardId,
            timerType: timerType,
            status: status,
            startedAt: startedAt,
            endedAt: endedAt,
            totalWorkSeconds: totalWorkSeconds,
            totalBreakSeconds: totalBreakSeconds,
            pomodoroRoundsCompleted: pomodoroRoundsCompleted,
            deepWorkPauseSeconds: deepWorkPauseSeconds,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$SessionsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({cardId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (cardId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.cardId,
                    referencedTable: $$SessionsTableReferences._cardIdTable(db),
                    referencedColumn:
                        $$SessionsTableReferences._cardIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$SessionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SessionsTable,
    SessionData,
    $$SessionsTableFilterComposer,
    $$SessionsTableOrderingComposer,
    $$SessionsTableAnnotationComposer,
    $$SessionsTableCreateCompanionBuilder,
    $$SessionsTableUpdateCompanionBuilder,
    (SessionData, $$SessionsTableReferences),
    SessionData,
    PrefetchHooks Function({bool cardId})>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CardsTableTableManager get cards =>
      $$CardsTableTableManager(_db, _db.cards);
  $$SessionsTableTableManager get sessions =>
      $$SessionsTableTableManager(_db, _db.sessions);
}
