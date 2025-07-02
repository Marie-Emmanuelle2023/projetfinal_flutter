import 'package:flutter/material.dart';
import '../models/user.dart';
import '../fonctions/database_helper.dart';
import 'package:projet_final/config/router.dart';

class ProfilScreen extends StatefulWidget {
  final User user;

  const ProfilScreen({super.key, required this.user});

  @override
  State<ProfilScreen> createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
  }

  String _getInitiales(String name, String pseudo) {
    String initials = '';

    if (name.isNotEmpty) {
      initials += name[0].toUpperCase();
    }

    if (pseudo.isNotEmpty) {
      initials += pseudo[0].toUpperCase();
    }

    return initials;
  }

  void _logout() {
    Navigator.pushReplacementNamed(context, AppRouter.homePageRouter,);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Vous êtes déconnecté")),
    );
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: const Color(0xFF0F1D13),
    appBar: AppBar(
      backgroundColor: Colors.green,
      title: const Text('Profil'),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context, true);
        },
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.logout),
          tooltip: 'Se déconnecter',
          onPressed: _logout,
        ),
      ],
    ),
    body: Padding(
      padding: const EdgeInsets.all(16),
      child: Center( 
        child: Column(
          mainAxisSize: MainAxisSize.min, 
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.green,
              child: Text(
                _getInitiales(widget.user.name, widget.user.pseudo),
                style: const TextStyle(
                  fontSize: 40,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Nom: ${widget.user.name}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'Pseudo: ${widget.user.pseudo}',
              style: const TextStyle(color: Colors.white70, fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'Email: ${widget.user.email}',
              style: const TextStyle(color: Colors.white70, fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ),
  );
}

}
