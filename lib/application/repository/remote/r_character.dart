import 'package:prueba_rick/core/entities/e_character.dart';
import 'package:prueba_rick/core/entities/e_page.dart';

abstract class RCharacter {
  Future<EPage<ECharacter>> searchCharacter(ECharacter param);
}