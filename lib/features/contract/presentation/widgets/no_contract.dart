import 'package:flutter/material.dart';

class NoActiveContract extends StatelessWidget {
  const NoActiveContract({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Create a contract'),
            
          ],
        ),
      ),
    );
  }
}