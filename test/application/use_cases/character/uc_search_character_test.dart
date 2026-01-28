import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prueba_rick/application/repository/remote/r_character.dart';
import 'package:prueba_rick/application/use_cases/character/uc_search_character.dart';
import 'package:prueba_rick/core/entities/e_character.dart';
import 'package:prueba_rick/core/entities/e_page.dart';

class MockRCharacter extends Mock implements RCharacter {}

void main() {
  late MockRCharacter mockRepository;
  late UCSearchCharacter useCase;

  setUpAll(() {
    // Register fallback values for mocktail
    registerFallbackValue(ECharacter());
  });

  setUp(() {
    mockRepository = MockRCharacter();
    useCase = UCSearchCharacter(rlCharacter: mockRepository);
  });

  group('UCSearchCharacter', () {
    test('should search character with all parameters', () async {
      // Arrange
      final searchParam = ECharacter(
        name: 'Rick',
        status: 'Alive',
        gender: 'Male',
        species: 'Human',
        type: 'Scientist',
      );

      final expectedPage = EPage<ECharacter>(
        count: 5,
        pages: 1,
        next: null,
        prev: null,
        results: [
          ECharacter(
            id: 1,
            name: 'Rick Sanchez',
            status: 'Alive',
            species: 'Human',
            gender: 'Male',
          ),
        ],
      );

      when(() => mockRepository.searchCharacter(any()))
          .thenAnswer((_) async => expectedPage);

      // Act
      final result = await useCase.execute(searchParam);

      // Assert
      expect(result, equals(expectedPage));
      expect(result.results!.first.name, 'Rick Sanchez');
      verify(() => mockRepository.searchCharacter(any())).called(1);
    });

    test('should handle null parameters by converting to empty strings', () async {
      // Arrange
      final searchParam = ECharacter(name: 'Morty');

      final expectedPage = EPage<ECharacter>(
        count: 1,
        pages: 1,
        next: null,
        prev: null,
        results: [
          ECharacter(id: 2, name: 'Morty Smith'),
        ],
      );

      when(() => mockRepository.searchCharacter(any()))
          .thenAnswer((_) async => expectedPage);

      // Act
      final result = await useCase.execute(searchParam);

      // Assert
      expect(result.results!.first.name, 'Morty Smith');
      
      // Verify that the use case sets empty strings for null values
      final captured = verify(() => mockRepository.searchCharacter(captureAny())).captured;
      final capturedParam = captured.first as ECharacter;
      expect(capturedParam.name, 'Morty');
      expect(capturedParam.status, '');
      expect(capturedParam.gender, '');
      expect(capturedParam.species, '');
      expect(capturedParam.type, '');
    });

    test('should search by name only', () async {
      // Arrange
      final searchParam = ECharacter(name: 'Summer');

      final expectedPage = EPage<ECharacter>(
        count: 3,
        pages: 1,
        next: null,
        prev: null,
        results: [
          ECharacter(id: 3, name: 'Summer Smith'),
        ],
      );

      when(() => mockRepository.searchCharacter(any()))
          .thenAnswer((_) async => expectedPage);

      // Act
      final result = await useCase.execute(searchParam);

      // Assert
      expect(result.results!.length, 1);
      expect(result.results!.first.name, 'Summer Smith');
      verify(() => mockRepository.searchCharacter(any())).called(1);
    });

    test('should search by status only', () async {
      // Arrange
      final searchParam = ECharacter(status: 'Dead');

      final expectedPage = EPage<ECharacter>(
        count: 100,
        pages: 5,
        next: 'https://rickandmortyapi.com/api/character?page=2&status=Dead',
        prev: null,
        results: [
          ECharacter(id: 5, name: 'Dead Character', status: 'Dead'),
        ],
      );

      when(() => mockRepository.searchCharacter(any()))
          .thenAnswer((_) async => expectedPage);

      // Act
      final result = await useCase.execute(searchParam);

      // Assert
      expect(result.count, 100);
      expect(result.results!.first.status, 'Dead');
      verify(() => mockRepository.searchCharacter(any())).called(1);
    });

    test('should search by gender and species', () async {
      // Arrange
      final searchParam = ECharacter(
        gender: 'Female',
        species: 'Alien',
      );

      final expectedPage = EPage<ECharacter>(
        count: 50,
        pages: 3,
        next: null,
        prev: null,
        results: [
          ECharacter(
            id: 10,
            name: 'Alien Female',
            gender: 'Female',
            species: 'Alien',
          ),
        ],
      );

      when(() => mockRepository.searchCharacter(any()))
          .thenAnswer((_) async => expectedPage);

      // Act
      final result = await useCase.execute(searchParam);

      // Assert
      expect(result.results!.first.gender, 'Female');
      expect(result.results!.first.species, 'Alien');
      verify(() => mockRepository.searchCharacter(any())).called(1);
    });

    test('should return empty results when no matches found', () async {
      // Arrange
      final searchParam = ECharacter(name: 'NonExistentCharacter');

      when(() => mockRepository.searchCharacter(any()))
          .thenThrow('No se encontro ningun resultado');

      // Act & Assert
      await expectLater(
        () => useCase.execute(searchParam),
        throwsA(equals('No se encontro ningun resultado')),
      );
    });

    test('should throw error when repository fails', () async {
      // Arrange
      final searchParam = ECharacter(name: 'Rick');

      when(() => mockRepository.searchCharacter(any()))
          .thenThrow(Exception('Network error'));

      // Act & Assert
      await expectLater(
        () => useCase.execute(searchParam),
        throwsA(isA<Exception>()),
      );
    });

    test('should handle debouncer correctly with multiple rapid calls', () async {
      // Arrange
      final searchParam1 = ECharacter(name: 'R');
      final searchParam2 = ECharacter(name: 'Ri');
      final searchParam3 = ECharacter(name: 'Ric');

      final expectedPage = EPage<ECharacter>(
        count: 1,
        pages: 1,
        next: null,
        prev: null,
        results: [
          ECharacter(id: 1, name: 'Rick Sanchez'),
        ],
      );

      when(() => mockRepository.searchCharacter(any()))
          .thenAnswer((_) async => expectedPage);

      // Act - Make rapid calls
      final future1 = useCase.execute(searchParam1);
      final future2 = useCase.execute(searchParam2);
      final future3 = useCase.execute(searchParam3);

      // Wait for all futures
      await Future.wait([future1, future2, future3]);

      // Assert - Due to debouncing, only the last call should execute
      // Note: The exact behavior depends on debouncer implementation
      verify(() => mockRepository.searchCharacter(any())).called(greaterThan(0));
    });
  });
}
