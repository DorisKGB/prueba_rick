import 'package:prueba_rick/application/base/mapper.dart';
import 'package:prueba_rick/core/entities/e_origin.dart';

class EOriginFromData extends MapperService<dynamic, EOrigin> {
  @override
  EOrigin map(item) {
    return EOrigin()
      ..name = item['name']
      ..url = item['url'];
  }
}