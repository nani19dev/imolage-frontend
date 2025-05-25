import 'package:flutter/material.dart';

Future<bool?> showDeleteConfirmationDialog(BuildContext context, {String? itemName, int? itemCount}) async {
  String titleText;
  String contentText;

  if (itemName != null && itemCount == null) {
    titleText = 'Confirm Delete';
    contentText = 'Are you sure you want to delete "$itemName"?';
  } else if (itemName == null && itemCount != null && itemCount > 1) {
    titleText = 'Confirm Delete';
    contentText = 'Are you sure you want to delete $itemCount items?';
  } else if (itemName != null && itemCount != null && itemCount > 1) {
    titleText = 'Confirm Delete';
    contentText = 'Are you sure you want to delete $itemCount "$itemName" items?';
  } else {
    titleText = 'Confirm Delete';
    contentText = 'Are you sure you want to delete this item?';
  }

  return showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(titleText),
        content: Text(contentText),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      );
    },
  );
}