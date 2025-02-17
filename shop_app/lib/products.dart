import 'package:flutter/material.dart';
import 'package:shop_app/product_card.dart';
import 'package:shop_app/product_details_page.dart';

class Products extends StatefulWidget {
  final List<Map<String, Object>> products;

  const Products({super.key, required this.products});

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.products.length,
      itemBuilder: (context, index) {
        final product = widget.products[index];
        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return ProductDetailsPage(product: product);
                },
              ),
            );
          },
          child: Product(
            title: product['title'] as String,
            price: product['price'] as double,
            image: product['imageUrl'] as String,
            containerColor:
                index.isEven
                    ? const Color.fromRGBO(216, 240, 253, 1)
                    : const Color.fromRGBO(245, 247, 249, 1),
          ),
        );
      },
    );
  }
}
