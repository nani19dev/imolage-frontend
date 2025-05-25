import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/commun/constant/constant.dart';
import 'package:frontend/commun/widgets/button.dart';
import 'package:frontend/commun/widgets/fields/textfield.dart';
import 'package:frontend/commun/widgets/snackbar.dart';
import 'package:frontend/features/property/data/models/apartment.dart';
import 'package:frontend/features/property/data/models/property.dart';
import 'package:frontend/features/property/logic/bloc/apartment_bloc.dart';
import 'package:frontend/features/property/logic/bloc/property_bloc.dart';
import 'package:go_router/go_router.dart';

class AddPropertyPage extends StatefulWidget {
  const AddPropertyPage({super.key});

  @override
  State<AddPropertyPage> createState() => _AddPropertyPageState();
}

class _AddPropertyPageState extends State<AddPropertyPage> {
  late String selectedType;

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _typeController = TextEditingController();
  List<DropdownMenuEntry<String>> typeEntries = <DropdownMenuEntry<String>>[];
  final _descriptionController = TextEditingController();
  final _statusController = TextEditingController();

  void _updateClient(String client) {
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
            onValueChanged: _updateClient
            ),
          /*FormTextField(
            controller: _descriptionController,
            keyboardType: TextInputType.text,
            isRequired: false,
            labelText: descriptionLabel,
            text: _descriptionController.text
          ),*/
          BlocBuilder<PropertyBloc, PropertyState>(
            builder: (BuildContext context, PropertyState state) {
              return FormButton(
                formkey: _formKey,
                onPressed: state is PropertyLoading ? null : () async {
                  if (_formKey.currentState!.validate()) {
                    PropertyModel property = PropertyModel(
                      name: _nameController.text,
                      type: _typeController.text,
                    );
                    if(property.type == "apartment"){
                      context.read<PropertyBloc>().add(PropertyApartmentCreateEvent(property));
                    } else {
                      context.read<PropertyBloc>().add(PropertyCreateEvent(property));
                    }
                  }
                },
                text: state is PropertyLoading ? loadingLabel : createPropertyLabel,
              );
            },
          ),
        ],
      )
    );
  }

  void init() async {
    List<DropdownMenuEntry<String>> typeList = <DropdownMenuEntry<String>>[];
    typeList.add(const DropdownMenuEntry(value: "tenement house", label: "tenement house"));
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
        title: const Text('Add Property'),
        leading: BackButton(
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocListener<PropertyBloc, PropertyState>(
        listener: (BuildContext context, PropertyState state) {
          if (state is PropertyOperationSuccess) {
            context.pop();
            successMessage(state.message.toString(), context);
          } else if (state is PropertyError) {
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
