import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/commun/constant/constant.dart';
import 'package:frontend/commun/widgets/button.dart';
import 'package:frontend/commun/widgets/fields/textfield.dart';
import 'package:frontend/commun/widgets/snackbar.dart';
import 'package:frontend/features/contract/data/models/contract.dart';
import 'package:frontend/features/contract/logic/bloc/contract_bloc.dart';
import 'package:frontend/features/property/data/models/apartment.dart';
import 'package:frontend/features/property/data/models/property.dart';
import 'package:go_router/go_router.dart';

class AddContractPage extends StatefulWidget {
  final String? propertyId;
  const AddContractPage({super.key, this.propertyId});

  @override
  State<AddContractPage> createState() => _AddContractPageState();
}

class _AddContractPageState extends State<AddContractPage> {
  final _formKey = GlobalKey<FormState>();

  String? _propertyId;
  String? _apartmentId;
  String? _propertyType;
  late DateTime _startDate;
  late DateTime _endDate;

  final _rentController = TextEditingController();
  final _propertyIdController = TextEditingController();
  final _apartmentIdController = TextEditingController();

  void _updateStartDate(DateTime date) {
    setState(() {
      _startDate = date;
    });
  }

  void _updateEndDate(DateTime date) {
    setState(() {
      _endDate = date;
    });
  }

  void _updatePropertyResult(PropertyModel property) {
    setState(() {
      _propertyIdController.text = property.name;
      _propertyId = property.id!;
      _apartmentIdController.clear();
      _apartmentId = null;
      _propertyType = null;
      if (property.type == 'apartment') {
        _propertyType = property.type;
        _apartmentId = property.apartmentId;
      }
    });
  }

  void _updateApartmentResult(ApartmentModel apartment) {
    setState(() {
      _apartmentIdController.text = apartment.name;
      _apartmentId = apartment.id!;
    });
  }

  Widget _formContent() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ListTextField(
            controller: _propertyIdController,
            labelText: 'property',
            enabled: true,
            type: 'property',
            onReturnValue: _updatePropertyResult,
            id: null,
          ),
          ListTextField(
            controller: _apartmentIdController,
            labelText: 'apartment',
            enabled: _propertyId == null || _propertyType == 'apartment'? false:true,
            type: 'apartment',
            onReturnValue: _updateApartmentResult,
            id: _propertyId,
          ),
          DateField(
            selectedDate: _startDate,
            labelText: startDateLabel,
            onDateChanged: _updateStartDate
          ),
          DateField(
            selectedDate: _endDate,
            labelText: endDateLabel,
            onDateChanged: _updateEndDate
          ),
          FormTextField(
            controller: _rentController,
            keyboardType: TextInputType.number,
            isRequired: true,
            labelText: rentLabel,
            text: _rentController.text
          ),
          /*Dropdown(
            controller: _propertyIdController,
            labelText: emptyStringLabel,
            entries: _propertyIdEntries,
            onValueChanged: _updateProperties
          ),
          Dropdown(
            controller: _apartmentIdController,
            labelText: emptyStringLabel,
            entries: _apartmentIdEntries,
            onValueChanged: _updateApartment
          ),*/
          BlocBuilder<ContractBloc, ContractState>(
            builder: (BuildContext context, ContractState state) {
              return FormButton(
                formkey: _formKey,
                onPressed: _propertyId == null && _apartmentId== null || state is ContractLoading ? null : () async {
                  if (_formKey.currentState!.validate()){
                    if (_startDate.isBefore(_endDate) || _startDate.isAtSameMomentAs(_endDate)){
                      if (_apartmentId != null) {
                        ContractModel contract = ContractModel(
                          startDate: _startDate, 
                          endDate: _endDate,
                          rent: double.parse(_rentController.text),
                          apartmentId: _apartmentId
                        );
                        context.read<ContractBloc>().add(ContractCreateEvent(contract));
                      } else {
                        errorMessage('select an property or an apartment', context);
                      }
                    } else {
                      errorMessage('start date is greater that the end date', context);
                    }
                  } 
                },
                text: state is ContractLoading ? loadingLabel : createContractLabel,
              );
            },
          ),
        ],
      )
    );
  }

  void init() async {
    _startDate = DateTime.now();
    _endDate = DateTime.now();
  }

  @override
  initState() {
    super.initState();
    init();
  }

  @override
  void dispose() {
    _rentController.dispose();
    _propertyIdController.dispose();
    _apartmentIdController.dispose(); 
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(addContractLabel),
        leading: BackButton(
          onPressed: () {
            context.pop();
          }
        ),
      ),
      body: BlocListener<ContractBloc, ContractState>(
        listener: (BuildContext context, ContractState state) {
          if (state is ContractOperationSuccess) {
            context.pop();
            successMessage(state.message.toString(), context);
          } else if (state is ContractError) {
            errorMessage(state.error.toString(), context);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _formContent(),
            ],
          ),
        ),
      ),
    );
  }

}
