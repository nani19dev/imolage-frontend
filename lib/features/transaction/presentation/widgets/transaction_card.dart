import 'package:flutter/material.dart';
import 'package:frontend/config/routes/routes_names.dart';
import 'package:go_router/go_router.dart';

Widget transactionCard(BuildContext context, double balance){
  return Card(
    elevation: 0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text('${balance.toString()} EUR', style: Theme.of(context).textTheme.headlineSmall),
          FilledButton(
            onPressed: () => context.pushNamed(routeTransactionAdd,
              pathParameters: {
                //'propertyId': widget.propertyId!,
                //'apartmentId': widget.apartmentId!,
              }
            ),
            child: const Text("+  Transfer"),
          ),
        ],
      ),
    ),
  );
}