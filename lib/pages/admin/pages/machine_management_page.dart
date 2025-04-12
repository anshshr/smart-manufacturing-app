import 'package:flutter/material.dart';
import 'package:smart_manufacturing/pages/admin/pages/inventory_assets_map.dart';
import 'package:smart_manufacturing/widgets/custom_appbar.dart';

class MachineManagementPage extends StatefulWidget {
  const MachineManagementPage({super.key});

  @override
  State<MachineManagementPage> createState() => _MachineManagementPageState();
}

class _MachineManagementPageState extends State<MachineManagementPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Column(children: [Expanded(child: InventoryAssetsMap())]),
    );
  }
}
