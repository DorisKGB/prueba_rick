import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:prueba_rick/application/repository/remote/r_character.dart';
import 'package:prueba_rick/core/entities/e_character.dart';
import 'package:prueba_rick/core/entities/e_page.dart';
import 'package:prueba_rick/infraestructure/remote/mappers/e_page_mapper.dart';

import 'api/api.dart';

class RCharacterImp implements RCharacter {
  final Api _api;

  RCharacterImp({required Api api}) : _api = api;

  @override
  Future<EPage<ECharacter>> searchCharacter(ECharacter param) async {
    try {
      final Response<Map<String, dynamic>> response = await _api.get(
          path: 'character',
          queryParameters: {
            'name': param.name,
            'status': param.status,
            'gender': param.gender,
            'species': param.species,
            'type': param.type,
          }
          );

      return EPageFromData().transform(response.data);
    } catch (e) {
      //final message = response?.data?['data']['message'];
      if (e is DioException) {
        if(e.response?.statusCode == 404){
          return Future.error('No se encontro ningun resultado');
        }
      }
      return Future.error('Ocurrio un error inesperado');
    }
  }
  
  @override
  Future<EPage<ECharacter>> getCharacters() async {
    try {
      final Response<Map<String, dynamic>> response = await _api.get(path: 'character');

      return EPageFromData().transform(response.data);
    } catch (e) {
      if (e is DioException) {
        if(e.response?.statusCode == 404){
          return Future.error('No se encontro ningun resultado');
        }
        if(e.response?.statusCode == 429){
          return Future.error('Demasiados intentos');
        }          
      }
      return Future.error('Ocurrio un error inesperado');      
    }
  }
  
  @override
  Future<EPage<ECharacter>> getCharactersPage(String param) async {
    try {
      final Response<Map<String, dynamic>> response = await _api.get(path: param);

      return EPageFromData().transform(response.data);
    } catch (e) {
      if (e is DioException) {
        if(e.response?.statusCode == 404){
          return Future.error('No se encontro ningun resultado');
        }
        if(e.response?.statusCode == 429){
          return Future.error('Demasiados intentos');
        }        
      }
      return Future.error('Ocurrio un error inesperado');      
    }
  }

  
}
