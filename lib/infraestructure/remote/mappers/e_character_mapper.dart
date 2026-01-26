import 'package:prueba_rick/application/base/mapper.dart';
import 'package:prueba_rick/core/entities/e_character.dart';
import 'package:prueba_rick/infraestructure/remote/mappers/e_location_mapper.dart';
import 'package:prueba_rick/infraestructure/remote/mappers/e_origin_mapper.dart';

class ECharacterFromData extends MapperService<dynamic, ECharacter> {
  @override
  ECharacter map(item) {
    return ECharacter()
      ..id = item['id']
      ..name = item['name']
      ..status = item['status']
      ..species = item['species']
      ..type = item['type']
      ..gender = item['gender']
      ..origin = item['origin'] != null
          ? EOriginFromData().transform(item['origin'] as Map<String, dynamic>)
          : null
      ..location = item['location'] != null
          ? ELocationFromData().transform(item['location'] as Map<String, dynamic>)
          : null
      ..image = item['image']
      ..episode = item['episode'] != null
          ? (item['episode'] as List<dynamic>).map((e) => e.toString()).toList()
          : [];
  }
}