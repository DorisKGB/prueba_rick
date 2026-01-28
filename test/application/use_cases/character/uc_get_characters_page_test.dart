import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prueba_rick/application/repository/remote/r_character.dart';
import 'package:prueba_rick/application/use_cases/character/uc_get_characters_page.dart';
import 'package:prueba_rick/core/entities/e_character.dart';
import 'package:prueba_rick/core/entities/e_page.dart';

class MockRCharacter extends Mock implements RCharacter {}

void main() {
  late MockRCharacter mockRepository;
  late UCGetCharactersPage useCase;

  setUp(() {
    mockRepository = MockRCharacter();
    useCase = UCGetCharactersPage(rCharacter: mockRepository);
  });

  group('UCGetCharactersPage', () {
    const testPageUrl = 'character?page=2';

    test('should return EPage<ECharacter> for specific page', () async {
      // Arrange
      final expectedPage = EPage<ECharacter>(
        count: 826,
        pages: 42,
        next: 'https://rickandmortyapi.com/api/character?page=3',
        prev: 'https://rickandmortyapi.com/api/character?page=1',
        results: [
          ECharacter(
            id: 21,
            name: 'Aqua Morty',
            status: 'unknown',
            species: 'Humanoid',
            gender: 'Male',
          ),
        ],
      );

      when(() => mockRepository.getCharactersPage(testPageUrl))
          .thenAnswer((_) async => expectedPage);

      // Act
      final result = await useCase.execute(testPageUrl);

      // Assert
      expect(result, equals(expectedPage));
      expect(result.count, 826);
      expect(result.next, contains('page=3'));
      expect(result.prev, contains('page=1'));
      expect(result.results!.first.name, 'Aqua Morty');
      verify(() => mockRepository.getCharactersPage(testPageUrl)).called(1);
    });

    test('should handle first page without prev', () async {
      // Arrange
      const firstPageUrl = 'character?page=1';
      final firstPage = EPage<ECharacter>(
        count: 826,
        pages: 42,
        next: 'https://rickandmortyapi.com/api/character?page=2',
        prev: null,
        results: [
          ECharacter(id: 1, name: 'Rick Sanchez'),
        ],
      );

      when(() => mockRepository.getCharactersPage(firstPageUrl))
          .thenAnswer((_) async => firstPage);

      // Act
      final result = await useCase.execute(firstPageUrl);

      // Assert
      expect(result.prev, isNull);
      expect(result.next, isNotNull);
      verify(() => mockRepository.getCharactersPage(firstPageUrl)).called(1);
    });

    test('should handle last page without next', () async {
      // Arrange
      const lastPageUrl = 'character?page=42';
      final lastPage = EPage<ECharacter>(
        count: 826,
        pages: 42,
        next: null,
        prev: 'https://rickandmortyapi.com/api/character?page=41',
        results: [
          ECharacter(id: 826, name: 'Last Character'),
        ],
      );

      when(() => mockRepository.getCharactersPage(lastPageUrl))
          .thenAnswer((_) async => lastPage);

      // Act
      final result = await useCase.execute(lastPageUrl);

      // Assert
      expect(result.next, isNull);
      expect(result.prev, isNotNull);
      verify(() => mockRepository.getCharactersPage(lastPageUrl)).called(1);
    });

    test('should throw error when repository fails', () async {
      // Arrange
      when(() => mockRepository.getCharactersPage(testPageUrl))
          .thenThrow(Exception('Network error'));

      // Act & Assert
      expect(
        () => useCase.execute(testPageUrl),
        throwsA(isA<Exception>()),
      );
      verify(() => mockRepository.getCharactersPage(testPageUrl)).called(1);
    });

    test('should throw custom error message from repository', () async {
      // Arrange
      const errorMessage = 'No se encontro ningun resultado';
      when(() => mockRepository.getCharactersPage(testPageUrl))
          .thenThrow(errorMessage);

      // Act & Assert
      expect(
        () => useCase.execute(testPageUrl),
        throwsA(equals(errorMessage)),
      );
      verify(() => mockRepository.getCharactersPage(testPageUrl)).called(1);
    });

    test('should handle different page URLs correctly', () async {
      // Arrange
      const page5Url = 'character?page=5';
      final page5 = EPage<ECharacter>(
        count: 826,
        pages: 42,
        next: 'https://rickandmortyapi.com/api/character?page=6',
        prev: 'https://rickandmortyapi.com/api/character?page=4',
        results: [
          ECharacter(id: 81, name: 'Character 81'),
        ],
      );

      when(() => mockRepository.getCharactersPage(page5Url))
          .thenAnswer((_) async => page5);

      // Act
      final result = await useCase.execute(page5Url);

      // Assert
      expect(result.results!.first.id, 81);
      verify(() => mockRepository.getCharactersPage(page5Url)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
