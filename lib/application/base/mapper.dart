///Generic mapper for converting entities to models or vice versa
///
///[I] input object
///[O] output object

abstract class _Mapper<I, O> {
  O transform(I item);
  List<O> transformList(List<I> array);
}

abstract class MapperService<I, O> implements _Mapper<I, O> {
  O map(I item);

  @override
  O transform(I item) => map(item);

  @override
  List<O> transformList(List<I> list) =>
      list.map((I item) => map(item)).toList();

  T getStatusFromString<T extends Enum>(List<T> values, String status) {
    return values.firstWhere((e) => e.name == status);
  }

  bool getBool(dynamic value, [bool defaultValue = false]) {
    if (value != null) {
      return value.toString() == 'true';
    }
    return defaultValue;
  }

  int? getInt(dynamic value) {
    return int.tryParse(value?.toString() ?? '');
  }

  double? getDouble(dynamic value) {
    return double.tryParse(value?.toString() ?? '');
  }

  DateTime? getDateTime(dynamic value) {
    try {
      if (value is String) {
        return DateTime.tryParse(value);
      }
      return DateTime.fromMillisecondsSinceEpoch(value as int);
    } catch (e) {
      return null;
    }
  }
}
