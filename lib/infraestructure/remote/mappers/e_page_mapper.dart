import 'package:prueba_rick/application/base/mapper.dart';
import 'package:prueba_rick/core/entities/e_character.dart';
import 'package:prueba_rick/core/entities/e_page.dart';
import 'package:prueba_rick/infraestructure/remote/mappers/e_character_mapper.dart';

class EPageFromData extends MapperService<dynamic, EPage<ECharacter>> {
  @override
  EPage<ECharacter> map(item) {
    return EPage<ECharacter>(
      count: item['info']['count']??0,
      pages: item['info']['pages']??0,
      next: item['info']['next']??'',
      prev: item['info']['prev']??'',
      results: item['results']!=null ? ECharacterFromData().transformList(item['results'] as List<dynamic>) : [],
    );
  }
}