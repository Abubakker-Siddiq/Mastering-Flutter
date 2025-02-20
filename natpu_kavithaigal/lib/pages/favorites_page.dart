import 'package:flutter/material.dart';
import 'package:natpu_kavithaigal/cards/quote_card.dart';
import 'package:provider/provider.dart';

import '../../providers/favorites_provider.dart';

class FavouritesPage extends StatefulWidget {
  const FavouritesPage({super.key});

  @override
  State<FavouritesPage> createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage> {

  @override
  Widget build(BuildContext context) {
    final favouriteQuotes = Provider.of<FavoritesProvider>(context).quotes;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        itemCount: favouriteQuotes.length,
        itemBuilder: (context, index) {
          final quote = favouriteQuotes[index];
          return Column(
            children: [
              QuoteCard(
                originalQuote: quote,
                quote: quote,
                wantToRemoveFromBookmarks: false,
                wantToRemoveFromFavorites: true,
              ),
              SizedBox(height: 10),
            ],
          );
        },
      ),
    );
  }
}
