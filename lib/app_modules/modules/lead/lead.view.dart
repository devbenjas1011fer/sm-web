import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LeadView extends StatelessWidget {
  const LeadView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lead'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.people_outline),
              title: const Text('Usuarios'),
              subtitle: const Text(
                'Usuarios disponibles para Lead',
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Get.toNamed('/lead/usuarios');
              },
            ),
          ),
        ],
      ),
    );
  }
}