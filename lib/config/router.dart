import 'package:flutter/material.dart';
import 'package:projet_final/models/user.dart';
import 'package:projet_final/models/recette.dart';

// Pages
import 'package:projet_final/pages/formulaires/connexion.dart';
import 'package:projet_final/pages/formulaires/inscription.dart';
import 'package:projet_final/pages/homepage.dart';
import 'package:projet_final/pages/homescreen.dart';
import 'package:projet_final/pages/main_screen.dart';
import 'package:projet_final/pages/add_recette.dart';
import 'package:projet_final/pages/detail_recette.dart';
import 'package:projet_final/pages/favoris.dart';
import 'package:projet_final/pages/profil.dart';

class AppRouter {
  // Routes constantes
  static const String rootRouter = '/'; // Route initiale
  static const String connexionRouter = '/connexion';
  static const String inscriptionRouter = '/inscription';
  static const String homePageRouter = '/home';
  static const String homeRouter = '/accueil';
  static const String mainRouter = '/main';
  static const String addRecetteRouter = '/ajouterRecette';
  static const String detailRouter = '/detail';
  static const String favorisRouter = '/favoris';
  static const String profilRouter = '/profil';

  // Routeur central
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case rootRouter:
        final user = settings.arguments as User?;
        if (user != null) {
          return MaterialPageRoute(builder: (_) => MainScreen(user: user));
        } else {
          // Pas d'utilisateur, renvoyer vers la page de connexion ou accueil non connecté
          return MaterialPageRoute(builder: (_) => const  HomePage());
        }

      case connexionRouter:
        return MaterialPageRoute(builder: (_) => const LoginForm());

      case inscriptionRouter:
        return MaterialPageRoute(builder: (_) => const RegisterForm());

      case homePageRouter:
        return MaterialPageRoute(builder: (_) => const HomePage());

      case homeRouter:
        return MaterialPageRoute(builder: (_) => const HomeScreen());

      case mainRouter:
        final user = settings.arguments as User;
        return MaterialPageRoute(builder: (_) => MainScreen(user: user));

      case addRecetteRouter:
        return MaterialPageRoute(builder: (_) => const AddRecipeScreen());

      case favorisRouter:
        return MaterialPageRoute(builder: (_) => const FavorisScreen());

      case detailRouter:
        final recette = settings.arguments as Recette;
        return MaterialPageRoute(
          builder: (_) => DetailScreen(recette: recette),
        );

      case profilRouter:
        final user = settings.arguments as User;
        return MaterialPageRoute(builder: (_) => ProfilScreen(user: user));

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.red,
              title: const Text("Page Introuvable"),
              foregroundColor: Colors.white,
            ),
            body: Builder(
              builder: (context) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 64,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Route inconnue : ${settings.name}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                          context,
                          connexionRouter,
                        );
                      },
                      child: const Text('Retour à la connexion'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
    }
  }
}
