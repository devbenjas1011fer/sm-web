import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FormsView extends StatelessWidget {
  const FormsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forms'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(
                Icons.description_outlined,
              ),
              title: const Text('Formularios'),
              subtitle: const Text(
                'Administrar formularios',
              ),
              trailing: const Icon(
                Icons.chevron_right,
              ),
              onTap: () {
                Get.toNamed('/forms/formularios');
              },
            ),
          ),
        ],
      ),
    );
  }
}