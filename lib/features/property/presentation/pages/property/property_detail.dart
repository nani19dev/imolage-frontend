import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/commun/widgets/snackbar.dart';
import 'package:frontend/config/routes/routes_names.dart';
import 'package:frontend/features/auth/logic/bloc/auth_bloc.dart';
import 'package:frontend/features/property/logic/bloc/apartment_bloc.dart';
import 'package:frontend/features/property/logic/bloc/property_bloc.dart';
import 'package:frontend/features/property/presentation/widgets/apartment/apartment_tile.dart';
import 'package:frontend/features/property/presentation/widgets/property/property_card.dart';
import 'package:go_router/go_router.dart';

class PropertyDetailPage extends StatefulWidget {
  final String? propertyId;
  const PropertyDetailPage({
    super.key,
    this.propertyId
  });

  @override
  State<PropertyDetailPage> createState() => _PropertyDetailPageState();
}

class _PropertyDetailPageState extends State<PropertyDetailPage> {

  Widget futureProperty(PropertyState state) {
    if (state is PropertyLoaded) {
      return propertyCard(state.property);
    } else if (state is PropertyError) {
      return Center(child: Text(state.error));
    }
    return const Center(child: CircularProgressIndicator());
  }

  Widget listOfApartments(ApartmentState state) {
    if (state is ApartmentsLoaded) {
      return ListView.builder(
        itemCount: state.apartments.length,
        itemBuilder: (BuildContext context, int index) => apartmentTile(
          state.apartments[index],
          context,
        ),
      );
    } else if (state is ApartmentError) {
      return Center(child: Text(state.error));
    } 
    return const Center(child: CircularProgressIndicator());
  }

  @override
  void initState() {
    super.initState();
    context.read<PropertyBloc>().add(PropertyLoadEvent(widget.propertyId!)); //fix later
    context.read<ApartmentBloc>().add(ApartmentsLoadEvent(widget.propertyId!)); //fix later
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Property Detail'),
        leading: BackButton(
          onPressed: () {
            context.read<PropertyBloc>().add(PropertiesLoadEvent());
            context.pop();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add), 
            tooltip: 'Add Apartment',
            onPressed: () => context.pushNamed(routeApartmentAdd,
              pathParameters: {'propertyId': widget.propertyId!}
            ), 
          )
        ],
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<PropertyBloc, PropertyState>(
            listener: (BuildContext context, PropertyState state) {
              if (state is PropertyError) {
                errorMessage(state.error, context);
              }
            },
          ),
          BlocListener<ApartmentBloc, ApartmentState>(
            listener: (BuildContext context, ApartmentState state) {
              if (state is ApartmentError) {
                errorMessage(state.error, context);
              }
            },
          ),
        ],
        child: Column(
          children: [
            BlocBuilder<PropertyBloc, PropertyState>(
              builder: (BuildContext context, PropertyState state) {
                return futureProperty(state);
              },
            ),
            const Text(
              'Apartments',
              style: TextStyle(
                color: Color(0xFF1D1B20),
                fontSize: 24,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: BlocBuilder<ApartmentBloc, ApartmentState>(
                builder: (BuildContext context, ApartmentState state) {
                  return listOfApartments(state);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}