import 'package:flutter/material.dart';

successMessage(content, context){
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(content),
      backgroundColor: Colors.green,
    )
  );
}

errorMessage(content, context){
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(content),
      backgroundColor: Theme.of(context).colorScheme.error,
    )
  );
}