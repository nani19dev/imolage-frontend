import 'package:flutter/material.dart';
import 'package:frontend/features/property/data/models/property.dart';

Widget propertyCard(PropertyModel property){
    return Card(
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    IconButton.filledTonal(
                      //iconSize: 72,
                      icon: const Icon(Icons.add),
                      onPressed: () {},
                    ),
                    const SizedBox(width: 8),
                    IconButton.filledTonal(
                      //iconSize: 72,
                      icon: const Icon(Icons.edit),
                      onPressed: () {},
                    ),
                    const SizedBox(width: 8),
                    IconButton.filledTonal(
                      //iconSize: 72,
                      icon: const Icon(Icons.favorite_border),
                      onPressed: () {},
                    ),
                    const SizedBox(width: 8),
                    IconButton.filledTonal(
                      //iconSize: 72,
                      icon: const Icon(Icons.more_vert),
                      onPressed: () {},
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
              ]
            )
          ),
        ],
      ),
    );
  }