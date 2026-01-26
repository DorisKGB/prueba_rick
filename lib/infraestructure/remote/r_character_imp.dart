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
        return Future.error(e.response?.data['message']);
      }
      return Future.error('Ocurrio un error inesperado');
    }
  }
}
/* //This exception was thrown because the response has a status code of 404 and RequestOptions.validateStatus was configured to throw for this status code.
The status code of 404 has the following meaning: "Client error - the request contains bad syntax or cannot be fulfilled"
Read more about status codes at https://developer.mozilla.org/en-US/docs/Web/HTTP/Status
In order to resolve this exception you typically have either to verify and fix your request code or you have to fix the server code. */
