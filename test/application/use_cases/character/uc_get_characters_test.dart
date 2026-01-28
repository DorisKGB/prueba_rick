import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prueba_rick/application/repository/remote/r_character.dart';
import 'package:prueba_rick/application/use_cases/character/uc_get_characters.dart';
import 'package:prueba_rick/core/entities/e_character.dart';
import 'package:prueba_rick/core/entities/e_page.dart';

class MockRCharacter extends Mock implements RCharacter {}

void main() {
  late MockRCharacter mockRepository;
  late UCGetCharacters useCase;

  setUp(() {
    mockRepository = MockRCharacter();
    useCase = UCGetCharacters(rlCharacter: mockRepository);
  });

  group('UCGetCharacters', () {
    test('should return EPage<ECharacter> from repository', () async {
      // Arrange
      final expectedPage = EPage<ECharacter>(
        count: 826,
        pages: 42,
        next: 'https://rickandmortyapi.com/api/character?page=2',
        prev: null,
        results: [
          ECharacter(
            id: 1,
            name: 'Rick Sanchez',
            status: 'Alive',
            species: 'Human',
            gender: 'Male',
          ),
          ECharacter(
            id: 2,
            name: 'Morty Smith',
            status: 'Alive',
            species: 'Human',
            gender: 'Male',
          ),
        ],
      );

      when(() => mockRepository.getCharacters())
          .thenAnswer((_) async => expectedPage);

      // Act
      final result = await useCase.execute(null);

      // Assert
      expect(result, equals(expectedPage));
      expect(result.count, 826);
      expect(result.pages, 42);
      expect(result.results!.length, 2);
      expect(result.results!.first.name, 'Rick Sanchez');
      verify(() => mockRepository.getCharacters()).called(1);
    });

    test('should return empty results when repository returns empty page', () async {
      // Arrange
      final emptyPage = EPage<ECharacter>(
        count: 0,
        pages: 0,
        next: null,
        prev: null,
        results: [],
      );

      when(() => mockRepository.getCharacters())
          .thenAnswer((_) async => emptyPage);

      // Act
      final result = await useCase.execute(null);

      // Assert
      expect(result.results, isEmpty);
      expect(result.count, 0);
      verify(() => mockRepository.getCharacters()).called(1);
    });

    test('should throw error when repository fails', () async {
      // Arrange
      when(() => mockRepository.getCharacters())
          .thenThrow(Exception('Network error'));

      // Act & Assert
      expect(
        () => useCase.execute(null),
        throwsA(isA<Exception>()),
      );
      verify(() => mockRepository.getCharacters()).called(1);
    });

    test('should throw custom error message from repository', () async {
      // Arrange
      const errorMessage = 'No se encontro ningun resultado';
      when(() => mockRepository.getCharacters())
          .thenThrow(errorMessage);

      // Act & Assert
      expect(
        () => useCase.execute(null),
        throwsA(equals(errorMessage)),
      );
      verify(() => mockRepository.getCharacters()).called(1);
    });

    test('should call repository exactly once', () async {
      // Arrange
      final expectedPage = EPage<ECharacter>(
        count: 1,
        pages: 1,
        next: null,
        prev: null,
        results: [
          ECharacter(id: 1, name: 'Test Character'),
        ],
      );

      when(() => mockRepository.getCharacters())
          .thenAnswer((_) async => expectedPage);

      // Act
      await useCase.execute(null);

      // Assert
      verify(() => mockRepository.getCharacters()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
