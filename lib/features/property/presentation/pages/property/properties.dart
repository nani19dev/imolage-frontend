import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/commun/widgets/snackbar.dart';
import 'package:frontend/config/routes/routes_names.dart';
import 'package:frontend/features/auth/logic/bloc/auth_bloc.dart';
import 'package:frontend/features/property/logic/bloc/property_bloc.dart';
import 'package:frontend/features/property/presentation/widgets/property/property_tile.dart';
import 'package:go_router/go_router.dart';

class PropertiesPage extends StatefulWidget {
  const PropertiesPage({super.key});

  @override
  State<PropertiesPage> createState() => _PropertiesPageState();
}

class _PropertiesPageState extends State<PropertiesPage> {

  Widget listOfProperties(PropertyState state) {
    if (state is PropertiesLoaded) {
      return ListView.builder(
        itemCount: state.properties.length,
        itemBuilder: (BuildContext context, int index) => propertyTile(
          context,
          state.properties[index]
        )
      );
    } else if (state is PropertyError) {
      return Center(child: Text(state.error));
    } 
    return const Center(child: CircularProgressIndicator());
  }

  @override
  void initState() {
    super.initState();
    context.read<PropertyBloc>().add(PropertiesLoadEvent());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Imolage'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add Property',
            onPressed: () => context.goNamed(routePropertyAdd),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () => context.read<AuthBloc>().add(SignOutEvent()),
          )
        ],
      ),
      body: BlocConsumer<PropertyBloc, PropertyState>(
        listener: (BuildContext context, PropertyState state) {
          if (state is PropertyError) {
            errorMessage(state.error.toString(), context);
          }
        },
        builder: (BuildContext context, PropertyState state) {
          return Column(
            children: [
              const Text(
                'Properties',
                style: TextStyle(
                  color: Color(0xFF1D1B20),
                  fontSize: 24,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                ),
              ),
                //const SizedBox(height: 16),
              Expanded(child: listOfProperties(state)),
            ],
          );
        },
      )
    );
  }
}
