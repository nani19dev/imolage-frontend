import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:frontend/features/auth/data/repositories/token_repository.dart';
import 'package:frontend/features/contract/data/repositories/contract_repository.dart';
import 'package:frontend/features/property/data/repositories/apartment_repository.dart';
import 'package:frontend/features/property/data/repositories/property_repository.dart';
import 'package:go_router/go_router.dart';

class ListFieldPage extends StatefulWidget {
  final String objectType;
  final String? id;

  const ListFieldPage({
    super.key,
    required this.objectType,
    this.id
  });

  @override
  State<ListFieldPage> createState() => _ListFieldPageState();
}

class _ListFieldPageState extends State<ListFieldPage> {
  late Future<dynamic> _objects;

  Widget listOfObject(){
    return FutureBuilder<dynamic>(
      future: _objects,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          final objects = snapshot.data;
          return ListView.builder(
            itemCount: objects!.length,
            itemBuilder: (context, index) {
              final object = objects[index];
              return objectTile(object, context);
            },
          );
        } else if (snapshot.hasError) {
        return Center(
          child: Text('Error: ${snapshot.error}'),
        );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      }
    );
  }

  Widget objectTile(object, BuildContext context){
    return ListTile(
      leading: const CircleAvatar(
        backgroundColor: Color(0xFF6750A4), // Purple background from the image
        child: Text('P'),
      ),
      title: Text(object.name),
      //subtitle: const Text("transaction.date", style: TextStyle(color: Colors.grey)),
      dense: true,
      onTap: () {
        context.pop(object);
      },
      onLongPress: () {},
      trailing: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          //Text('- 100 EUR', style: TextStyle(fontWeight: FontWeight.w500)),
          //Icon(Icons.arrow_forward_ios, size: 16),
        ],
      ),
    );
  }

  _getList(String objectType, String? id) async {
    final accessToken = await  TokenRepository().getAccessToken();
    if (accessToken != null) {
      switch (objectType) {
        case 'property':
          return PropertyRepository().getAllProperties(accessToken);
        case 'apartment': 
          return ApartmentRepository().getAllApartments(accessToken, id!);
        case 'contract': 
          return ContractRepository().getAllContracts(accessToken, id!);
        default:
          return null;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _objects = _getList(widget.objectType, widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => context.pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(child: listOfObject())
          ],
        ),
      ),
    );
  }

}