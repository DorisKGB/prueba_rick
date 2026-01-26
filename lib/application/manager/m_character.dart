import 'package:prueba_rick/application/manager/adapters/m_character.dart';
import 'package:prueba_rick/application/use_cases/character/uc_search_caracter.dart';
import 'package:prueba_rick/core/entities/e_character.dart';
import 'package:prueba_rick/core/entities/e_page.dart';

class MCharacterImp implements MCharacter {
  final UCSearchCaracter _ucSearchCaracter;

  MCharacterImp({
    required UCSearchCaracter ucSearchCaracter,
  }) : _ucSearchCaracter = ucSearchCaracter;

  @override
  Future<EPage<ECharacter>> searchCharacter(ECharacter param) {
    try {
      return _ucSearchCaracter.execute(param);
    } catch (e) {
      return Future.error(e);
    }
  }
}
