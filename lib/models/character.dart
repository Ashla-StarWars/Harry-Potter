class Character {
  final String id;
  final String name;
  final List<String> alternateNames;
  final String species;
  final String gender;
  final String house;
  final String dateOfBirth;
  final int yearOfBirth;
  final bool wizard;
  final String ancestry;
  final String eyeColour;
  final String hairColour;
  final Wand wand;
  final String patronus;
  final bool hogwartsStudent;
  final bool hogwartsStaff;
  final String actor;
  final List<String> alternateActors;
  final bool alive;
  final String image;

  Character({
    required this.id,
    required this.name,
    required this.alternateNames,
    required this.species,
    required this.gender,
    required this.house,
    required this.dateOfBirth,
    required this.yearOfBirth,
    required this.wizard,
    required this.ancestry,
    required this.eyeColour,
    required this.hairColour,
    required this.wand,
    required this.patronus,
    required this.hogwartsStudent,
    required this.hogwartsStaff,
    required this.actor,
    required this.alternateActors,
    required this.alive,
    required this.image,
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      alternateNames: List<String>.from(json['alternate_names'] ?? []),
      species: json['species'] ?? '',
      gender: json['gender'] ?? '',
      house: json['house'] ?? '',
      dateOfBirth: json['dateOfBirth'] ?? '',
      yearOfBirth: json['yearOfBirth'] ?? 0,
      wizard: json['wizard'] ?? false,
      ancestry: json['ancestry'] ?? '',
      eyeColour: json['eyeColour'] ?? '',
      hairColour: json['hairColour'] ?? '',
      wand: Wand.fromJson(json['wand'] ?? {}),
      patronus: json['patronus'] ?? '',
      hogwartsStudent: json['hogwartsStudent'] ?? false,
      hogwartsStaff: json['hogwartsStaff'] ?? false,
      actor: json['actor'] ?? '',
      alternateActors: List<String>.from(json['alternate_actors'] ?? []),
      alive: json['alive'] ?? true,
      image: json['image'] ?? '',
    );
  }
}

class Wand {
  final String wood;
  final String core;
  final double? length;

  Wand({
    required this.wood,
    required this.core,
    this.length,
  });

  factory Wand.fromJson(Map<String, dynamic> json) {
    return Wand(
      wood: json['wood'] ?? '',
      core: json['core'] ?? '',
      length: json['length'] != null ? json['length'].toDouble() : null,
    );
  }
}