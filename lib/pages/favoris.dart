import 'dart:io';
import 'package:flutter/material.dart';
import '../models/recette.dart';
import '../fonctions/database_helper.dart';
import '../config/router.dart';

class FavorisScreen extends StatefulWidget {
  const FavorisScreen({super.key});

  @override
  State<FavorisScreen> createState() => _FavorisScreenState();
}

class _FavorisScreenState extends State<FavorisScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Recette> _favoris = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavoris();
  }

  Future<void> _loadFavoris() async {
    final allRecettes = await _dbHelper.getRecettes();
    final favoris = allRecettes.where((r) => r.isFavorite).toList();
    setState(() {
      _favoris = favoris;
      _isLoading = false;
    });
  }

  void _toggleFavorite(Recette recette) async {
    recette.isFavorite = !recette.isFavorite;
    await _dbHelper.updateRecette(recette);
    _loadFavoris();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1D13),
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text('Recettes favorites'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, AppRouter.mainRouter);
          },
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.green))
          : _favoris.isEmpty
              ? const Center(
                  child: Text(
                    "Aucune recette favorite pour le moment.",
                    style: TextStyle(color: Colors.white70, fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: _favoris.length,
                  itemBuilder: (context, index) {
                    final recette = _favoris[index];
                    return Card(
                      color: Colors.white10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12),
                        leading: recette.imagePath != null && recette.imagePath!.isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  File(recette.imagePath!),
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Colors.green[700],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.bookmark,
                                  color: Colors.white,
                                ),
                              ),
                        title: Text(
                          recette.title,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                        subtitle: Text(
                          recette.description,
                          style: const TextStyle(color: Colors.white70),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.bookmark_remove, color: Colors.green),
                          onPressed: () => _toggleFavorite(recette),
                        ),
                        onTap: () async {
                          final result = await Navigator.pushNamed(
                            context,
                            AppRouter.detailRouter,
                            arguments: recette,
                          );
                          if (result == true) {
                            _loadFavoris();
                          }
                        },
                      ),
                    );
                  },
                ),
    );
  }
}
