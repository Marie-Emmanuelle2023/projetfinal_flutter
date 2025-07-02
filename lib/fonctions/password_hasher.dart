import 'dart:convert';
import 'package:crypto/crypto.dart';

// Classe pour gérer le hachage des mots de passe
// Cette classe utilise l'algorithme SHA-256 pour sécuriser les mots de passe
class PasswordHasher {
  
  static String hashPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }
  
  static bool verifyPassword(String password, String hashedPassword) {
    String hashedInput = hashPassword(password);
    return hashedInput == hashedPassword;
  }

  static String generateSalt() {
    var random = DateTime.now().millisecondsSinceEpoch.toString();
    var bytes = utf8.encode(random);
    var digest = sha256.convert(bytes);
    return digest.toString().substring(0, 16);
  }

  static String hashPasswordWithSalt(String password, String salt) {
    String saltedPassword = password + salt;
    return hashPassword(saltedPassword);
  }
} 