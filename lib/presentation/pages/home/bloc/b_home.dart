import 'dart:developer';

import 'package:bpstate/bpstate.dart';
import 'package:prueba_rick/application/manager/adapters/m_character.dart';
import 'package:prueba_rick/core/entities/e_character.dart';
import 'package:prueba_rick/core/entities/e_page.dart';
import 'package:rxdart/rxdart.dart';

class BHome extends BlocBase {
  final MCharacter mCharacter; 

  BHome({required this.mCharacter}){
    getCharacters();
  }

  @override
  void dispose() {
    _page.close();
    _searchInput.close();
    _selectedGenderInput.close();
    _selectedStatusInput.close();
    _selectedSpeciesInput.close();
    _selectedTypeInput.close();
    _isLoading.close();
    
  }

  final _page = BehaviorSubject<EPage<ECharacter>?>();
  EPage<ECharacter>? get page => _page.valueOrNull;
  Function(EPage<ECharacter>?) get inPage => _page.sink.add;
  Stream<EPage<ECharacter>?> get outPage => _page.stream;

  final _searchInput = BehaviorSubject<String>();
  String get searchInput => _searchInput.valueOrNull?? '';
  Function(String) get inSearchInput => _searchInput.sink.add;
  Stream<String> get outSearchInput => _searchInput.stream.doOnData((String onData){
    setFilter();
  });

  final _selectedGenderInput = BehaviorSubject<String?>();
  String? get selectedGenderInput => _selectedGenderInput.valueOrNull;
  Function(String?) get inSelectedGenderInput => _selectedGenderInput.sink.add;
  Stream<String?> get outSelectedGenderInput => _selectedGenderInput.stream.doOnData((String? onData){
    setFilter();
  });

  final _selectedStatusInput = BehaviorSubject<String?>();
  String? get selectedStatusInput => _selectedStatusInput.valueOrNull;
  Function(String?) get inSelectedStatusInput => _selectedStatusInput.sink.add;
  Stream<String?> get outSelectedStatusInput => _selectedStatusInput.stream.doOnData((String? onData){
    setFilter();
  });

  final _selectedSpeciesInput = BehaviorSubject<String>.seeded('');
  String get selectedSpeciesInput => _selectedSpeciesInput.valueOrNull?? '';
  Function(String) get inSelectedSpeciesInput => _selectedSpeciesInput.sink.add;
  Stream<String> get outSelectedSpeciesInput => _selectedSpeciesInput.stream.doOnData((String onData){
    setFilter();
  });

  final _selectedTypeInput = BehaviorSubject<String>.seeded('');
  String get selectedTypeInput => _selectedTypeInput.valueOrNull?? '';
  Function(String) get inSelectedTypeInput => _selectedTypeInput.sink.add;
  Stream<String> get outSelectedTypeInput => _selectedTypeInput.stream.doOnData((String onData){
    setFilter();
  });

  final _isLoading = BehaviorSubject<bool>.seeded(false);
  bool get isLoading => _isLoading.valueOrNull?? false;
  Function(bool) get inLoading => _isLoading.sink.add;
  Stream<bool> get outLoading => _isLoading.stream;

  Future<void> setFilter() async {
    try {
      final filter = ECharacter()
      ..name= searchInput
      ..status= selectedStatusInput
      ..gender= selectedGenderInput
      ..species= selectedSpeciesInput
      ..type= selectedTypeInput
      ;
      await searchCharacter(filter);      
    } catch (e) {
      _page.addError(e.toString());
    }
  }

  Future<void> searchCharacter(ECharacter param) async {
    try {   
      inPage(null);
      final result= await mCharacter.searchCharacter(param);
      inPage(result);
      
    } catch (e) {
      _page.addError(e.toString());
    }
  }  
  
  Future<void> resetFilter() async {
    try {
      final filter = ECharacter();
      inSearchInput('');
      inSelectedGenderInput(null);
      inSelectedStatusInput(null);
      inSelectedSpeciesInput('');
      inSelectedTypeInput('');
      await searchCharacter(filter);      
    } catch (e) {
      _page.addError(e.toString());
    }
  }

  Future<void> getCharacters() async {
    try {
      final result= await mCharacter.getCharacters();
      inPage(result);      
    } catch (e) {
      _page.addError(e.toString());
    }
  }
  Future<void> loadNextPage() async {
    try {
      if (page?.next == null) return;
      if (isLoading) return;
      inLoading(true);
      final EPage<ECharacter> result = await mCharacter.getCharactersPage(page!.next!);
      final List<ECharacter> currentResults = page!.results ?? [];
      final List<ECharacter> newResults = result.results ?? [];
      
      result.results = [...currentResults, ...newResults];
      inPage(result);
      inLoading(false);
    } catch (e) {
      _page.addError(e.toString());
      inLoading(false);
    }
  }
}
