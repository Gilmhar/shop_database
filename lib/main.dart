import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ecommerce_sqflite/product_list.dart';

import 'package:ecommerce_sqflite/my_cart.dart';
import 'package:ecommerce_sqflite/notifier.dart'
;
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shop SQLite',
      theme: ThemeData(colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: Colors.purple,
      )),
      home: ChangeNotifierProvider(
        create:(context) =>  CartNotifier(), 
          child: const MyHomePage()),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop Sqlite'),
      ),
      body: _selectIndex == 0 ? ProductList() : MyCart(),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Shopping'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'My Cart'),
        ],
        currentIndex: _selectIndex,
        onTap: (index) {
          setState(() {
            _selectIndex = index;
          });
        },
      ),
    );
  }
}
