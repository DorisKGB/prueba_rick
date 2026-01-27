import 'package:prueba_rick/application/manager/adapters/m_character.dart';
import 'package:prueba_rick/application/use_cases/character/uc_get_characters.dart';
import 'package:prueba_rick/application/use_cases/character/uc_get_characters_page.dart';
import 'package:prueba_rick/application/use_cases/character/uc_search_character.dart';
import 'package:prueba_rick/core/entities/e_character.dart';
import 'package:prueba_rick/core/entities/e_page.dart';

class MCharacterImp implements MCharacter {
  final UCSearchCharacter _ucSearchCaracter;
  final UCGetCharacters _ucGetCharacters;
  final UCGetCharactersPage _ucGetCharactersPage;

  MCharacterImp({
    required UCSearchCharacter ucSearchCaracter, required UCGetCharacters ucGetCharacters,
    required UCGetCharactersPage ucGetCharactersPage,
  }) : _ucSearchCaracter = ucSearchCaracter, _ucGetCharacters = ucGetCharacters, _ucGetCharactersPage = ucGetCharactersPage;

  @override
  Future<EPage<ECharacter>> searchCharacter(ECharacter param) {
    try {
      return _ucSearchCaracter.execute(param);
    } catch (e) {
      return Future.error(e);
    }
  }
  
  @override
  Future<EPage<ECharacter>> getCharacters() {
    try {
      return _ucGetCharacters.execute(null);
    } catch (e) {
      return Future.error(e);
    }
  }
  
  @override
  Future<EPage<ECharacter>> getCharactersPage(String param) {
    try {
      return _ucGetCharactersPage.execute(param);
    } catch (e) {
      return Future.error(e);
    }
  }
}
