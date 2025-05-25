import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/commun/constant/constant.dart';
import 'package:frontend/commun/widgets/button.dart';
import 'package:frontend/commun/widgets/fields/textfield.dart';
import 'package:frontend/commun/widgets/snackbar.dart';
import 'package:frontend/features/property/data/models/apartment.dart';
import 'package:frontend/features/property/data/models/property.dart';
import 'package:frontend/features/transaction/data/models/transaction.dart';
import 'package:frontend/features/transaction/logic/bloc/transaction_bloc.dart';
import 'package:go_router/go_router.dart';

class AddTransactionPage extends StatefulWidget {
  //final String? propertyId;
  //final String? apartmentId;
  const AddTransactionPage({super.key});

  @override
  State<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {

  final _formKey = GlobalKey<FormState>();

  String? _propertyId;
  String? _apartmentId;
  String? _propertyType;
  late DateTime _date;

  final _propertyIdController = TextEditingController();
  final _senderIdController = TextEditingController();
  final _apartmentIdController = TextEditingController();
  String? _type;
  String? _paymentMethod;
  final _amountController = TextEditingController();

  void _updateDate(DateTime date) {
    setState(() {
      _date = date;
    });
  }

  void _updatePropertyResult(PropertyModel property) {
    setState(() {
      _propertyIdController.text = property.name;
      _propertyId = property.id!;
      _apartmentIdController.clear();
      _apartmentId = null;
      _propertyType = null;
      _apartmentId = null;
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

  void _updateType(String type) {
    setState(() {
      _type = type;
    });
  }

  void _updatePaymentMethod(String paymentMethod) {
    setState(() {
      _paymentMethod = paymentMethod;
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
          DropdownTextField(
            labelText: defaultOptionlabel,
            options: const ['rent'],
            //initialValue: 'rent',
            isRequired: true,
            onValueChanged: _updateType
          ),
          FormTextField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            isRequired: true,
            labelText: amountLabel,
            text: _amountController.text
          ),
          DropdownTextField(
            labelText: defaultOptionlabel,
            options: const ['banktransfer', 'cash'],
            //initialValue: null,
            isRequired: true,
            onValueChanged: _updatePaymentMethod
          ),
          DateField(
            selectedDate: _date,
            labelText: dateLabel,
            onDateChanged: _updateDate
          ),
          BlocBuilder<TransactionBloc, TransactionState>(
            builder: (BuildContext context, TransactionState state) {
              return FormButton(
                formkey: _formKey,
                onPressed: _propertyId == null && _apartmentId== null || state is TransactionLoading ? null : () async {
                  if (_formKey.currentState!.validate()){
                    if (_apartmentId != null) {
                    TransactionModel transaction = TransactionModel(
                      //senderId: _senderIdController.text, 
                      type: _type!,
                      amount: double.parse(_amountController.text),
                      paymentMethod: _paymentMethod!,
                      date: _date,
                    );
                    //context.read<TransactionBloc>().add(TransactionCreateEvent(transaction, _propertyId!));
                    context.read<TransactionBloc>().add(TransactionCreateEvent(transaction, _apartmentId!));
                    } else {
                      errorMessage('select an property or an apartment', context);
                    }
                  } 
                },
                text: state is TransactionLoading ? loadingLabel : createTransactionLabel,
              );
            },
          ),
        ],
      )
    );
  }

  void init() async {
    _date = DateTime.now();
  }

  @override
  initState() {
    super.initState();
    init();
  }

  @override
  void dispose() {
    _propertyIdController.dispose();
    _senderIdController.dispose();
    _apartmentIdController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(addTransactionLabel),
        leading: BackButton(
          onPressed: () {
            //context.read<TransactionBloc>().add(TransactionsLoadEvent(_apartmentId, null));
            context.pop();
          }
        ),
      ),
      body: BlocListener<TransactionBloc, TransactionState>(
        listener: (context, state) {
          if (state is TransactionOperationSuccess) {
            context.pop();
            successMessage(state.message.toString(), context);
          } else if (state is TransactionError) {
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