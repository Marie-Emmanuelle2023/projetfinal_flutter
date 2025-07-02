import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user.dart';
import '../models/recette.dart';
import 'password_hasher.dart';

// Classe pour gérer la base de données SQLite
// Cette classe contient toutes les opérations de base de données
// Elle utilise le pattern Singleton pour avoir une seule instance
class DatabaseHelper {
  // Instance unique de la base de données (pattern Singleton)
  // '_instance' est privé (commence par _) et final (ne peut pas être modifié)
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  // Variable pour stocker la connexion à la base de données
  // Elle est statique pour être partagée entre toutes les instances
  static Database? _database;

  // Constructeur privé pour le pattern Singleton
  // '_internal()' est privé, donc on ne peut pas créer d'instance avec 'new'
  DatabaseHelper._internal();

  // Méthode factory pour obtenir l'instance unique
  // 'factory' permet de retourner une instance existante au lieu d'en créer une nouvelle
  factory DatabaseHelper() => _instance;

  // Méthode pour obtenir la base de données
  // 'async' signifie que cette méthode est asynchrone (elle peut prendre du temps)
  Future<Database> get database async {
    // Si la base de données existe déjà, on la retourne
    if (_database != null) return _database!;

    // Sinon, on l'initialise
    _database = await _initDatabase();
    return _database!;
  }

  // Méthode pour initialiser la base de données
  // Cette méthode crée la base de données si elle n'existe pas
  Future<Database> _initDatabase() async {
    // Chemin où sera stockée la base de données
    // getDatabasesPath() retourne le dossier par défaut pour les bases de données
    String path = join(await getDatabasesPath(), 'users_database.db');

    // Création de la base de données
    return await openDatabase(
      path, // Chemin du fichier de base de données
      version: 1, // Version de la base de données (pour les migrations)
      onCreate: _onCreate, // Fonction appelée lors de la création
    );
  }

  // Méthode appelée lors de la création de la base de données
  // Cette méthode crée les tables nécessaires
  Future<void> _onCreate(Database db, int version) async {
    // Création de la table users avec SQL
    // INTEGER PRIMARY KEY AUTOINCREMENT : ID auto-incrémenté
    // TEXT NOT NULL : Champ texte obligatoire
    // UNIQUE : Valeur unique (pas de doublons)
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        pseudo TEXT UNIQUE NOT NULL,
        email TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL
      )
    ''');
    print('Table users créée avec succès!');

    // Table recettes
    await db.execute('''
      CREATE TABLE recettes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        description TEXT,
        ingredients TEXT,
        instructions TEXT,
        imagePath TEXT,
        isFavorite INTEGER DEFAULT 0
      )
    ''');
    print('Table recettes créée avec succès!');
  }

  // Méthode pour insérer un nouvel utilisateur (inscription)
  // Retourne l'ID de l'utilisateur créé ou -1 en cas d'erreur
  Future<int> insertUser(User user) async {
    final db = await database; // Obtient la connexion à la base de données

    try {
      // Hash du mot de passe avant stockage
      String hashedPassword = PasswordHasher.hashPassword(user.password!);

      // Création d'un nouvel utilisateur avec le mot de passe hashé
      User userWithHashedPassword = User(
        id: user.id,
        name: user.name,
        pseudo: user.pseudo,
        email: user.email,
        password: hashedPassword, // Mot de passe hashé
      );

      // Insertion de l'utilisateur dans la base de données
      // insert() retourne l'ID de la ligne insérée
      int id = await db.insert('users', userWithHashedPassword.toMap());
      print('Utilisateur inséré avec l\'ID: $id (mot de passe hashé)');
      return id;
    } catch (e) {
      // Gestion des erreurs
      // Si l'email existe déjà, on retourne -1
      if (e.toString().contains('UNIQUE constraint failed')) {
        print('Erreur: Cet email existe déjà');
        return -1;
      }
      print('Erreur lors de l\'insertion: $e');
      return -1;
    }
  }

  // Méthode pour vérifier les identifiants de connexion (login)
  // Retourne l'utilisateur si les identifiants sont corrects, sinon null
  Future<User?> loginUser(String email, String password) async {
    final db = await database;

    // Recherche de l'utilisateur avec l'email uniquement
    // On ne compare pas le mot de passe directement dans la requête SQL
    List<Map<String, dynamic>> maps = await db.query(
      'users', // Nom de la table
      where: 'email = ?', // Condition WHERE (email seulement)
      whereArgs: [email], // Paramètres de la condition
    );

    // Si on trouve un utilisateur avec cet email
    if (maps.isNotEmpty) {
      User user = User.fromMap(maps.first);

      // Vérification du mot de passe avec le hash stocké
      bool isPasswordCorrect = PasswordHasher.verifyPassword(
        password, // Mot de passe saisi par l'utilisateur
        user.password!, // Hash stocké dans la base de données
      );

      if (isPasswordCorrect) {
        print('Connexion réussie pour: ${user.email}');
        return user;
      } else {
        print('Mot de passe incorrect pour: ${user.email}');
        return null;
      }
    } else {
      print('Email non trouvé: $email');
      return null;
    }
  }

  // Méthode pour vérifier si un email existe déjà
  // Utile pour éviter les doublons lors de l'inscription
  Future<bool> emailExists(String email) async {
    final db = await database;

    // Requête pour chercher un utilisateur avec cet email
    List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );

    // Retourne true si l'email existe, false sinon
    return maps.isNotEmpty;
  }

  Future<bool> pseudoExists(String pseudo) async {
    final db = await database;

    // Requête pour chercher un utilisateur avec ce pseudo
    List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'pseudo = ?',
      whereArgs: [pseudo],
    );

    // Retourne true si le pseudo existe, false sinon
    return maps.isNotEmpty;
  }

  // Méthode pour obtenir un utilisateur (pour le debug)
  // Cette méthode récupère un utilisateur dans la base de données

  Future<User?> getUserById(int id) async {
    final db = await database;

    // Requête pour chercher un utilisateur avec cet ID
    List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );

    // Si on trouve un utilisateur, on le retourne
    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    } else {
      print('Aucun utilisateur trouvé avec l\'ID: $id');
      return null;
    }
  }

  // Méthode pour supprimer un utilisateur (optionnel)
  // Retourne le nombre de lignes supprimées
  Future<int> deleteUser(int id) async {
    final db = await database;

    // Suppression de l'utilisateur avec l'ID spécifié
    return await db.delete('users', where: 'id = ?', whereArgs: [id]);
  }

  

  // ----------------------------------------

  Future<int> insertRecette(Recette recette) async {
    final db = await database;
    try {
      int id = await db.insert('recettes', recette.toMap());
      return id;
    } catch (e) {
      print("Erreur lors de l'insertion de la recette : $e");
      return -1; // Retourne -1 en cas d'erreur
    }
  }

  Future<List<Recette>> getAllRecettes() async {
    final db = await database;
    final result = await db.query('recettes', orderBy: 'id DESC');
    return result.map((map) => Recette.fromMap(map)).toList();
  }

  Future<List<Recette>> getRecettes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('recettes');
    return List.generate(maps.length, (i) {
      return Recette.fromMap(maps[i]);
    });
  }

 

  Future<int> updateRecette(Recette recette) async {
    final db = await database;
    try {
      int result = await db.update(
        'recettes',
        recette.toMap(),
        where: 'id = ?',
        whereArgs: [recette.id],
      );
      return result;
    } catch (e) {
      print("Erreur lors de la mise à jour de la recette : $e");
      return -1; // Retourne -1 en cas d'erreur
    }
  }

  // Récupérer uniquement les recettes favorites
  Future<List<Recette>> getRecettesFavorites() async {
    final db = await database;
    final maps = await db.query(
      'recettes',
      where: 'isFavorite = ?',
      whereArgs: [1],
    );

    return List.generate(maps.length, (i) => Recette.fromMap(maps[i]));
  }

  // Mettre à jour une recette pour changer le statut favori
  Future<void> toggleFavorite(int recetteId, bool isFavorite) async {
    final db = await database;
    await db.update(
      'recettes',
      {'isFavorite': isFavorite ? 1 : 0},
      where: 'id = ?',
      whereArgs: [recetteId],
    );
  }

  Future<int> deleteRecette(int id) async {
    final db = await database;
    return await db.delete('recettes', where: 'id = ?', whereArgs: [id]);
  }

  // Méthode pour fermer la base de données
  // À appeler quand l'application se ferme
  Future<void> closeDatabase() async {
    final db = await database;
    await db.close();
  }
}
