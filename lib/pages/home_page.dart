import 'package:flutter/material.dart';
import 'package:habbit_tracker/components/my_drawer.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: const MyDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
    );
  }
}
