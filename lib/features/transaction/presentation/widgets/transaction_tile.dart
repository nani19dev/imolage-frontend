import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/commun/widgets/dialog/delete_dialog.dart';
import 'package:frontend/features/property/logic/bloc/apartment_bloc.dart';
import 'package:frontend/features/transaction/data/models/transaction.dart';
import 'package:frontend/features/transaction/logic/bloc/transaction_bloc.dart';

Widget incomingtransactionTile(TransactionModel transaction, context){
  return ListTile(
    leading: const CircleAvatar(
      backgroundColor: Color.fromARGB(255, 207, 197, 238),
      child: Text('T'),
    ),
    title: Text(transaction.type),
    subtitle: Text(transaction.date.toString(), style: const TextStyle(color: Colors.grey)),
    dense: true,
    onTap: () {},
    onLongPress: () {
      showDeleteConfirmationDialog(context, itemName: "transaction").then((shouldDelete) {
        if (shouldDelete == true) {
          BlocProvider.of<TransactionBloc>(context).add(TransactionDeleteEvent(transaction));
        } else {
          
        }
      });
    },
    trailing: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(transaction.amount.toString(), style: const TextStyle(fontWeight: FontWeight.w500)),
        //Icon(Icons.arrow_forward_ios, size: 16),
      ],
    ),
  );
}

Widget outgoingtransactionTile(TransactionModel transaction, context){
  return ListTile(
    leading: const CircleAvatar(
      backgroundColor: Color(0xFF6750A4), 
      child: Text('T'),
    ),
    title: Text(transaction.type),
    subtitle: Text(transaction.date.toString(), style: const TextStyle(color: Colors.grey)),
    dense: true,
    onTap: () {},
    onLongPress: () {
      showDeleteConfirmationDialog(context, itemName: "transaction").then((shouldDelete) {
        if (shouldDelete == true) {
          BlocProvider.of<TransactionBloc>(context).add(TransactionDeleteEvent(transaction));
        } else {
          
        }
      });
    },
    trailing: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(transaction.amount.toString(), style: const TextStyle(fontWeight: FontWeight.w500)),
        //Icon(Icons.arrow_forward_ios, size: 16),
      ],
    ),
  );
}
        