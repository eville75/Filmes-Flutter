import 'package:json_annotation/json_annotation.dart';

part 'pokemon.g.dart';

@JsonSerializable()
class Pokemon {
  final int id;
  final String name;
  final String imageUrl;
  final List<String>? types;
  final double? height;
  final double? weight;

  Pokemon({
    required this.id,
    required this.name,
    required this.imageUrl,
    this.types,
    this.height,
    this.weight,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) =>
      _$PokemonFromJson(json);

  Map<String, dynamic> toJson() => _$PokemonToJson(this);
}
