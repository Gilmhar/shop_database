import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ecommerce_sqflite/models.dart';
import 'package:ecommerce_sqflite/notifier.dart';
import 'package:ecommerce_sqflite/shop_database.dart';
import 'package:sqflite/sqflite.dart';

class MyCart extends StatelessWidget {
  MyCart({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CartNotifier>(
      builder: (context, cart, child) {
        return FutureBuilder(
          future: ShopDatabase.instance.getAllItems(),
          builder:
              (BuildContext context, AsyncSnapshot<List<CartItem>> snapshot) {
            if (snapshot.hasData) {
              List<CartItem> cartItems = snapshot.data!;
              return cartItems.isEmpty
                  ? const Center(
                      child: Text(
                        'Aún no hay productos en tu carrito.',
                        style: TextStyle(fontSize: 20),
                      ),
                    )
                  : ListView.separated(
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                            color: Colors.purple[100],
                            child: _CartItem(cartItems[index]));
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          const Divider(
                        height: 10,
                      ),
                      itemCount: cartItems.length,
                    );
            } else {
              return const Center(
                child: Text(
                  "No hay productos en tu carro",
                  style: TextStyle(fontSize: 20),
                ),
              );
            }
          });
      }
    );
  }
}

class _CartItem extends StatelessWidget {
  final CartItem cartItem;

  const _CartItem(this.cartItem);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DefaultTextStyle.merge(
        style: const TextStyle(fontSize: 20, color: Colors.white),
        child: Row(
          children: [
            Image.asset(
              'assets/images/otraLap.png',
              width: 100,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(cartItem.name),
                  Text('\$${cartItem.price}'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('${cartItem.quantity} unidades'),
                      ElevatedButton(onPressed: () async {
                        cartItem.quantity++;
                        await ShopDatabase.instance.update(cartItem);
                        Provider.of<CartNotifier>(context, listen: false).shouldRefresh();
                      }, style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(10),
                        minimumSize: Size.zero,
                      ), child: const Text("+"),),
                      ElevatedButton(onPressed: () async {
                        cartItem.quantity--;
                        if (cartItem.quantity == 0) {
                          await ShopDatabase.instance.delete(cartItem.id);
                        } else {
                          await ShopDatabase.instance.update(cartItem);
                        }
                        Provider.of<CartNotifier>(context, listen: false).shouldRefresh();
                      },style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(10),
                        minimumSize: Size.zero,
                      ), child: const Text("-"),)
                    ],
                  ),
                  Text('Total: \$ ${cartItem.totalPrice}'),
                  ElevatedButton(
                      onPressed: () async {
                        await ShopDatabase.instance.delete(cartItem.id);
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text("¡Producto eliminado!"),
                          duration: Duration(seconds: 1),
                        ));
                        Provider.of<CartNotifier>(context, listen: false).shouldRefresh();
                      },
                      child: const Text('Eliminar')),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
