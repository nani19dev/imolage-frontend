import 'package:flutter/material.dart';
import 'package:frontend/features/contract/logic/bloc/contract_bloc.dart';
import 'package:frontend/features/contract/presentation/widgets/contract_card.dart';
import 'package:frontend/features/contract/presentation/widgets/contract_tile.dart';

class TabContracts extends StatelessWidget {
  final ContractState state;

  const TabContracts({super.key, required this.state});

  Widget futureContractCard(BuildContext context, ContractState state) {
    return contractCard(context);
    /*if (state is ContractLoaded) {
      return contractCard(context);
    } else if (state is ContractError) {
      return Center(child: Text(state.error));
    }
    return const Center(child: CircularProgressIndicator());*/
  }

  Widget listOfContracts(ContractState state) {
    if (state is ContractsLoaded) {
      return ListView.builder(
        itemCount: state.contracts.length,
        itemBuilder: (BuildContext context, int index) => contractTile(
          state.contracts[index],
          context,
        ),
      );
    } else if (state is ContractError) {
      return Center(child: Text(state.error));
    } 
    return const Center(child: CircularProgressIndicator());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        futureContractCard(context, state),
        const SizedBox(height: 24),
        Expanded(child: listOfContracts(state))
      ],
    );
  }
}
