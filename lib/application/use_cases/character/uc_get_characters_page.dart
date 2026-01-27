import 'package:prueba_rick/application/base/use_case.dart';
import 'package:prueba_rick/application/repository/remote/r_character.dart';
import 'package:prueba_rick/core/entities/e_character.dart';
import 'package:prueba_rick/core/entities/e_page.dart';

class UCGetCharactersPage implements UseCase<String, EPage<ECharacter>> {
  final RCharacter _rCharacter;

  UCGetCharactersPage({required RCharacter rCharacter}) : _rCharacter = rCharacter;

  @override
  Future<EPage<ECharacter>> execute(String param) {
    try {
      return _rCharacter.getCharactersPage(param);
    } catch (e) {
      return Future.error(e);
    }
  }
}