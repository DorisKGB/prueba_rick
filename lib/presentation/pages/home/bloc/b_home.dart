import 'dart:developer';

import 'package:bpstate/bpstate.dart';
import 'package:prueba_rick/application/manager/adapters/m_character.dart';
import 'package:prueba_rick/core/entities/e_character.dart';
import 'package:prueba_rick/core/entities/e_page.dart';
import 'package:rxdart/rxdart.dart';

class BHome extends BlocBase {
  final MCharacter mCharacter; 

  BHome({required this.mCharacter}){
    searchCharacter(ECharacter());
  }

  @override
  void dispose() {
    _page.close();
  }

  final _page = BehaviorSubject<EPage<ECharacter>>();
  EPage<ECharacter> get page => _page.valueOrNull ?? EPage(
    count: 0,
    pages: 0,
    next: '',
    prev: '',
    results: [],
  );
  Function(EPage<ECharacter>) get inPage => _page.sink.add;
  Stream<EPage<ECharacter>> get outPage => _page.stream;

  final _searchInput = BehaviorSubject<String>();
  String get searchInput => _searchInput.value;
  Function(String) get inSearchInput => _searchInput.sink.add;
  Stream<String> get outSearchInput => _searchInput.stream.doOnData((String onData){
    setFilter();
  });

  final _selectedGenderInput = BehaviorSubject<String>.seeded('');
  String get selectedGenderInput => _selectedGenderInput.valueOrNull?? '';
  Function(String) get inSelectedGenderInput => _selectedGenderInput.sink.add;
  Stream<String> get outSelectedGenderInput => _selectedGenderInput.stream.doOnData((String onData){
    setFilter();
  });

  final _selectedStatusInput = BehaviorSubject<String>.seeded('');
  String get selectedStatusInput => _selectedStatusInput.valueOrNull?? '';
  Function(String) get inSelectedStatusInput => _selectedStatusInput.sink.add;
  Stream<String> get outSelectedStatusInput => _selectedStatusInput.stream.doOnData((String onData){
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

  Future<void> searchCharacter(ECharacter param) async {
    try {      
      final result= await mCharacter.searchCharacter(param);
      inPage(result);
      
    } catch (e) {
      Future.error(e);
    }
  }
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
      Future.error(e);
    }
  }
}
