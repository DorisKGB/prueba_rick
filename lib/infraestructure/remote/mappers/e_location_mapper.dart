import 'package:prueba_rick/application/base/mapper.dart';
import 'package:prueba_rick/core/entities/e_location.dart';

class ELocationFromData extends MapperService<dynamic, ELocation> {
  @override
  ELocation map(item) {
    return ELocation()
      ..name = item['name']
      ..url = item['url'];
  }
}