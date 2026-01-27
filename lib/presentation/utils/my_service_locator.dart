import 'package:bpstate/bpstate.dart';
import 'package:go_router/go_router.dart';
import 'package:prueba_rick/application/repository/remote/r_character.dart';
import 'package:prueba_rick/application/manager/adapters/m_character.dart';
import 'package:prueba_rick/application/manager/m_character.dart';
import 'package:prueba_rick/application/use_cases/character/uc_get_characters.dart';
import 'package:prueba_rick/application/use_cases/character/uc_get_characters_page.dart';
import 'package:prueba_rick/application/use_cases/character/uc_search_character.dart';
import 'package:prueba_rick/infraestructure/remote/r_character_imp.dart';
import 'package:prueba_rick/presentation/bloc_application/b_application.dart';
import 'package:prueba_rick/presentation/bloc_application/blocs/b_user.dart';
import 'package:prueba_rick/infraestructure/remote/api/api.dart';
import 'package:prueba_rick/presentation/pages/home/bloc/b_home.dart';

class MyServiceLocator extends ServiceLocator<GoRouter> {
  MyServiceLocator._internal();

  static final MyServiceLocator instance = MyServiceLocator._internal();

  late GoRouter _navigator;
  late Api api = Api.instance();

  void setNavigator(GoRouter navigator) {
    _navigator = navigator;
  }

  @override
  GoRouter Function() get navigator => () {
    return _navigator;
  };

  @override
  String Function(String p1) get translate => (value) {
    return '';
  };
  // ----------------------------- bloc
  BUser get bUser => BUser.instance();
  BApplication get bApplication => BApplication.instance();
  BHome bHome() => BHome(mCharacter: _mCharacter);

  // ----------------------------- repositorio

  RCharacter get _rCharacter => RCharacterImp(api: api);

  // ----------------------------- manager
  MCharacter get _mCharacter => MCharacterImp(ucSearchCaracter: _ucSearchCaracter, ucGetCharacters: _ucGetCharacters, ucGetCharactersPage: _ucGetCharactersPage);

  // ----------------------------- use case
  UCSearchCharacter get _ucSearchCaracter => UCSearchCharacter(rlCharacter: _rCharacter);
  UCGetCharacters get _ucGetCharacters => UCGetCharacters(rlCharacter: _rCharacter);
  UCGetCharactersPage get _ucGetCharactersPage => UCGetCharactersPage(rCharacter: _rCharacter);
}
