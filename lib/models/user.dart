class User {
  final int? id;
  final String name;
  final String pseudo;
  final String email;
  final String password; 

  User({
    this.id,
    required this.name,
    required this.pseudo,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'pseudo': pseudo,
      'email': email,
      'password': password, 
    };
  }

  static User fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      pseudo: map['pseudo'],
      email: map['email'],
      password: map['password'], 
    );
  }

  @override
  String toString() {
    return 'User(id: $id, name: $name, pseudo: $pseudo, email: $email)';
  }
}