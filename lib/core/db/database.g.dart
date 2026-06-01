// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $OrdersTable extends Orders with TableInfo<$OrdersTable, Order> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OrdersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _orderNumberMeta = const VerificationMeta(
    'orderNumber',
  );
  @override
  late final GeneratedColumn<String> orderNumber = GeneratedColumn<String>(
    'order_number',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _paymentTypeMeta = const VerificationMeta(
    'paymentType',
  );
  @override
  late final GeneratedColumn<String> paymentType = GeneratedColumn<String>(
    'payment_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('online'),
  );
  static const VerificationMeta _orderValueMeta = const VerificationMeta(
    'orderValue',
  );
  @override
  late final GeneratedColumn<double> orderValue = GeneratedColumn<double>(
    'order_value',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _paymentAmountMeta = const VerificationMeta(
    'paymentAmount',
  );
  @override
  late final GeneratedColumn<double> paymentAmount = GeneratedColumn<double>(
    'payment_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _changeReturnedMeta = const VerificationMeta(
    'changeReturned',
  );
  @override
  late final GeneratedColumn<double> changeReturned = GeneratedColumn<double>(
    'change_returned',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _extraCashTipMeta = const VerificationMeta(
    'extraCashTip',
  );
  @override
  late final GeneratedColumn<double> extraCashTip = GeneratedColumn<double>(
    'extra_cash_tip',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _distanceKmMeta = const VerificationMeta(
    'distanceKm',
  );
  @override
  late final GeneratedColumn<double> distanceKm = GeneratedColumn<double>(
    'distance_km',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    date,
    orderNumber,
    paymentType,
    orderValue,
    paymentAmount,
    changeReturned,
    extraCashTip,
    distanceKm,
    address,
    notes,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'orders';
  @override
  VerificationContext validateIntegrity(
    Insertable<Order> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('order_number')) {
      context.handle(
        _orderNumberMeta,
        orderNumber.isAcceptableOrUnknown(
          data['order_number']!,
          _orderNumberMeta,
        ),
      );
    }
    if (data.containsKey('payment_type')) {
      context.handle(
        _paymentTypeMeta,
        paymentType.isAcceptableOrUnknown(
          data['payment_type']!,
          _paymentTypeMeta,
        ),
      );
    }
    if (data.containsKey('order_value')) {
      context.handle(
        _orderValueMeta,
        orderValue.isAcceptableOrUnknown(data['order_value']!, _orderValueMeta),
      );
    }
    if (data.containsKey('payment_amount')) {
      context.handle(
        _paymentAmountMeta,
        paymentAmount.isAcceptableOrUnknown(
          data['payment_amount']!,
          _paymentAmountMeta,
        ),
      );
    }
    if (data.containsKey('change_returned')) {
      context.handle(
        _changeReturnedMeta,
        changeReturned.isAcceptableOrUnknown(
          data['change_returned']!,
          _changeReturnedMeta,
        ),
      );
    }
    if (data.containsKey('extra_cash_tip')) {
      context.handle(
        _extraCashTipMeta,
        extraCashTip.isAcceptableOrUnknown(
          data['extra_cash_tip']!,
          _extraCashTipMeta,
        ),
      );
    }
    if (data.containsKey('distance_km')) {
      context.handle(
        _distanceKmMeta,
        distanceKm.isAcceptableOrUnknown(data['distance_km']!, _distanceKmMeta),
      );
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Order map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Order(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      date:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}date'],
          )!,
      orderNumber:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}order_number'],
          )!,
      paymentType:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}payment_type'],
          )!,
      orderValue:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}order_value'],
          )!,
      paymentAmount:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}payment_amount'],
          )!,
      changeReturned:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}change_returned'],
          )!,
      extraCashTip:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}extra_cash_tip'],
          )!,
      distanceKm:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}distance_km'],
          )!,
      address:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}address'],
          )!,
      notes:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}notes'],
          )!,
      createdAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}created_at'],
          )!,
      updatedAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}updated_at'],
          )!,
    );
  }

  @override
  $OrdersTable createAlias(String alias) {
    return $OrdersTable(attachedDatabase, alias);
  }
}

class Order extends DataClass implements Insertable<Order> {
  final int id;

  /// 'YYYY-MM-DD'
  final String date;
  final String orderNumber;

  /// online | cash | card | mixed
  final String paymentType;
  final double orderValue;
  final double paymentAmount;
  final double changeReturned;
  final double extraCashTip;
  final double distanceKm;
  final String address;
  final String notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Order({
    required this.id,
    required this.date,
    required this.orderNumber,
    required this.paymentType,
    required this.orderValue,
    required this.paymentAmount,
    required this.changeReturned,
    required this.extraCashTip,
    required this.distanceKm,
    required this.address,
    required this.notes,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<String>(date);
    map['order_number'] = Variable<String>(orderNumber);
    map['payment_type'] = Variable<String>(paymentType);
    map['order_value'] = Variable<double>(orderValue);
    map['payment_amount'] = Variable<double>(paymentAmount);
    map['change_returned'] = Variable<double>(changeReturned);
    map['extra_cash_tip'] = Variable<double>(extraCashTip);
    map['distance_km'] = Variable<double>(distanceKm);
    map['address'] = Variable<String>(address);
    map['notes'] = Variable<String>(notes);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  OrdersCompanion toCompanion(bool nullToAbsent) {
    return OrdersCompanion(
      id: Value(id),
      date: Value(date),
      orderNumber: Value(orderNumber),
      paymentType: Value(paymentType),
      orderValue: Value(orderValue),
      paymentAmount: Value(paymentAmount),
      changeReturned: Value(changeReturned),
      extraCashTip: Value(extraCashTip),
      distanceKm: Value(distanceKm),
      address: Value(address),
      notes: Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Order.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Order(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<String>(json['date']),
      orderNumber: serializer.fromJson<String>(json['orderNumber']),
      paymentType: serializer.fromJson<String>(json['paymentType']),
      orderValue: serializer.fromJson<double>(json['orderValue']),
      paymentAmount: serializer.fromJson<double>(json['paymentAmount']),
      changeReturned: serializer.fromJson<double>(json['changeReturned']),
      extraCashTip: serializer.fromJson<double>(json['extraCashTip']),
      distanceKm: serializer.fromJson<double>(json['distanceKm']),
      address: serializer.fromJson<String>(json['address']),
      notes: serializer.fromJson<String>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<String>(date),
      'orderNumber': serializer.toJson<String>(orderNumber),
      'paymentType': serializer.toJson<String>(paymentType),
      'orderValue': serializer.toJson<double>(orderValue),
      'paymentAmount': serializer.toJson<double>(paymentAmount),
      'changeReturned': serializer.toJson<double>(changeReturned),
      'extraCashTip': serializer.toJson<double>(extraCashTip),
      'distanceKm': serializer.toJson<double>(distanceKm),
      'address': serializer.toJson<String>(address),
      'notes': serializer.toJson<String>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Order copyWith({
    int? id,
    String? date,
    String? orderNumber,
    String? paymentType,
    double? orderValue,
    double? paymentAmount,
    double? changeReturned,
    double? extraCashTip,
    double? distanceKm,
    String? address,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Order(
    id: id ?? this.id,
    date: date ?? this.date,
    orderNumber: orderNumber ?? this.orderNumber,
    paymentType: paymentType ?? this.paymentType,
    orderValue: orderValue ?? this.orderValue,
    paymentAmount: paymentAmount ?? this.paymentAmount,
    changeReturned: changeReturned ?? this.changeReturned,
    extraCashTip: extraCashTip ?? this.extraCashTip,
    distanceKm: distanceKm ?? this.distanceKm,
    address: address ?? this.address,
    notes: notes ?? this.notes,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Order copyWithCompanion(OrdersCompanion data) {
    return Order(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      orderNumber:
          data.orderNumber.present ? data.orderNumber.value : this.orderNumber,
      paymentType:
          data.paymentType.present ? data.paymentType.value : this.paymentType,
      orderValue:
          data.orderValue.present ? data.orderValue.value : this.orderValue,
      paymentAmount:
          data.paymentAmount.present
              ? data.paymentAmount.value
              : this.paymentAmount,
      changeReturned:
          data.changeReturned.present
              ? data.changeReturned.value
              : this.changeReturned,
      extraCashTip:
          data.extraCashTip.present
              ? data.extraCashTip.value
              : this.extraCashTip,
      distanceKm:
          data.distanceKm.present ? data.distanceKm.value : this.distanceKm,
      address: data.address.present ? data.address.value : this.address,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Order(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('orderNumber: $orderNumber, ')
          ..write('paymentType: $paymentType, ')
          ..write('orderValue: $orderValue, ')
          ..write('paymentAmount: $paymentAmount, ')
          ..write('changeReturned: $changeReturned, ')
          ..write('extraCashTip: $extraCashTip, ')
          ..write('distanceKm: $distanceKm, ')
          ..write('address: $address, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    date,
    orderNumber,
    paymentType,
    orderValue,
    paymentAmount,
    changeReturned,
    extraCashTip,
    distanceKm,
    address,
    notes,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Order &&
          other.id == this.id &&
          other.date == this.date &&
          other.orderNumber == this.orderNumber &&
          other.paymentType == this.paymentType &&
          other.orderValue == this.orderValue &&
          other.paymentAmount == this.paymentAmount &&
          other.changeReturned == this.changeReturned &&
          other.extraCashTip == this.extraCashTip &&
          other.distanceKm == this.distanceKm &&
          other.address == this.address &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class OrdersCompanion extends UpdateCompanion<Order> {
  final Value<int> id;
  final Value<String> date;
  final Value<String> orderNumber;
  final Value<String> paymentType;
  final Value<double> orderValue;
  final Value<double> paymentAmount;
  final Value<double> changeReturned;
  final Value<double> extraCashTip;
  final Value<double> distanceKm;
  final Value<String> address;
  final Value<String> notes;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const OrdersCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.orderNumber = const Value.absent(),
    this.paymentType = const Value.absent(),
    this.orderValue = const Value.absent(),
    this.paymentAmount = const Value.absent(),
    this.changeReturned = const Value.absent(),
    this.extraCashTip = const Value.absent(),
    this.distanceKm = const Value.absent(),
    this.address = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  OrdersCompanion.insert({
    this.id = const Value.absent(),
    required String date,
    this.orderNumber = const Value.absent(),
    this.paymentType = const Value.absent(),
    this.orderValue = const Value.absent(),
    this.paymentAmount = const Value.absent(),
    this.changeReturned = const Value.absent(),
    this.extraCashTip = const Value.absent(),
    this.distanceKm = const Value.absent(),
    this.address = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : date = Value(date);
  static Insertable<Order> custom({
    Expression<int>? id,
    Expression<String>? date,
    Expression<String>? orderNumber,
    Expression<String>? paymentType,
    Expression<double>? orderValue,
    Expression<double>? paymentAmount,
    Expression<double>? changeReturned,
    Expression<double>? extraCashTip,
    Expression<double>? distanceKm,
    Expression<String>? address,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (orderNumber != null) 'order_number': orderNumber,
      if (paymentType != null) 'payment_type': paymentType,
      if (orderValue != null) 'order_value': orderValue,
      if (paymentAmount != null) 'payment_amount': paymentAmount,
      if (changeReturned != null) 'change_returned': changeReturned,
      if (extraCashTip != null) 'extra_cash_tip': extraCashTip,
      if (distanceKm != null) 'distance_km': distanceKm,
      if (address != null) 'address': address,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  OrdersCompanion copyWith({
    Value<int>? id,
    Value<String>? date,
    Value<String>? orderNumber,
    Value<String>? paymentType,
    Value<double>? orderValue,
    Value<double>? paymentAmount,
    Value<double>? changeReturned,
    Value<double>? extraCashTip,
    Value<double>? distanceKm,
    Value<String>? address,
    Value<String>? notes,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return OrdersCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      orderNumber: orderNumber ?? this.orderNumber,
      paymentType: paymentType ?? this.paymentType,
      orderValue: orderValue ?? this.orderValue,
      paymentAmount: paymentAmount ?? this.paymentAmount,
      changeReturned: changeReturned ?? this.changeReturned,
      extraCashTip: extraCashTip ?? this.extraCashTip,
      distanceKm: distanceKm ?? this.distanceKm,
      address: address ?? this.address,
      notes: notes ?? this.notes,
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
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (orderNumber.present) {
      map['order_number'] = Variable<String>(orderNumber.value);
    }
    if (paymentType.present) {
      map['payment_type'] = Variable<String>(paymentType.value);
    }
    if (orderValue.present) {
      map['order_value'] = Variable<double>(orderValue.value);
    }
    if (paymentAmount.present) {
      map['payment_amount'] = Variable<double>(paymentAmount.value);
    }
    if (changeReturned.present) {
      map['change_returned'] = Variable<double>(changeReturned.value);
    }
    if (extraCashTip.present) {
      map['extra_cash_tip'] = Variable<double>(extraCashTip.value);
    }
    if (distanceKm.present) {
      map['distance_km'] = Variable<double>(distanceKm.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
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
    return (StringBuffer('OrdersCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('orderNumber: $orderNumber, ')
          ..write('paymentType: $paymentType, ')
          ..write('orderValue: $orderValue, ')
          ..write('paymentAmount: $paymentAmount, ')
          ..write('changeReturned: $changeReturned, ')
          ..write('extraCashTip: $extraCashTip, ')
          ..write('distanceKm: $distanceKm, ')
          ..write('address: $address, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $WorkTimesTable extends WorkTimes
    with TableInfo<$WorkTimesTable, WorkTime> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkTimesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _startTimeMeta = const VerificationMeta(
    'startTime',
  );
  @override
  late final GeneratedColumn<String> startTime = GeneratedColumn<String>(
    'start_time',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _endTimeMeta = const VerificationMeta(
    'endTime',
  );
  @override
  late final GeneratedColumn<String> endTime = GeneratedColumn<String>(
    'end_time',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _workHoursMeta = const VerificationMeta(
    'workHours',
  );
  @override
  late final GeneratedColumn<double> workHours = GeneratedColumn<double>(
    'work_hours',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    date,
    startTime,
    endTime,
    workHours,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'work_times';
  @override
  VerificationContext validateIntegrity(
    Insertable<WorkTime> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('start_time')) {
      context.handle(
        _startTimeMeta,
        startTime.isAcceptableOrUnknown(data['start_time']!, _startTimeMeta),
      );
    }
    if (data.containsKey('end_time')) {
      context.handle(
        _endTimeMeta,
        endTime.isAcceptableOrUnknown(data['end_time']!, _endTimeMeta),
      );
    }
    if (data.containsKey('work_hours')) {
      context.handle(
        _workHoursMeta,
        workHours.isAcceptableOrUnknown(data['work_hours']!, _workHoursMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkTime map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkTime(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      date:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}date'],
          )!,
      startTime:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}start_time'],
          )!,
      endTime:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}end_time'],
          )!,
      workHours:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}work_hours'],
          )!,
      updatedAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}updated_at'],
          )!,
    );
  }

  @override
  $WorkTimesTable createAlias(String alias) {
    return $WorkTimesTable(attachedDatabase, alias);
  }
}

class WorkTime extends DataClass implements Insertable<WorkTime> {
  final int id;
  final String date;
  final String startTime;
  final String endTime;
  final double workHours;
  final DateTime updatedAt;
  const WorkTime({
    required this.id,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.workHours,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<String>(date);
    map['start_time'] = Variable<String>(startTime);
    map['end_time'] = Variable<String>(endTime);
    map['work_hours'] = Variable<double>(workHours);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  WorkTimesCompanion toCompanion(bool nullToAbsent) {
    return WorkTimesCompanion(
      id: Value(id),
      date: Value(date),
      startTime: Value(startTime),
      endTime: Value(endTime),
      workHours: Value(workHours),
      updatedAt: Value(updatedAt),
    );
  }

  factory WorkTime.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkTime(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<String>(json['date']),
      startTime: serializer.fromJson<String>(json['startTime']),
      endTime: serializer.fromJson<String>(json['endTime']),
      workHours: serializer.fromJson<double>(json['workHours']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<String>(date),
      'startTime': serializer.toJson<String>(startTime),
      'endTime': serializer.toJson<String>(endTime),
      'workHours': serializer.toJson<double>(workHours),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  WorkTime copyWith({
    int? id,
    String? date,
    String? startTime,
    String? endTime,
    double? workHours,
    DateTime? updatedAt,
  }) => WorkTime(
    id: id ?? this.id,
    date: date ?? this.date,
    startTime: startTime ?? this.startTime,
    endTime: endTime ?? this.endTime,
    workHours: workHours ?? this.workHours,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  WorkTime copyWithCompanion(WorkTimesCompanion data) {
    return WorkTime(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      startTime: data.startTime.present ? data.startTime.value : this.startTime,
      endTime: data.endTime.present ? data.endTime.value : this.endTime,
      workHours: data.workHours.present ? data.workHours.value : this.workHours,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkTime(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('workHours: $workHours, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, date, startTime, endTime, workHours, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkTime &&
          other.id == this.id &&
          other.date == this.date &&
          other.startTime == this.startTime &&
          other.endTime == this.endTime &&
          other.workHours == this.workHours &&
          other.updatedAt == this.updatedAt);
}

class WorkTimesCompanion extends UpdateCompanion<WorkTime> {
  final Value<int> id;
  final Value<String> date;
  final Value<String> startTime;
  final Value<String> endTime;
  final Value<double> workHours;
  final Value<DateTime> updatedAt;
  const WorkTimesCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.startTime = const Value.absent(),
    this.endTime = const Value.absent(),
    this.workHours = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  WorkTimesCompanion.insert({
    this.id = const Value.absent(),
    required String date,
    this.startTime = const Value.absent(),
    this.endTime = const Value.absent(),
    this.workHours = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : date = Value(date);
  static Insertable<WorkTime> custom({
    Expression<int>? id,
    Expression<String>? date,
    Expression<String>? startTime,
    Expression<String>? endTime,
    Expression<double>? workHours,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (startTime != null) 'start_time': startTime,
      if (endTime != null) 'end_time': endTime,
      if (workHours != null) 'work_hours': workHours,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  WorkTimesCompanion copyWith({
    Value<int>? id,
    Value<String>? date,
    Value<String>? startTime,
    Value<String>? endTime,
    Value<double>? workHours,
    Value<DateTime>? updatedAt,
  }) {
    return WorkTimesCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      workHours: workHours ?? this.workHours,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (startTime.present) {
      map['start_time'] = Variable<String>(startTime.value);
    }
    if (endTime.present) {
      map['end_time'] = Variable<String>(endTime.value);
    }
    if (workHours.present) {
      map['work_hours'] = Variable<double>(workHours.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkTimesCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('workHours: $workHours, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTable extends AppSettings
    with TableInfo<$AppSettingsTable, AppSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _baseHourlyRateMeta = const VerificationMeta(
    'baseHourlyRate',
  );
  @override
  late final GeneratedColumn<double> baseHourlyRate = GeneratedColumn<double>(
    'base_hourly_rate',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(8.5),
  );
  static const VerificationMeta _fuelPerOrderMeta = const VerificationMeta(
    'fuelPerOrder',
  );
  @override
  late final GeneratedColumn<double> fuelPerOrder = GeneratedColumn<double>(
    'fuel_per_order',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(3.5),
  );
  static const VerificationMeta _longTripThresholdKmMeta =
      const VerificationMeta('longTripThresholdKm');
  @override
  late final GeneratedColumn<double> longTripThresholdKm =
      GeneratedColumn<double>(
        'long_trip_threshold_km',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        defaultValue: const Constant(10),
      );
  static const VerificationMeta _longTripExtraFuelMeta = const VerificationMeta(
    'longTripExtraFuel',
  );
  @override
  late final GeneratedColumn<double> longTripExtraFuel =
      GeneratedColumn<double>(
        'long_trip_extra_fuel',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        defaultValue: const Constant(3.5),
      );
  static const VerificationMeta _biweeklySettlementDaysMeta =
      const VerificationMeta('biweeklySettlementDays');
  @override
  late final GeneratedColumn<int> biweeklySettlementDays = GeneratedColumn<int>(
    'biweekly_settlement_days',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(14),
  );
  static const VerificationMeta _biweeklyAnchorDateMeta =
      const VerificationMeta('biweeklyAnchorDate');
  @override
  late final GeneratedColumn<String> biweeklyAnchorDate =
      GeneratedColumn<String>(
        'biweekly_anchor_date',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('2026-04-20'),
      );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('CAD'),
  );
  static const VerificationMeta _localeMeta = const VerificationMeta('locale');
  @override
  late final GeneratedColumn<String> locale = GeneratedColumn<String>(
    'locale',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('zh'),
  );
  static const VerificationMeta _themeModeMeta = const VerificationMeta(
    'themeMode',
  );
  @override
  late final GeneratedColumn<String> themeMode = GeneratedColumn<String>(
    'theme_mode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('system'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    baseHourlyRate,
    fuelPerOrder,
    longTripThresholdKm,
    longTripExtraFuel,
    biweeklySettlementDays,
    biweeklyAnchorDate,
    currency,
    locale,
    themeMode,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('base_hourly_rate')) {
      context.handle(
        _baseHourlyRateMeta,
        baseHourlyRate.isAcceptableOrUnknown(
          data['base_hourly_rate']!,
          _baseHourlyRateMeta,
        ),
      );
    }
    if (data.containsKey('fuel_per_order')) {
      context.handle(
        _fuelPerOrderMeta,
        fuelPerOrder.isAcceptableOrUnknown(
          data['fuel_per_order']!,
          _fuelPerOrderMeta,
        ),
      );
    }
    if (data.containsKey('long_trip_threshold_km')) {
      context.handle(
        _longTripThresholdKmMeta,
        longTripThresholdKm.isAcceptableOrUnknown(
          data['long_trip_threshold_km']!,
          _longTripThresholdKmMeta,
        ),
      );
    }
    if (data.containsKey('long_trip_extra_fuel')) {
      context.handle(
        _longTripExtraFuelMeta,
        longTripExtraFuel.isAcceptableOrUnknown(
          data['long_trip_extra_fuel']!,
          _longTripExtraFuelMeta,
        ),
      );
    }
    if (data.containsKey('biweekly_settlement_days')) {
      context.handle(
        _biweeklySettlementDaysMeta,
        biweeklySettlementDays.isAcceptableOrUnknown(
          data['biweekly_settlement_days']!,
          _biweeklySettlementDaysMeta,
        ),
      );
    }
    if (data.containsKey('biweekly_anchor_date')) {
      context.handle(
        _biweeklyAnchorDateMeta,
        biweeklyAnchorDate.isAcceptableOrUnknown(
          data['biweekly_anchor_date']!,
          _biweeklyAnchorDateMeta,
        ),
      );
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    }
    if (data.containsKey('locale')) {
      context.handle(
        _localeMeta,
        locale.isAcceptableOrUnknown(data['locale']!, _localeMeta),
      );
    }
    if (data.containsKey('theme_mode')) {
      context.handle(
        _themeModeMeta,
        themeMode.isAcceptableOrUnknown(data['theme_mode']!, _themeModeMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AppSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSetting(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      baseHourlyRate:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}base_hourly_rate'],
          )!,
      fuelPerOrder:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}fuel_per_order'],
          )!,
      longTripThresholdKm:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}long_trip_threshold_km'],
          )!,
      longTripExtraFuel:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}long_trip_extra_fuel'],
          )!,
      biweeklySettlementDays:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}biweekly_settlement_days'],
          )!,
      biweeklyAnchorDate:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}biweekly_anchor_date'],
          )!,
      currency:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}currency'],
          )!,
      locale:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}locale'],
          )!,
      themeMode:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}theme_mode'],
          )!,
    );
  }

  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }
}

class AppSetting extends DataClass implements Insertable<AppSetting> {
  final int id;
  final double baseHourlyRate;
  final double fuelPerOrder;
  final double longTripThresholdKm;
  final double longTripExtraFuel;
  final int biweeklySettlementDays;
  final String biweeklyAnchorDate;
  final String currency;
  final String locale;
  final String themeMode;
  const AppSetting({
    required this.id,
    required this.baseHourlyRate,
    required this.fuelPerOrder,
    required this.longTripThresholdKm,
    required this.longTripExtraFuel,
    required this.biweeklySettlementDays,
    required this.biweeklyAnchorDate,
    required this.currency,
    required this.locale,
    required this.themeMode,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['base_hourly_rate'] = Variable<double>(baseHourlyRate);
    map['fuel_per_order'] = Variable<double>(fuelPerOrder);
    map['long_trip_threshold_km'] = Variable<double>(longTripThresholdKm);
    map['long_trip_extra_fuel'] = Variable<double>(longTripExtraFuel);
    map['biweekly_settlement_days'] = Variable<int>(biweeklySettlementDays);
    map['biweekly_anchor_date'] = Variable<String>(biweeklyAnchorDate);
    map['currency'] = Variable<String>(currency);
    map['locale'] = Variable<String>(locale);
    map['theme_mode'] = Variable<String>(themeMode);
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(
      id: Value(id),
      baseHourlyRate: Value(baseHourlyRate),
      fuelPerOrder: Value(fuelPerOrder),
      longTripThresholdKm: Value(longTripThresholdKm),
      longTripExtraFuel: Value(longTripExtraFuel),
      biweeklySettlementDays: Value(biweeklySettlementDays),
      biweeklyAnchorDate: Value(biweeklyAnchorDate),
      currency: Value(currency),
      locale: Value(locale),
      themeMode: Value(themeMode),
    );
  }

  factory AppSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSetting(
      id: serializer.fromJson<int>(json['id']),
      baseHourlyRate: serializer.fromJson<double>(json['baseHourlyRate']),
      fuelPerOrder: serializer.fromJson<double>(json['fuelPerOrder']),
      longTripThresholdKm: serializer.fromJson<double>(
        json['longTripThresholdKm'],
      ),
      longTripExtraFuel: serializer.fromJson<double>(json['longTripExtraFuel']),
      biweeklySettlementDays: serializer.fromJson<int>(
        json['biweeklySettlementDays'],
      ),
      biweeklyAnchorDate: serializer.fromJson<String>(
        json['biweeklyAnchorDate'],
      ),
      currency: serializer.fromJson<String>(json['currency']),
      locale: serializer.fromJson<String>(json['locale']),
      themeMode: serializer.fromJson<String>(json['themeMode']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'baseHourlyRate': serializer.toJson<double>(baseHourlyRate),
      'fuelPerOrder': serializer.toJson<double>(fuelPerOrder),
      'longTripThresholdKm': serializer.toJson<double>(longTripThresholdKm),
      'longTripExtraFuel': serializer.toJson<double>(longTripExtraFuel),
      'biweeklySettlementDays': serializer.toJson<int>(biweeklySettlementDays),
      'biweeklyAnchorDate': serializer.toJson<String>(biweeklyAnchorDate),
      'currency': serializer.toJson<String>(currency),
      'locale': serializer.toJson<String>(locale),
      'themeMode': serializer.toJson<String>(themeMode),
    };
  }

  AppSetting copyWith({
    int? id,
    double? baseHourlyRate,
    double? fuelPerOrder,
    double? longTripThresholdKm,
    double? longTripExtraFuel,
    int? biweeklySettlementDays,
    String? biweeklyAnchorDate,
    String? currency,
    String? locale,
    String? themeMode,
  }) => AppSetting(
    id: id ?? this.id,
    baseHourlyRate: baseHourlyRate ?? this.baseHourlyRate,
    fuelPerOrder: fuelPerOrder ?? this.fuelPerOrder,
    longTripThresholdKm: longTripThresholdKm ?? this.longTripThresholdKm,
    longTripExtraFuel: longTripExtraFuel ?? this.longTripExtraFuel,
    biweeklySettlementDays:
        biweeklySettlementDays ?? this.biweeklySettlementDays,
    biweeklyAnchorDate: biweeklyAnchorDate ?? this.biweeklyAnchorDate,
    currency: currency ?? this.currency,
    locale: locale ?? this.locale,
    themeMode: themeMode ?? this.themeMode,
  );
  AppSetting copyWithCompanion(AppSettingsCompanion data) {
    return AppSetting(
      id: data.id.present ? data.id.value : this.id,
      baseHourlyRate:
          data.baseHourlyRate.present
              ? data.baseHourlyRate.value
              : this.baseHourlyRate,
      fuelPerOrder:
          data.fuelPerOrder.present
              ? data.fuelPerOrder.value
              : this.fuelPerOrder,
      longTripThresholdKm:
          data.longTripThresholdKm.present
              ? data.longTripThresholdKm.value
              : this.longTripThresholdKm,
      longTripExtraFuel:
          data.longTripExtraFuel.present
              ? data.longTripExtraFuel.value
              : this.longTripExtraFuel,
      biweeklySettlementDays:
          data.biweeklySettlementDays.present
              ? data.biweeklySettlementDays.value
              : this.biweeklySettlementDays,
      biweeklyAnchorDate:
          data.biweeklyAnchorDate.present
              ? data.biweeklyAnchorDate.value
              : this.biweeklyAnchorDate,
      currency: data.currency.present ? data.currency.value : this.currency,
      locale: data.locale.present ? data.locale.value : this.locale,
      themeMode: data.themeMode.present ? data.themeMode.value : this.themeMode,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSetting(')
          ..write('id: $id, ')
          ..write('baseHourlyRate: $baseHourlyRate, ')
          ..write('fuelPerOrder: $fuelPerOrder, ')
          ..write('longTripThresholdKm: $longTripThresholdKm, ')
          ..write('longTripExtraFuel: $longTripExtraFuel, ')
          ..write('biweeklySettlementDays: $biweeklySettlementDays, ')
          ..write('biweeklyAnchorDate: $biweeklyAnchorDate, ')
          ..write('currency: $currency, ')
          ..write('locale: $locale, ')
          ..write('themeMode: $themeMode')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    baseHourlyRate,
    fuelPerOrder,
    longTripThresholdKm,
    longTripExtraFuel,
    biweeklySettlementDays,
    biweeklyAnchorDate,
    currency,
    locale,
    themeMode,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSetting &&
          other.id == this.id &&
          other.baseHourlyRate == this.baseHourlyRate &&
          other.fuelPerOrder == this.fuelPerOrder &&
          other.longTripThresholdKm == this.longTripThresholdKm &&
          other.longTripExtraFuel == this.longTripExtraFuel &&
          other.biweeklySettlementDays == this.biweeklySettlementDays &&
          other.biweeklyAnchorDate == this.biweeklyAnchorDate &&
          other.currency == this.currency &&
          other.locale == this.locale &&
          other.themeMode == this.themeMode);
}

class AppSettingsCompanion extends UpdateCompanion<AppSetting> {
  final Value<int> id;
  final Value<double> baseHourlyRate;
  final Value<double> fuelPerOrder;
  final Value<double> longTripThresholdKm;
  final Value<double> longTripExtraFuel;
  final Value<int> biweeklySettlementDays;
  final Value<String> biweeklyAnchorDate;
  final Value<String> currency;
  final Value<String> locale;
  final Value<String> themeMode;
  const AppSettingsCompanion({
    this.id = const Value.absent(),
    this.baseHourlyRate = const Value.absent(),
    this.fuelPerOrder = const Value.absent(),
    this.longTripThresholdKm = const Value.absent(),
    this.longTripExtraFuel = const Value.absent(),
    this.biweeklySettlementDays = const Value.absent(),
    this.biweeklyAnchorDate = const Value.absent(),
    this.currency = const Value.absent(),
    this.locale = const Value.absent(),
    this.themeMode = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    this.id = const Value.absent(),
    this.baseHourlyRate = const Value.absent(),
    this.fuelPerOrder = const Value.absent(),
    this.longTripThresholdKm = const Value.absent(),
    this.longTripExtraFuel = const Value.absent(),
    this.biweeklySettlementDays = const Value.absent(),
    this.biweeklyAnchorDate = const Value.absent(),
    this.currency = const Value.absent(),
    this.locale = const Value.absent(),
    this.themeMode = const Value.absent(),
  });
  static Insertable<AppSetting> custom({
    Expression<int>? id,
    Expression<double>? baseHourlyRate,
    Expression<double>? fuelPerOrder,
    Expression<double>? longTripThresholdKm,
    Expression<double>? longTripExtraFuel,
    Expression<int>? biweeklySettlementDays,
    Expression<String>? biweeklyAnchorDate,
    Expression<String>? currency,
    Expression<String>? locale,
    Expression<String>? themeMode,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (baseHourlyRate != null) 'base_hourly_rate': baseHourlyRate,
      if (fuelPerOrder != null) 'fuel_per_order': fuelPerOrder,
      if (longTripThresholdKm != null)
        'long_trip_threshold_km': longTripThresholdKm,
      if (longTripExtraFuel != null) 'long_trip_extra_fuel': longTripExtraFuel,
      if (biweeklySettlementDays != null)
        'biweekly_settlement_days': biweeklySettlementDays,
      if (biweeklyAnchorDate != null)
        'biweekly_anchor_date': biweeklyAnchorDate,
      if (currency != null) 'currency': currency,
      if (locale != null) 'locale': locale,
      if (themeMode != null) 'theme_mode': themeMode,
    });
  }

  AppSettingsCompanion copyWith({
    Value<int>? id,
    Value<double>? baseHourlyRate,
    Value<double>? fuelPerOrder,
    Value<double>? longTripThresholdKm,
    Value<double>? longTripExtraFuel,
    Value<int>? biweeklySettlementDays,
    Value<String>? biweeklyAnchorDate,
    Value<String>? currency,
    Value<String>? locale,
    Value<String>? themeMode,
  }) {
    return AppSettingsCompanion(
      id: id ?? this.id,
      baseHourlyRate: baseHourlyRate ?? this.baseHourlyRate,
      fuelPerOrder: fuelPerOrder ?? this.fuelPerOrder,
      longTripThresholdKm: longTripThresholdKm ?? this.longTripThresholdKm,
      longTripExtraFuel: longTripExtraFuel ?? this.longTripExtraFuel,
      biweeklySettlementDays:
          biweeklySettlementDays ?? this.biweeklySettlementDays,
      biweeklyAnchorDate: biweeklyAnchorDate ?? this.biweeklyAnchorDate,
      currency: currency ?? this.currency,
      locale: locale ?? this.locale,
      themeMode: themeMode ?? this.themeMode,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (baseHourlyRate.present) {
      map['base_hourly_rate'] = Variable<double>(baseHourlyRate.value);
    }
    if (fuelPerOrder.present) {
      map['fuel_per_order'] = Variable<double>(fuelPerOrder.value);
    }
    if (longTripThresholdKm.present) {
      map['long_trip_threshold_km'] = Variable<double>(
        longTripThresholdKm.value,
      );
    }
    if (longTripExtraFuel.present) {
      map['long_trip_extra_fuel'] = Variable<double>(longTripExtraFuel.value);
    }
    if (biweeklySettlementDays.present) {
      map['biweekly_settlement_days'] = Variable<int>(
        biweeklySettlementDays.value,
      );
    }
    if (biweeklyAnchorDate.present) {
      map['biweekly_anchor_date'] = Variable<String>(biweeklyAnchorDate.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (locale.present) {
      map['locale'] = Variable<String>(locale.value);
    }
    if (themeMode.present) {
      map['theme_mode'] = Variable<String>(themeMode.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsCompanion(')
          ..write('id: $id, ')
          ..write('baseHourlyRate: $baseHourlyRate, ')
          ..write('fuelPerOrder: $fuelPerOrder, ')
          ..write('longTripThresholdKm: $longTripThresholdKm, ')
          ..write('longTripExtraFuel: $longTripExtraFuel, ')
          ..write('biweeklySettlementDays: $biweeklySettlementDays, ')
          ..write('biweeklyAnchorDate: $biweeklyAnchorDate, ')
          ..write('currency: $currency, ')
          ..write('locale: $locale, ')
          ..write('themeMode: $themeMode')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $OrdersTable orders = $OrdersTable(this);
  late final $WorkTimesTable workTimes = $WorkTimesTable(this);
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    orders,
    workTimes,
    appSettings,
  ];
}

typedef $$OrdersTableCreateCompanionBuilder =
    OrdersCompanion Function({
      Value<int> id,
      required String date,
      Value<String> orderNumber,
      Value<String> paymentType,
      Value<double> orderValue,
      Value<double> paymentAmount,
      Value<double> changeReturned,
      Value<double> extraCashTip,
      Value<double> distanceKm,
      Value<String> address,
      Value<String> notes,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$OrdersTableUpdateCompanionBuilder =
    OrdersCompanion Function({
      Value<int> id,
      Value<String> date,
      Value<String> orderNumber,
      Value<String> paymentType,
      Value<double> orderValue,
      Value<double> paymentAmount,
      Value<double> changeReturned,
      Value<double> extraCashTip,
      Value<double> distanceKm,
      Value<String> address,
      Value<String> notes,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

class $$OrdersTableFilterComposer
    extends Composer<_$AppDatabase, $OrdersTable> {
  $$OrdersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get orderNumber => $composableBuilder(
    column: $table.orderNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get paymentType => $composableBuilder(
    column: $table.paymentType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get orderValue => $composableBuilder(
    column: $table.orderValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get paymentAmount => $composableBuilder(
    column: $table.paymentAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get changeReturned => $composableBuilder(
    column: $table.changeReturned,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get extraCashTip => $composableBuilder(
    column: $table.extraCashTip,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get distanceKm => $composableBuilder(
    column: $table.distanceKm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$OrdersTableOrderingComposer
    extends Composer<_$AppDatabase, $OrdersTable> {
  $$OrdersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get orderNumber => $composableBuilder(
    column: $table.orderNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paymentType => $composableBuilder(
    column: $table.paymentType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get orderValue => $composableBuilder(
    column: $table.orderValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get paymentAmount => $composableBuilder(
    column: $table.paymentAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get changeReturned => $composableBuilder(
    column: $table.changeReturned,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get extraCashTip => $composableBuilder(
    column: $table.extraCashTip,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get distanceKm => $composableBuilder(
    column: $table.distanceKm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OrdersTableAnnotationComposer
    extends Composer<_$AppDatabase, $OrdersTable> {
  $$OrdersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get orderNumber => $composableBuilder(
    column: $table.orderNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get paymentType => $composableBuilder(
    column: $table.paymentType,
    builder: (column) => column,
  );

  GeneratedColumn<double> get orderValue => $composableBuilder(
    column: $table.orderValue,
    builder: (column) => column,
  );

  GeneratedColumn<double> get paymentAmount => $composableBuilder(
    column: $table.paymentAmount,
    builder: (column) => column,
  );

  GeneratedColumn<double> get changeReturned => $composableBuilder(
    column: $table.changeReturned,
    builder: (column) => column,
  );

  GeneratedColumn<double> get extraCashTip => $composableBuilder(
    column: $table.extraCashTip,
    builder: (column) => column,
  );

  GeneratedColumn<double> get distanceKm => $composableBuilder(
    column: $table.distanceKm,
    builder: (column) => column,
  );

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$OrdersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OrdersTable,
          Order,
          $$OrdersTableFilterComposer,
          $$OrdersTableOrderingComposer,
          $$OrdersTableAnnotationComposer,
          $$OrdersTableCreateCompanionBuilder,
          $$OrdersTableUpdateCompanionBuilder,
          (Order, BaseReferences<_$AppDatabase, $OrdersTable, Order>),
          Order,
          PrefetchHooks Function()
        > {
  $$OrdersTableTableManager(_$AppDatabase db, $OrdersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$OrdersTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$OrdersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$OrdersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> date = const Value.absent(),
                Value<String> orderNumber = const Value.absent(),
                Value<String> paymentType = const Value.absent(),
                Value<double> orderValue = const Value.absent(),
                Value<double> paymentAmount = const Value.absent(),
                Value<double> changeReturned = const Value.absent(),
                Value<double> extraCashTip = const Value.absent(),
                Value<double> distanceKm = const Value.absent(),
                Value<String> address = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => OrdersCompanion(
                id: id,
                date: date,
                orderNumber: orderNumber,
                paymentType: paymentType,
                orderValue: orderValue,
                paymentAmount: paymentAmount,
                changeReturned: changeReturned,
                extraCashTip: extraCashTip,
                distanceKm: distanceKm,
                address: address,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String date,
                Value<String> orderNumber = const Value.absent(),
                Value<String> paymentType = const Value.absent(),
                Value<double> orderValue = const Value.absent(),
                Value<double> paymentAmount = const Value.absent(),
                Value<double> changeReturned = const Value.absent(),
                Value<double> extraCashTip = const Value.absent(),
                Value<double> distanceKm = const Value.absent(),
                Value<String> address = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => OrdersCompanion.insert(
                id: id,
                date: date,
                orderNumber: orderNumber,
                paymentType: paymentType,
                orderValue: orderValue,
                paymentAmount: paymentAmount,
                changeReturned: changeReturned,
                extraCashTip: extraCashTip,
                distanceKm: distanceKm,
                address: address,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$OrdersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OrdersTable,
      Order,
      $$OrdersTableFilterComposer,
      $$OrdersTableOrderingComposer,
      $$OrdersTableAnnotationComposer,
      $$OrdersTableCreateCompanionBuilder,
      $$OrdersTableUpdateCompanionBuilder,
      (Order, BaseReferences<_$AppDatabase, $OrdersTable, Order>),
      Order,
      PrefetchHooks Function()
    >;
typedef $$WorkTimesTableCreateCompanionBuilder =
    WorkTimesCompanion Function({
      Value<int> id,
      required String date,
      Value<String> startTime,
      Value<String> endTime,
      Value<double> workHours,
      Value<DateTime> updatedAt,
    });
typedef $$WorkTimesTableUpdateCompanionBuilder =
    WorkTimesCompanion Function({
      Value<int> id,
      Value<String> date,
      Value<String> startTime,
      Value<String> endTime,
      Value<double> workHours,
      Value<DateTime> updatedAt,
    });

class $$WorkTimesTableFilterComposer
    extends Composer<_$AppDatabase, $WorkTimesTable> {
  $$WorkTimesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get endTime => $composableBuilder(
    column: $table.endTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get workHours => $composableBuilder(
    column: $table.workHours,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WorkTimesTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkTimesTable> {
  $$WorkTimesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get endTime => $composableBuilder(
    column: $table.endTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get workHours => $composableBuilder(
    column: $table.workHours,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WorkTimesTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkTimesTable> {
  $$WorkTimesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get startTime =>
      $composableBuilder(column: $table.startTime, builder: (column) => column);

  GeneratedColumn<String> get endTime =>
      $composableBuilder(column: $table.endTime, builder: (column) => column);

  GeneratedColumn<double> get workHours =>
      $composableBuilder(column: $table.workHours, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$WorkTimesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorkTimesTable,
          WorkTime,
          $$WorkTimesTableFilterComposer,
          $$WorkTimesTableOrderingComposer,
          $$WorkTimesTableAnnotationComposer,
          $$WorkTimesTableCreateCompanionBuilder,
          $$WorkTimesTableUpdateCompanionBuilder,
          (WorkTime, BaseReferences<_$AppDatabase, $WorkTimesTable, WorkTime>),
          WorkTime,
          PrefetchHooks Function()
        > {
  $$WorkTimesTableTableManager(_$AppDatabase db, $WorkTimesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$WorkTimesTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$WorkTimesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$WorkTimesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> date = const Value.absent(),
                Value<String> startTime = const Value.absent(),
                Value<String> endTime = const Value.absent(),
                Value<double> workHours = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => WorkTimesCompanion(
                id: id,
                date: date,
                startTime: startTime,
                endTime: endTime,
                workHours: workHours,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String date,
                Value<String> startTime = const Value.absent(),
                Value<String> endTime = const Value.absent(),
                Value<double> workHours = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => WorkTimesCompanion.insert(
                id: id,
                date: date,
                startTime: startTime,
                endTime: endTime,
                workHours: workHours,
                updatedAt: updatedAt,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WorkTimesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorkTimesTable,
      WorkTime,
      $$WorkTimesTableFilterComposer,
      $$WorkTimesTableOrderingComposer,
      $$WorkTimesTableAnnotationComposer,
      $$WorkTimesTableCreateCompanionBuilder,
      $$WorkTimesTableUpdateCompanionBuilder,
      (WorkTime, BaseReferences<_$AppDatabase, $WorkTimesTable, WorkTime>),
      WorkTime,
      PrefetchHooks Function()
    >;
typedef $$AppSettingsTableCreateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<int> id,
      Value<double> baseHourlyRate,
      Value<double> fuelPerOrder,
      Value<double> longTripThresholdKm,
      Value<double> longTripExtraFuel,
      Value<int> biweeklySettlementDays,
      Value<String> biweeklyAnchorDate,
      Value<String> currency,
      Value<String> locale,
      Value<String> themeMode,
    });
typedef $$AppSettingsTableUpdateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<int> id,
      Value<double> baseHourlyRate,
      Value<double> fuelPerOrder,
      Value<double> longTripThresholdKm,
      Value<double> longTripExtraFuel,
      Value<int> biweeklySettlementDays,
      Value<String> biweeklyAnchorDate,
      Value<String> currency,
      Value<String> locale,
      Value<String> themeMode,
    });

class $$AppSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get baseHourlyRate => $composableBuilder(
    column: $table.baseHourlyRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fuelPerOrder => $composableBuilder(
    column: $table.fuelPerOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get longTripThresholdKm => $composableBuilder(
    column: $table.longTripThresholdKm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get longTripExtraFuel => $composableBuilder(
    column: $table.longTripExtraFuel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get biweeklySettlementDays => $composableBuilder(
    column: $table.biweeklySettlementDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get biweeklyAnchorDate => $composableBuilder(
    column: $table.biweeklyAnchorDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get locale => $composableBuilder(
    column: $table.locale,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get themeMode => $composableBuilder(
    column: $table.themeMode,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get baseHourlyRate => $composableBuilder(
    column: $table.baseHourlyRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fuelPerOrder => $composableBuilder(
    column: $table.fuelPerOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get longTripThresholdKm => $composableBuilder(
    column: $table.longTripThresholdKm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get longTripExtraFuel => $composableBuilder(
    column: $table.longTripExtraFuel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get biweeklySettlementDays => $composableBuilder(
    column: $table.biweeklySettlementDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get biweeklyAnchorDate => $composableBuilder(
    column: $table.biweeklyAnchorDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get locale => $composableBuilder(
    column: $table.locale,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get themeMode => $composableBuilder(
    column: $table.themeMode,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get baseHourlyRate => $composableBuilder(
    column: $table.baseHourlyRate,
    builder: (column) => column,
  );

  GeneratedColumn<double> get fuelPerOrder => $composableBuilder(
    column: $table.fuelPerOrder,
    builder: (column) => column,
  );

  GeneratedColumn<double> get longTripThresholdKm => $composableBuilder(
    column: $table.longTripThresholdKm,
    builder: (column) => column,
  );

  GeneratedColumn<double> get longTripExtraFuel => $composableBuilder(
    column: $table.longTripExtraFuel,
    builder: (column) => column,
  );

  GeneratedColumn<int> get biweeklySettlementDays => $composableBuilder(
    column: $table.biweeklySettlementDays,
    builder: (column) => column,
  );

  GeneratedColumn<String> get biweeklyAnchorDate => $composableBuilder(
    column: $table.biweeklyAnchorDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<String> get locale =>
      $composableBuilder(column: $table.locale, builder: (column) => column);

  GeneratedColumn<String> get themeMode =>
      $composableBuilder(column: $table.themeMode, builder: (column) => column);
}

class $$AppSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppSettingsTable,
          AppSetting,
          $$AppSettingsTableFilterComposer,
          $$AppSettingsTableOrderingComposer,
          $$AppSettingsTableAnnotationComposer,
          $$AppSettingsTableCreateCompanionBuilder,
          $$AppSettingsTableUpdateCompanionBuilder,
          (
            AppSetting,
            BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
          ),
          AppSetting,
          PrefetchHooks Function()
        > {
  $$AppSettingsTableTableManager(_$AppDatabase db, $AppSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$AppSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$AppSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () =>
                  $$AppSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<double> baseHourlyRate = const Value.absent(),
                Value<double> fuelPerOrder = const Value.absent(),
                Value<double> longTripThresholdKm = const Value.absent(),
                Value<double> longTripExtraFuel = const Value.absent(),
                Value<int> biweeklySettlementDays = const Value.absent(),
                Value<String> biweeklyAnchorDate = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<String> locale = const Value.absent(),
                Value<String> themeMode = const Value.absent(),
              }) => AppSettingsCompanion(
                id: id,
                baseHourlyRate: baseHourlyRate,
                fuelPerOrder: fuelPerOrder,
                longTripThresholdKm: longTripThresholdKm,
                longTripExtraFuel: longTripExtraFuel,
                biweeklySettlementDays: biweeklySettlementDays,
                biweeklyAnchorDate: biweeklyAnchorDate,
                currency: currency,
                locale: locale,
                themeMode: themeMode,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<double> baseHourlyRate = const Value.absent(),
                Value<double> fuelPerOrder = const Value.absent(),
                Value<double> longTripThresholdKm = const Value.absent(),
                Value<double> longTripExtraFuel = const Value.absent(),
                Value<int> biweeklySettlementDays = const Value.absent(),
                Value<String> biweeklyAnchorDate = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<String> locale = const Value.absent(),
                Value<String> themeMode = const Value.absent(),
              }) => AppSettingsCompanion.insert(
                id: id,
                baseHourlyRate: baseHourlyRate,
                fuelPerOrder: fuelPerOrder,
                longTripThresholdKm: longTripThresholdKm,
                longTripExtraFuel: longTripExtraFuel,
                biweeklySettlementDays: biweeklySettlementDays,
                biweeklyAnchorDate: biweeklyAnchorDate,
                currency: currency,
                locale: locale,
                themeMode: themeMode,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppSettingsTable,
      AppSetting,
      $$AppSettingsTableFilterComposer,
      $$AppSettingsTableOrderingComposer,
      $$AppSettingsTableAnnotationComposer,
      $$AppSettingsTableCreateCompanionBuilder,
      $$AppSettingsTableUpdateCompanionBuilder,
      (
        AppSetting,
        BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
      ),
      AppSetting,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$OrdersTableTableManager get orders =>
      $$OrdersTableTableManager(_db, _db.orders);
  $$WorkTimesTableTableManager get workTimes =>
      $$WorkTimesTableTableManager(_db, _db.workTimes);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
}
