class Spell {
  final String id;
  final String name;
  final String description;

  Spell({
    required this.id,
    required this.name,
    required this.description,
  });

  factory Spell.fromJson(Map<String, dynamic> json) {
    return Spell(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
    );
  }
}

  