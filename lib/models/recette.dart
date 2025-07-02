class Recette {
  int? id;
  String title;
  String description;
  String ingredients;
  String instructions;
  String imagePath;
  bool isFavorite;

  Recette({
    this.id,
    required this.title,
    required this.description,
    required this.ingredients,
    required this.instructions,
    required this.imagePath,
    this.isFavorite = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'ingredients': ingredients,
      'instructions': instructions,
      'imagePath': imagePath,
      'isFavorite': isFavorite ? 1 : 0,
    };
  }

  factory Recette.fromMap(Map<String, dynamic> map) {
    return Recette(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      ingredients: map['ingredients'],
      instructions: map['instructions'],
      imagePath: map['imagePath'],
      isFavorite: map['isFavorite'] == 1,
    );
  }



  @override
  String toString() {
    return 'Recette(id: $id, title: $title,description:$description,ingredients:$ingredients,instructions:$instructions, imagePath: $imagePath), isFavorite: $isFavorite)';
  }
}
