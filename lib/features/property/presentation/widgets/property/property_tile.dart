import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/commun/widgets/dialog/delete_dialog.dart';
import 'package:frontend/config/routes/routes_names.dart';
import 'package:frontend/features/property/data/models/property.dart';
import 'package:frontend/features/property/logic/bloc/property_bloc.dart';
import 'package:go_router/go_router.dart';

Widget propertyTile(BuildContext context, PropertyModel property) {
  return Card(
    elevation: 5,
    child: InkWell(
      onTap: () {
        if(property.type == 'apartment'){
          context.pushNamed(routeApartmentDetail,
            pathParameters: {
              'propertyId': property.id!,
              'apartmentId': property.apartmentId!,
            } 
          );
        } else {
          context.pushNamed(routePropertDetail,
            pathParameters: {'propertyId': property.id!}
          );
        }
      },
      onLongPress: () {
        showDeleteConfirmationDialog(context, itemName: property.name).then((shouldDelete) {
          if (shouldDelete == true) {
            BlocProvider.of<PropertyBloc>(context).add(PropertyDeleteEvent(property.id!));
          } else {
            
          }
        });
      },
      child: Row(
        children: [
          Container(
            width: 120,
            height: 120,
            child: const Center(
              child: Icon(
                Icons.home, // Use property.type! for non-null access
                size: 60,
                color: Colors.grey,
              ),
            ),
            /*decoration: ShapeDecoration(
              image: const DecorationImage(
                image: NetworkImage("https://via.placeholder.com/120x120"),
                fit: BoxFit.fill,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),*/
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              //mainAxisSize: MainAxisSize.min,
              //mainAxisAlignment: MainAxisAlignment.start,
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  title: Text(property.name,
                    style: const TextStyle(
                      color: Color(0xFF1D1B20),
                      fontSize: 22,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w400,
                      height: 0.06,
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.home_filled),
                  title: Text(property.type),
                  dense: true,
                ),
                /*ListTile(
                  leading: const Icon(Icons.account_circle),
                  title: Text("2/5"),
                  dense: true,
                ),*/
                /*Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    const IconButton.filledTonal(
                      //iconSize: 72,
                      icon: Icon(Icons.favorite_border),
                      onPressed: null,
                    ),
                    const SizedBox(width: 8),
                    IconButton.filledTonal(
                      //iconSize: 72,
                      icon: const Icon(Icons.more_vert),
                      onPressed: () {},
                    ),
                    const SizedBox(width: 8),
                  ],
                ),*/
              ]
            )
          ),
        ],
      ),
    ),
  );
}