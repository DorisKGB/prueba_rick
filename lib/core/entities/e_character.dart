import 'package:prueba_rick/core/entities/e_location.dart';
import 'package:prueba_rick/core/entities/e_origin.dart';

class ECharacter {
  int? id;
  String? name;
  String? status;
  String? species;
  String? type;
  String? gender;
  EOrigin? origin;
  ELocation? location;
  String? image;
  List<String>? episode;
  String? url;
  int? created;

  ECharacter({
    this.id,
    this.name,
    this.status,
    this.species,
    this.type,
    this.gender,
    this.origin,
    this.location,
    this.image,
    this.episode,
    this.url,
    this.created,
  });
}