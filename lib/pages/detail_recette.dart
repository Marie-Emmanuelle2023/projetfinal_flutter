import 'dart:io';
import 'package:flutter/material.dart';
import '../../models/recette.dart';
import '../../fonctions/database_helper.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class DetailScreen extends StatefulWidget {
  final Recette recette;

  const DetailScreen({super.key, required this.recette});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late Recette _recette;
  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _recette = widget.recette;
  }

  Future<void> _toggleFavorite() async {
    setState(() {
      _recette.isFavorite = !_recette.isFavorite;
    });
    await _dbHelper.updateRecette(_recette);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1D13),
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text('Détails de la recette'),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              _recette.isFavorite ? Icons.bookmark : Icons.bookmark_border,
              color: Colors.white,
            ),
            onPressed: _toggleFavorite,
            tooltip: _recette.isFavorite
                ? 'Retirer des favoris'
                : 'Ajouter aux favoris',
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_recette.imagePath != null && _recette.imagePath!.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.file(
                  File(_recette.imagePath!),
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              )
            else
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.green[700],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.fastfood,
                  color: Colors.white,
                  size: 64,
                ),
              ),
            const SizedBox(height: 20),
            Text(
              _recette.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _recette.description,
              style: const TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              'Ingrédients',
              style: TextStyle(
                color: Colors.green,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _recette.ingredients,
              style: const TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              'Instructions',
              style: TextStyle(
                color: Colors.green,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _recette.instructions,
              style: const TextStyle(color: Colors.white70, fontSize: 16),
            ),
            RatingBar.builder(
              initialRating: 3,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) =>
                  Icon(Icons.star, color: Colors.amber),
              onRatingUpdate: (rating) {
                print(rating);
              },
            ),
          ],
        ),
      ),
    );
  }
}
