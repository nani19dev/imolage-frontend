import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/commun/constant/constant.dart';
import 'package:frontend/commun/widgets/button.dart';
import 'package:frontend/commun/widgets/fields/textfield.dart';
import 'package:frontend/commun/widgets/snackbar.dart';
import 'package:frontend/features/property/data/models/apartment.dart';
import 'package:frontend/features/property/logic/bloc/apartment_bloc.dart';
import 'package:go_router/go_router.dart';

class AddApartmentPage extends StatefulWidget {
  final String? propertyId;
  const AddApartmentPage({super.key, this.propertyId});

  @override
  State<AddApartmentPage> createState() => _AddApartmentPageState();
}

class _AddApartmentPageState extends State<AddApartmentPage> {
  late String selectedType;

  final _formKey = GlobalKey<FormState>();
  List<DropdownMenuEntry<String>> typeEntries = <DropdownMenuEntry<String>>[];

  final _nameController = TextEditingController();
  final _typeController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _statusController = TextEditingController();

  void _updateType(String client) {
    setState(() {
      selectedType = client;
    });
  }

    Widget _formContent() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FormTextField(
            controller: _nameController,
            keyboardType: TextInputType.text,
            isRequired: true,
            labelText: nameLabel,
            text: _nameController.text
          ),
          Dropdown(
              controller: _typeController,
              labelText: emptyStringLabel,
              entries: typeEntries,
              onValueChanged: _updateType
            ),
          /*FormTextField(
            controller: _descriptionController,
            keyboardType: TextInputType.text,
            isRequired: false,
            labelText: descriptionLabel,
            text: _descriptionController.text
          ),*/
          BlocBuilder<ApartmentBloc, ApartmentState>(
            builder: (BuildContext context, ApartmentState state) {
              return FormButton(
                formkey: _formKey,
                onPressed: state is ApartmentLoading ? null : () async {
                  if (_formKey.currentState!.validate()) {
                    ApartmentModel apartment = ApartmentModel(
                      name: _nameController.text,
                      type: _typeController.text,
                      propertyId: widget.propertyId!
                    );
                    context.read<ApartmentBloc>().add(ApartmentCreateEvent(apartment));
                  }
                },
                text: state is ApartmentLoading ? loadingLabel : createPropertyLabel,
              );
            },
          ),
        ],
      )
    );
  }

  void init() async {
    List<DropdownMenuEntry<String>> typeList = <DropdownMenuEntry<String>>[];
    typeList.add(const DropdownMenuEntry(value: "apartment", label: "apartment"));
    setState(() {
      typeEntries = typeList;
    });
  }

  @override
  initState() {
    super.initState();
    init();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _typeController.dispose();
    _descriptionController.dispose();
    _statusController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(addApartmentLabel),
        leading: BackButton(
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocListener<ApartmentBloc, ApartmentState>(
        listener: (BuildContext context, ApartmentState state) {
          if (state is ApartmentOperationSuccess) {
            context.pop();
            successMessage(state.message.toString(), context);
          } else if (state is ApartmentError) {
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
