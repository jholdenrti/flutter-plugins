part of health;

/// A [HealthDataPoint] object corresponds to a data point capture from
/// GoogleFit or Apple HealthKit with a [HealthValue] as value.
class HealthDataPoint {
  HealthValue _value;
  HealthDataType _type;
  HealthDataUnit _unit;
  DateTime _dateFrom;
  DateTime _dateTo;
  PlatformType _platform;
  String _deviceId;
  String _sourceId;
  String _sourceName;
  String _devManufacturer;
  String _devModel;
  String _devName;

  HealthDataPoint(
      this._value,
      this._type,
      this._unit,
      this._dateFrom,
      this._dateTo,
      this._platform,
      this._deviceId,
      this._sourceId,
      this._sourceName,
      this._devManufacturer,
      this._devModel,
      this._devName) {
    // set the value to minutes rather than the category
    // returned by the native API
    if (type == HealthDataType.MINDFULNESS ||
        type == HealthDataType.HEADACHE_UNSPECIFIED ||
        type == HealthDataType.HEADACHE_NOT_PRESENT ||
        type == HealthDataType.HEADACHE_MILD ||
        type == HealthDataType.HEADACHE_MODERATE ||
        type == HealthDataType.HEADACHE_SEVERE ||
        type == HealthDataType.SLEEP_IN_BED ||
        type == HealthDataType.SLEEP_ASLEEP ||
        type == HealthDataType.SLEEP_AWAKE) {
      this._value = _convertMinutes();
    }
  }

  NumericHealthValue _convertMinutes() {
    int ms = dateTo.millisecondsSinceEpoch - dateFrom.millisecondsSinceEpoch;
    return NumericHealthValue(ms / (1000 * 60));
  }

  /// Converts a json object to the [HealthDataPoint]
  factory HealthDataPoint.fromJson(json) {
    HealthValue healthValue;
    if (json['data_type'] == 'AUDIOGRAM') {
      healthValue = AudiogramHealthValue.fromJson(json['value']);
    } else if (json['data_type'] == 'WORKOUT') {
      healthValue = WorkoutHealthValue.fromJson(json['value']);
    } else {
      healthValue = NumericHealthValue.fromJson(json['value']);
    }

    return HealthDataPoint(
        healthValue,
        HealthDataType.values
            .firstWhere((element) => element.name == json['data_type']),
        HealthDataUnit.values
            .firstWhere((element) => element.name == json['unit']),
        DateTime.parse(json['date_from']),
        DateTime.parse(json['date_to']),
        PlatformTypeJsonValue.keys.toList()[PlatformTypeJsonValue.values
            .toList()
            .indexOf(json['platform_type'])],
        json['device_id'],
        json['source_id'],
        json['source_name'],
        json['dev_manufacturer'],
        json['dev_model'],
        json['dev_name']);
  }

  /// Converts the [HealthDataPoint] to a json object
  Map<String, dynamic> toJson() => {
        'value': value.toJson(),
        'data_type': type.name,
        'unit': unit.name,
        'date_from': dateFrom.toIso8601String(),
        'date_to': dateTo.toIso8601String(),
        'platform_type': PlatformTypeJsonValue[platform],
        'device_id': deviceId,
        'source_id': sourceId,
        'source_name': sourceName,
        'dev_manufacturer': devManufacturer,
        'dev_model': devModel,
        'dev_name': devName
      };

  @override
  String toString() => """${this.runtimeType} -
    value: ${value.toString()},
    unit: ${unit.name},
    dateFrom: $dateFrom,
    dateTo: $dateTo,
    dataType: ${type.name},
    platform: $platform,
    deviceId: $deviceId,
    sourceId: $sourceId,
    sourceName: $sourceName,
    devManufacturer: $devManufacturer,
    devModel: $devModel,
    devName: $devName
    """;

  // / The quantity value of the data point
  HealthValue get value => _value;

  /// The start of the time interval
  DateTime get dateFrom => _dateFrom;

  /// The end of the time interval
  DateTime get dateTo => _dateTo;

  /// The type of the data point
  HealthDataType get type => _type;

  /// The unit of the data point
  HealthDataUnit get unit => _unit;

  /// The software platform of the data point
  PlatformType get platform => _platform;

  /// The data point type as a string
  String get typeString => _type.name;

  /// The data point unit as a string
  String get unitString => _unit.name;

  /// The id of the device from which the data point was fetched.
  String get deviceId => _deviceId;

  /// The id of the source from which the data point was fetched.
  String get sourceId => _sourceId;

  /// The name of the source from which the data point was fetched.
  String get sourceName => _sourceName;

  /// The manufacturer of the device from which the data point was fetched.
  String get devManufacturer => _devManufacturer;

  /// The model of the device from which the data point was fetched.
  String get devModel => _devModel;

  /// The name of the device from which the data point was fetched.
  String get devName => _devName;

  @override
  bool operator ==(Object o) {
    return o is HealthDataPoint &&
        this.value == o.value &&
        this.unit == o.unit &&
        this.dateFrom == o.dateFrom &&
        this.dateTo == o.dateTo &&
        this.type == o.type &&
        this.platform == o.platform &&
        this.deviceId == o.deviceId &&
        this.sourceId == o.sourceId &&
        this.sourceName == o.sourceName;
  }

  @override
  int get hashCode => Object.hash(value, unit, dateFrom, dateTo, type, platform,
      deviceId, sourceId, sourceName);
}
