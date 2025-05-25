import 'package:flutter/material.dart';
import 'package:frontend/features/contract/data/models/contract.dart';

class ContractDetailPage extends StatelessWidget {
  final ContractModel contract;
  const ContractDetailPage({super.key, required this.contract});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contract Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Contract ID: ${contract.id}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16.0),
            Text('Start Date: ${contract.startDate.toIso8601String()}'),
            const SizedBox(height: 8.0),
            Text('End Date: ${contract.endDate}'),
            const SizedBox(height: 16.0),
            Text("Monthly Rent: ${contract.rent} €"),
            const SizedBox(height: 8.0),
            Text(
              "Current Rent Paid: ${contract.currentRentPaid} €",
            ),
            const SizedBox(height: 16.0),
            Text('Status: ${contract.status}'),
            const SizedBox(height: 16.0),
            /*if (contract.landlordIds != null) ...[
              const Text("Landlord(s):"),
              const SizedBox(height: 8.0),
              // Replace with widget to display landlord details based on IDs
              Text(
                "... (Display landlord details here)",
              ),
            ],*/
            // Add a similar section to display tenant details if needed
          ],
        ),
      ),
    );
  }
}