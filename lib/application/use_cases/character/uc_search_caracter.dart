import 'package:prueba_rick/application/base/use_case.dart';
import 'package:prueba_rick/application/repository/remote/r_character.dart';
import 'package:prueba_rick/core/entities/e_character.dart';
import 'package:prueba_rick/core/entities/e_page.dart';
import 'package:prueba_rick/application/utils/debouncer.dart';

class UCSearchCaracter extends UseCase<ECharacter, EPage<ECharacter>> {
  final RCharacter _rlCharacter;
  final Debouncer<EPage<ECharacter>> _debouncer = Debouncer(duration: const Duration(milliseconds: 500));

  UCSearchCaracter({required RCharacter rlCharacter})
      : _rlCharacter = rlCharacter;

  @override
  Future<EPage<ECharacter>> execute(ECharacter param) async {
    param.name = param.name ?? '';
    param.status = param.status ?? '';
    param.gender = param.gender ?? '';
    param.species = param.species ?? '';
    param.type = param.type ?? '';
    
    return _debouncer.run(() => _rlCharacter.searchCharacter(param), duration: Duration(milliseconds: 500));
  }
}