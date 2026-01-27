import 'package:prueba_rick/application/base/use_case.dart';
import 'package:prueba_rick/core/entities/e_character.dart';
import 'package:prueba_rick/core/entities/e_page.dart';
import 'package:prueba_rick/application/repository/remote/r_character.dart';

class UCGetCharacters extends UseCase<dynamic, EPage<ECharacter>> {
  final RCharacter _rlCharacter;
  
  UCGetCharacters({required RCharacter rlCharacter}) : _rlCharacter = rlCharacter;
  @override
  Future<EPage<ECharacter>> execute(param) {
    return _rlCharacter.getCharacters();
  }
}