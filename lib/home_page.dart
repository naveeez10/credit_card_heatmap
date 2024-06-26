import 'package:credit_card_heatmap/heatmap/heat_map_widget.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber[50],
        title: const Text('Credit Card Heatmap'),
      ),
      body: const Center(
        child: HeatMapWidget(),
      ),
    );
  }
}
