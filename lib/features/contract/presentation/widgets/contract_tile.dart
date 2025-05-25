import 'package:flutter/material.dart';
import 'package:frontend/config/routes/routes_names.dart';
import 'package:frontend/features/contract/data/models/contract.dart';
import 'package:go_router/go_router.dart';

  Widget contractTile(ContractModel contract, BuildContext context) {
    return Card(
      elevation: 5,
      child: InkWell(
        onTap: () => context.pushNamed(routeContractDetail,
        extra: contract
          /*pathParameters: {
            'propertyId': apartment.propertyId,
            'apartmentId': apartment.id!,
          }*/  
        ),
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
                  const ListTile(
                    title: Text(
                      "Contract",
                      style: TextStyle(
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
                    title: Text(contract.status!),
                    dense: true,
                  ),
                  /*ListTile(
                    leading: const Icon(Icons.account_circle),
                    title: Text(""),
                    dense: true,
                  ),*/
                  /*ListTile(
                    leading: Icon(Icons.account_circle),
                    title: Text("-200"),
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