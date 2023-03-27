import 'package:ecommerce_sqflite/models.dart';
import 'package:ecommerce_sqflite/shop_database.dart';
import 'package:flutter/material.dart';

class ProductList extends StatelessWidget {
  ProductList({super.key});

  final products = [
    Product(1, 'Samsumg', 'AX-50 Pavilion', 2000),
    Product(2, 'MacBook', 'MacBook Pro 2', 8000),
    Product(3, 'ASUS', 'ACELERATE X', 4000),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          child: Container(
              color: Colors.purple[100], child: _ProductItem(products[index])),
          onTap: () async {
            await addToCart(products[index]);
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('¡Producto agregado!'),
              duration: Duration(seconds: 1),
            ));
          },
        );
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(
        height: 5,
      ),
      itemCount: products.length,
    );
  }

  Future<void> addToCart(Product product) async {
    final item = CartItem(
        id: product.id, name: product.name, price: product.price, quantity: 1);
    await ShopDatabase.instance.insert(item);
  }
}

class _ProductItem extends StatelessWidget {
  final Product product;

  const _ProductItem(this.product);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Image.asset(
            'assets/images/otraLap.png',
            width: 100,
          ),
          const Padding(padding: EdgeInsets.only(right: 3, left: 3)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(product.name),
              Text(product.description),
              Text('\$${product.price}'),
            ],
          )
        ],
      ),
    );
  }
}
