import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prueba_rick/application/manager/m_character.dart';
import 'package:prueba_rick/application/use_cases/character/uc_get_characters.dart';
import 'package:prueba_rick/application/use_cases/character/uc_get_characters_page.dart';
import 'package:prueba_rick/application/use_cases/character/uc_search_character.dart';
import 'package:prueba_rick/core/entities/e_character.dart';
import 'package:prueba_rick/core/entities/e_page.dart';

class MockUCSearchCharacter extends Mock implements UCSearchCharacter {}
class MockUCGetCharacters extends Mock implements UCGetCharacters {}
class MockUCGetCharactersPage extends Mock implements UCGetCharactersPage {}

void main() {
  late MockUCSearchCharacter mockSearchCharacter;
  late MockUCGetCharacters mockGetCharacters;
  late MockUCGetCharactersPage mockGetCharactersPage;
  late MCharacterImp manager;

  setUpAll(() {
    // Register fallback values for mocktail
    registerFallbackValue(ECharacter());
  });

  setUp(() {
    mockSearchCharacter = MockUCSearchCharacter();
    mockGetCharacters = MockUCGetCharacters();
    mockGetCharactersPage = MockUCGetCharactersPage();
    
    manager = MCharacterImp(
      ucSearchCaracter: mockSearchCharacter,
      ucGetCharacters: mockGetCharacters,
      ucGetCharactersPage: mockGetCharactersPage,
    );
  });

  group('MCharacterImp - searchCharacter', () {
    test('should return EPage<ECharacter> when search is successful', () async {
      // Arrange
      final searchParam = ECharacter(
        name: 'Rick',
        status: 'Alive',
        gender: 'Male',
      );

      final expectedPage = EPage<ECharacter>(
        count: 10,
        pages: 1,
        next: null,
        prev: null,
        results: [
          ECharacter(
            id: 1,
            name: 'Rick Sanchez',
            status: 'Alive',
            gender: 'Male',
          ),
        ],
      );

      when(() => mockSearchCharacter.execute(searchParam))
          .thenAnswer((_) async => expectedPage);

      // Act
      final result = await manager.searchCharacter(searchParam);

      // Assert
      expect(result, equals(expectedPage));
      expect(result.results!.first.name, 'Rick Sanchez');
      verify(() => mockSearchCharacter.execute(searchParam)).called(1);
    });

    test('should propagate error when use case fails', () async {
      // Arrange
      final searchParam = ECharacter(name: 'NonExistent');
      const errorMessage = 'No se encontro ningun resultado';

      when(() => mockSearchCharacter.execute(searchParam))
          .thenThrow(errorMessage);

      // Act & Assert
      expect(
        () => manager.searchCharacter(searchParam),
        throwsA(equals(errorMessage)),
      );
      verify(() => mockSearchCharacter.execute(searchParam)).called(1);
    });

    test('should handle exception and return Future.error', () async {
      // Arrange
      final searchParam = ECharacter(name: 'Test');
      final exception = Exception('Network error');

      when(() => mockSearchCharacter.execute(searchParam))
          .thenThrow(exception);

      // Act & Assert
      expect(
        () => manager.searchCharacter(searchParam),
        throwsA(equals(exception)),
      );
      verify(() => mockSearchCharacter.execute(searchParam)).called(1);
    });

    test('should call use case with correct parameters', () async {
      // Arrange
      final searchParam = ECharacter(
        name: 'Morty',
        status: 'Alive',
        gender: 'Male',
        species: 'Human',
        type: '',
      );

      final expectedPage = EPage<ECharacter>(
        count: 5,
        pages: 1,
        next: null,
        prev: null,
        results: [],
      );

      when(() => mockSearchCharacter.execute(searchParam))
          .thenAnswer((_) async => expectedPage);

      // Act
      await manager.searchCharacter(searchParam);

      // Assert
      verify(() => mockSearchCharacter.execute(searchParam)).called(1);
      verifyNoMoreInteractions(mockSearchCharacter);
    });
  });

  group('MCharacterImp - getCharacters', () {
    test('should return EPage<ECharacter> when getting all characters', () async {
      // Arrange
      final expectedPage = EPage<ECharacter>(
        count: 826,
        pages: 42,
        next: 'https://rickandmortyapi.com/api/character?page=2',
        prev: null,
        results: [
          ECharacter(id: 1, name: 'Rick Sanchez'),
          ECharacter(id: 2, name: 'Morty Smith'),
        ],
      );

      when(() => mockGetCharacters.execute(null))
          .thenAnswer((_) async => expectedPage);

      // Act
      final result = await manager.getCharacters();

      // Assert
      expect(result, equals(expectedPage));
      expect(result.count, 826);
      expect(result.results!.length, 2);
      verify(() => mockGetCharacters.execute(null)).called(1);
    });

    test('should return empty page when no characters exist', () async {
      // Arrange
      final emptyPage = EPage<ECharacter>(
        count: 0,
        pages: 0,
        next: null,
        prev: null,
        results: [],
      );

      when(() => mockGetCharacters.execute(null))
          .thenAnswer((_) async => emptyPage);

      // Act
      final result = await manager.getCharacters();

      // Assert
      expect(result.results, isEmpty);
      expect(result.count, 0);
      verify(() => mockGetCharacters.execute(null)).called(1);
    });

    test('should propagate error when use case fails', () async {
      // Arrange
      const errorMessage = 'Ocurrio un error inesperado';

      when(() => mockGetCharacters.execute(null))
          .thenThrow(errorMessage);

      // Act & Assert
      expect(
        () => manager.getCharacters(),
        throwsA(equals(errorMessage)),
      );
      verify(() => mockGetCharacters.execute(null)).called(1);
    });

    test('should handle exception correctly', () async {
      // Arrange
      final exception = Exception('Server error');

      when(() => mockGetCharacters.execute(null))
          .thenThrow(exception);

      // Act & Assert
      expect(
        () => manager.getCharacters(),
        throwsA(equals(exception)),
      );
      verify(() => mockGetCharacters.execute(null)).called(1);
    });

    test('should call use case exactly once', () async {
      // Arrange
      final expectedPage = EPage<ECharacter>(
        count: 1,
        pages: 1,
        next: null,
        prev: null,
        results: [ECharacter(id: 1, name: 'Test')],
      );

      when(() => mockGetCharacters.execute(null))
          .thenAnswer((_) async => expectedPage);

      // Act
      await manager.getCharacters();

      // Assert
      verify(() => mockGetCharacters.execute(null)).called(1);
      verifyNoMoreInteractions(mockGetCharacters);
    });
  });

  group('MCharacterImp - getCharactersPage', () {
    const testPageUrl = 'character?page=2';

    test('should return EPage<ECharacter> for specific page', () async {
      // Arrange
      final expectedPage = EPage<ECharacter>(
        count: 826,
        pages: 42,
        next: 'https://rickandmortyapi.com/api/character?page=3',
        prev: 'https://rickandmortyapi.com/api/character?page=1',
        results: [
          ECharacter(id: 21, name: 'Aqua Morty'),
        ],
      );

      when(() => mockGetCharactersPage.execute(testPageUrl))
          .thenAnswer((_) async => expectedPage);

      // Act
      final result = await manager.getCharactersPage(testPageUrl);

      // Assert
      expect(result, equals(expectedPage));
      expect(result.next, contains('page=3'));
      expect(result.prev, contains('page=1'));
      verify(() => mockGetCharactersPage.execute(testPageUrl)).called(1);
    });

    test('should handle different page URLs', () async {
      // Arrange
      const page5Url = 'character?page=5';
      final expectedPage = EPage<ECharacter>(
        count: 826,
        pages: 42,
        next: 'https://rickandmortyapi.com/api/character?page=6',
        prev: 'https://rickandmortyapi.com/api/character?page=4',
        results: [
          ECharacter(id: 81, name: 'Character 81'),
        ],
      );

      when(() => mockGetCharactersPage.execute(page5Url))
          .thenAnswer((_) async => expectedPage);

      // Act
      final result = await manager.getCharactersPage(page5Url);

      // Assert
      expect(result.results!.first.id, 81);
      verify(() => mockGetCharactersPage.execute(page5Url)).called(1);
    });

    test('should propagate error when use case fails', () async {
      // Arrange
      const errorMessage = 'No se encontro ningun resultado';

      when(() => mockGetCharactersPage.execute(testPageUrl))
          .thenThrow(errorMessage);

      // Act & Assert
      expect(
        () => manager.getCharactersPage(testPageUrl),
        throwsA(equals(errorMessage)),
      );
      verify(() => mockGetCharactersPage.execute(testPageUrl)).called(1);
    });

    test('should handle exception correctly', () async {
      // Arrange
      final exception = Exception('Network error');

      when(() => mockGetCharactersPage.execute(testPageUrl))
          .thenThrow(exception);

      // Act & Assert
      expect(
        () => manager.getCharactersPage(testPageUrl),
        throwsA(equals(exception)),
      );
      verify(() => mockGetCharactersPage.execute(testPageUrl)).called(1);
    });

    test('should call use case with correct parameter', () async {
      // Arrange
      final expectedPage = EPage<ECharacter>(
        count: 1,
        pages: 1,
        next: null,
        prev: null,
        results: [],
      );

      when(() => mockGetCharactersPage.execute(testPageUrl))
          .thenAnswer((_) async => expectedPage);

      // Act
      await manager.getCharactersPage(testPageUrl);

      // Assert
      verify(() => mockGetCharactersPage.execute(testPageUrl)).called(1);
      verifyNoMoreInteractions(mockGetCharactersPage);
    });
  });

  group('MCharacterImp - Integration', () {
    test('should not interfere between different methods', () async {
      // Arrange
      final searchParam = ECharacter(name: 'Rick');
      final searchPage = EPage<ECharacter>(
        count: 10,
        pages: 1,
        next: null,
        prev: null,
        results: [ECharacter(id: 1, name: 'Rick Sanchez')],
      );

      final allCharactersPage = EPage<ECharacter>(
        count: 826,
        pages: 42,
        next: 'page2',
        prev: null,
        results: [ECharacter(id: 1, name: 'Rick Sanchez')],
      );

      when(() => mockSearchCharacter.execute(searchParam))
          .thenAnswer((_) async => searchPage);
      when(() => mockGetCharacters.execute(null))
          .thenAnswer((_) async => allCharactersPage);

      // Act
      final searchResult = await manager.searchCharacter(searchParam);
      final allResult = await manager.getCharacters();

      // Assert
      expect(searchResult.count, 10);
      expect(allResult.count, 826);
      verify(() => mockSearchCharacter.execute(searchParam)).called(1);
      verify(() => mockGetCharacters.execute(null)).called(1);
      verifyNever(() => mockGetCharactersPage.execute(any()));
    });
  });
}
