import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prueba_rick/core/entities/e_character.dart';
import 'package:prueba_rick/core/entities/e_page.dart';
import 'package:prueba_rick/infraestructure/remote/api/api.dart';
import 'package:prueba_rick/infraestructure/remote/r_character_imp.dart';

class MockApi extends Mock implements Api {}

void main() {
  late MockApi mockApi;
  late RCharacterImp repository;

  setUp(() {
    mockApi = MockApi();
    repository = RCharacterImp(api: mockApi);
  });

  group('RCharacterImp - getCharacters', () {
    test('should return EPage<ECharacter> when API call is successful', () async {
      // Arrange
      final mockResponseData = {
        'info': {
          'count': 826,
          'pages': 42,
          'next': 'https://rickandmortyapi.com/api/character?page=2',
          'prev': null,
        },
        'results': [
          {
            'id': 1,
            'name': 'Rick Sanchez',
            'status': 'Alive',
            'species': 'Human',
            'type': '',
            'gender': 'Male',
            'origin': {
              'name': 'Earth (C-137)',
              'url': 'https://rickandmortyapi.com/api/location/1'
            },
            'location': {
              'name': 'Citadel of Ricks',
              'url': 'https://rickandmortyapi.com/api/location/3'
            },
            'image': 'https://rickandmortyapi.com/api/character/avatar/1.jpeg',
            'episode': [
              'https://rickandmortyapi.com/api/episode/1',
              'https://rickandmortyapi.com/api/episode/2'
            ],
            'url': 'https://rickandmortyapi.com/api/character/1',
            'created': '2017-11-04T18:48:46.250Z'
          }
        ]
      };

      final mockResponse = Response<Map<String, dynamic>>(
        data: mockResponseData,
        statusCode: 200,
        requestOptions: RequestOptions(path: 'character'),
      );

      when(() => mockApi.get<Map<String, dynamic>>(
        path: 'character',
      )).thenAnswer((_) async => mockResponse);

      // Act
      final result = await repository.getCharacters();

      // Assert
      expect(result, isA<EPage<ECharacter>>());
      expect(result.count, 826);
      expect(result.pages, 42);
      expect(result.results, isNotNull);
      expect(result.results!.length, 1);
      expect(result.results!.first.name, 'Rick Sanchez');
      verify(() => mockApi.get<Map<String, dynamic>>(path: 'character')).called(1);
    });

    test('should throw error when API returns 404', () async {
      // Arrange
      when(() => mockApi.get<Map<String, dynamic>>(path: 'character'))
          .thenThrow(DioException(
        response: Response(
          statusCode: 404,
          requestOptions: RequestOptions(path: 'character'),
        ),
        requestOptions: RequestOptions(path: 'character'),
      ));

      // Act & Assert
      expect(
        () => repository.getCharacters(),
        throwsA(equals('No se encontro ningun resultado')),
      );
    });

    test('should throw error when API returns 429', () async {
      // Arrange
      when(() => mockApi.get<Map<String, dynamic>>(path: 'character'))
          .thenThrow(DioException(
        response: Response(
          statusCode: 429,
          requestOptions: RequestOptions(path: 'character'),
        ),
        requestOptions: RequestOptions(path: 'character'),
      ));

      // Act & Assert
      expect(
        () => repository.getCharacters(),
        throwsA(equals('Demasiados intentos')),
      );
    });

    test('should throw generic error for unexpected errors', () async {
      // Arrange
      when(() => mockApi.get<Map<String, dynamic>>(path: 'character'))
          .thenThrow(DioException(
        response: Response(
          statusCode: 500,
          requestOptions: RequestOptions(path: 'character'),
        ),
        requestOptions: RequestOptions(path: 'character'),
      ));

      // Act & Assert
      expect(
        () => repository.getCharacters(),
        throwsA(equals('Ocurrio un error inesperado')),
      );
    });
  });

  group('RCharacterImp - searchCharacter', () {
    test('should return EPage<ECharacter> with query parameters', () async {
      // Arrange
      final searchParam = ECharacter(
        name: 'Rick',
        status: 'Alive',
        gender: 'Male',
        species: 'Human',
        type: '',
      );

      final mockResponseData = {
        'info': {
          'count': 10,
          'pages': 1,
          'next': null,
          'prev': null,
        },
        'results': [
          {
            'id': 1,
            'name': 'Rick Sanchez',
            'status': 'Alive',
            'species': 'Human',
            'type': '',
            'gender': 'Male',
            'origin': {
              'name': 'Earth (C-137)',
              'url': 'https://rickandmortyapi.com/api/location/1'
            },
            'location': {
              'name': 'Citadel of Ricks',
              'url': 'https://rickandmortyapi.com/api/location/3'
            },
            'image': 'https://rickandmortyapi.com/api/character/avatar/1.jpeg',
            'episode': [],
            'url': 'https://rickandmortyapi.com/api/character/1',
            'created': '2017-11-04T18:48:46.250Z'
          }
        ]
      };

      final mockResponse = Response<Map<String, dynamic>>(
        data: mockResponseData,
        statusCode: 200,
        requestOptions: RequestOptions(path: 'character'),
      );

      when(() => mockApi.get<Map<String, dynamic>>(
        path: 'character',
        queryParameters: any(named: 'queryParameters'),
      )).thenAnswer((_) async => mockResponse);

      // Act
      final result = await repository.searchCharacter(searchParam);

      // Assert
      expect(result, isA<EPage<ECharacter>>());
      expect(result.count, 10);
      expect(result.results!.first.name, 'Rick Sanchez');
      verify(() => mockApi.get<Map<String, dynamic>>(
        path: 'character',
        queryParameters: any(named: 'queryParameters'),
      )).called(1);
    });

    test('should throw error when search returns 404', () async {
      // Arrange
      final searchParam = ECharacter(name: 'NonExistent');

      when(() => mockApi.get<Map<String, dynamic>>(
        path: 'character',
        queryParameters: any(named: 'queryParameters'),
      )).thenThrow(DioException(
        response: Response(
          statusCode: 404,
          requestOptions: RequestOptions(path: 'character'),
        ),
        requestOptions: RequestOptions(path: 'character'),
      ));

      // Act & Assert
      expect(
        () => repository.searchCharacter(searchParam),
        throwsA(equals('No se encontro ningun resultado')),
      );
    });
  });

  group('RCharacterImp - getCharactersPage', () {
    test('should return EPage<ECharacter> for specific page URL', () async {
      // Arrange
      const pageUrl = 'character?page=2';
      final mockResponseData = {
        'info': {
          'count': 826,
          'pages': 42,
          'next': 'https://rickandmortyapi.com/api/character?page=3',
          'prev': 'https://rickandmortyapi.com/api/character?page=1',
        },
        'results': [
          {
            'id': 21,
            'name': 'Aqua Morty',
            'status': 'unknown',
            'species': 'Humanoid',
            'type': 'Fish-Person',
            'gender': 'Male',
            'origin': {
              'name': 'unknown',
              'url': ''
            },
            'location': {
              'name': 'Citadel of Ricks',
              'url': 'https://rickandmortyapi.com/api/location/3'
            },
            'image': 'https://rickandmortyapi.com/api/character/avatar/21.jpeg',
            'episode': [],
            'url': 'https://rickandmortyapi.com/api/character/21',
            'created': '2017-11-04T22:39:48.055Z'
          }
        ]
      };

      final mockResponse = Response<Map<String, dynamic>>(
        data: mockResponseData,
        statusCode: 200,
        requestOptions: RequestOptions(path: pageUrl),
      );

      when(() => mockApi.get<Map<String, dynamic>>(path: pageUrl))
          .thenAnswer((_) async => mockResponse);

      // Act
      final result = await repository.getCharactersPage(pageUrl);

      // Assert
      expect(result, isA<EPage<ECharacter>>());
      expect(result.count, 826);
      expect(result.results!.first.name, 'Aqua Morty');
      verify(() => mockApi.get<Map<String, dynamic>>(path: pageUrl)).called(1);
    });

    test('should throw error when page returns 404', () async {
      // Arrange
      const pageUrl = 'character?page=999';

      when(() => mockApi.get<Map<String, dynamic>>(path: pageUrl))
          .thenThrow(DioException(
        response: Response(
          statusCode: 404,
          requestOptions: RequestOptions(path: pageUrl),
        ),
        requestOptions: RequestOptions(path: pageUrl),
      ));

      // Act & Assert
      expect(
        () => repository.getCharactersPage(pageUrl),
        throwsA(equals('No se encontro ningun resultado')),
      );
    });

    test('should throw error when page returns 429', () async {
      // Arrange
      const pageUrl = 'character?page=2';

      when(() => mockApi.get<Map<String, dynamic>>(path: pageUrl))
          .thenThrow(DioException(
        response: Response(
          statusCode: 429,
          requestOptions: RequestOptions(path: pageUrl),
        ),
        requestOptions: RequestOptions(path: pageUrl),
      ));

      // Act & Assert
      expect(
        () => repository.getCharactersPage(pageUrl),
        throwsA(equals('Demasiados intentos')),
      );
    });
  });
}
