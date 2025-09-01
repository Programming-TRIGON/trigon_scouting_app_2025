import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trigon_scouting_app_2025/utilities/material_design_factory.dart';

import 'generator_4000_provider.dart';

class Generator4000Screen extends StatelessWidget {
  const Generator4000Screen({super.key});

  @override
  Widget build(BuildContext context) {
    final generatorProvider = context.watch<Generator4000Provider>();

    return Scaffold(
      appBar: MaterialDesignFactory.createAppBar(
        context,
        Colors.green,
        "המחלל 4000",
        generatorProvider.currentPage.title,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: generatorProvider.currentPage.build(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: generatorProvider.currentPage.index,
        onTap: (index) => generatorProvider.setCurrentPage(Generator4000Page.values[index]),
        backgroundColor: Colors.grey[800],
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        items: Generator4000Page.values
            .map(
              (page) =>
                  BottomNavigationBarItem(icon: page.icon, label: page.title),
            )
            .toList(),
      ),
    );
  }
}
