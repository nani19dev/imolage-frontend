import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/commun/widgets/fields/listTextField/list.dart';
import 'package:go_router/go_router.dart';
const heightSizedBox = 0.0;
const padding = EdgeInsets.fromLTRB(25, 0, 25, 25);

// default textfield
class DefaultTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;

  const DefaultTextField({
    super.key,
    required this.controller,
    required this.labelText,
  });
 
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: padding,
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: labelText,
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                onPressed: () {
                  controller.clear();
                },
                icon: const Icon(Icons.clear),
              )
            ),
          ),
        ),
      ],
    );
  }
}

// form textfield
class FormTextField extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool isRequired;
  final String labelText;
  final String text;

  const FormTextField({
    super.key,
    required this.controller,
    required this.keyboardType,
    required this.isRequired,
    required this.labelText,
    required this.text
  });
 
  @override
  Widget build(BuildContext context) {
    controller.text = text;
    return Column(
      children: [
        Padding(
          padding: padding,
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            validator: (value) {
              if (isRequired) {
                if (value == null || value.isEmpty) {
                return 'required field';
                }
                if (keyboardType == TextInputType.number &&
                    !RegExp(r'^\d+$').hasMatch(value)) {
                  return 'Only numbers allowed';
                }
              }
            },
            decoration: InputDecoration(
              labelText: labelText,
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                onPressed: () {
                  controller.clear();
                },
                icon: const Icon(Icons.clear),
              )
            ),
          ),
        ),
      ],
    );
  }
}

// password textfield
class PasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;

  const PasswordField({
    super.key,
    required this.controller,
    required this.labelText,
  });

   @override
  State<PasswordField> createState() => _PasswordField();
}

class _PasswordField extends State<PasswordField> {
  var isObscure = true;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: TextField(
        controller: widget.controller,
        obscureText: isObscure,
        decoration: InputDecoration(
          labelText: widget.labelText,
          border: const OutlineInputBorder(),
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                isObscure = !isObscure;
              });
            },
            icon: isObscure?const Icon(Icons.visibility_off):const Icon(Icons.visibility),
          )
        ),
      ),
    );
  }
}

// password textfield
class FormPasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;

  const FormPasswordField({
    super.key,
    required this.controller,
    required this.labelText,
  });

   @override
  State<FormPasswordField> createState() => _FormPasswordField();
}

class _FormPasswordField extends State<FormPasswordField> {
  var isObscure = true;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: padding,
          child: TextFormField(
            controller: widget.controller,
            obscureText: isObscure,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'required field';
              }
              if (value.length < 6 || !value.contains(RegExp(r'[A-Z]')) || !value.contains(RegExp(r'[a-z]')) || !value.contains(RegExp(r'[!@#$%^&*()_+=-]')) || !value.contains(RegExp(r'[0-9]'))) {
                return 'The password must meet the following criteria: \n - a minimum length of 6 characters \n - at least one uppercase letter \n - at least one lowercase letter \n - at least one symbol \n - at least one number \n ';
              }
              return null;
            },
            decoration: InputDecoration(
              labelText: widget.labelText,
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    isObscure = !isObscure;
                  });
                },
                icon: isObscure?const Icon(Icons.visibility_off):const Icon(Icons.visibility),
              )
            ),
          ),
        ),
      ],
    );
    
  }
}

// password textfield
class FormConfirmPasswordField extends StatefulWidget {
  final TextEditingController passwordcontroller;
  final TextEditingController controller;
  final String labelText;

  const FormConfirmPasswordField({
    super.key,
    required this.passwordcontroller,
    required this.controller,
    required this.labelText,
  });

  @override
  State<FormConfirmPasswordField> createState() => _FormConfirmPasswordField();
}

class _FormConfirmPasswordField extends State<FormConfirmPasswordField> {
  var isObscure = true;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: padding,
          child: TextFormField(
            controller: widget.controller,
            obscureText: isObscure,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'required field';
              }
              final password = widget.passwordcontroller.text.trim();
              final confirmPassword = widget.controller.text.trim();
              if (password != confirmPassword){
                return 'The password is not the same';
              }
              return null;
            },
            decoration: InputDecoration(
              labelText: widget.labelText,
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    isObscure = !isObscure;
                  });
                },
                icon: isObscure?const Icon(Icons.visibility_off):const Icon(Icons.visibility),
              )
            ),
          ),
        ),
      ],
    );
  }
}

// number textfield
class NumberField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;

  const NumberField({
    super.key,
    required this.controller,
    required this.labelText,
  });
 
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: labelText,
          border: const OutlineInputBorder(),
          suffixIcon: IconButton(
            onPressed: () {
              controller.clear();
            },
            icon: const Icon(Icons.clear),
          )
        ),
      ),
    );
  }
}

// edit textfield
class EditTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String text;

  const EditTextField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.text,
  });
 
  @override
  Widget build(BuildContext context) {
    controller.text = text;
    return Column(
      children: [
        Padding(
          padding: padding,
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: labelText,
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                onPressed: () {
                  controller.clear();
                },
                icon: const Icon(Icons.clear),
              )
            ),
          ),
        ),
      ],
    );
  }
}

// date textfield
// ignore: must_be_immutable
class DateField extends StatefulWidget {
  DateTime selectedDate;
  final String labelText;
  final Function onDateChanged;

  DateField({
    super.key, 
    required this.selectedDate,
    required this.labelText,
    required this.onDateChanged,
  });

   @override
  State<DateField> createState() => _DateField();
}

class _DateField extends State<DateField> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    controller.text = '${widget.selectedDate.day}/${widget.selectedDate.month}/${widget.selectedDate.year}';
    return Padding(
      padding: padding,
      child: TextField(
        readOnly: true,
        controller: controller,
        onTap: () async {
          final DateTime? newDate = await showDatePicker(
            context: context, 
            initialDate: widget.selectedDate,
            initialEntryMode: DatePickerEntryMode.calendar,
            firstDate: DateTime(2000),
            lastDate: DateTime(3000),
          );
          if (newDate != null) {
            setState(() {widget.selectedDate = newDate;});
            widget.onDateChanged(newDate);
          }
        },
        decoration: InputDecoration(
          labelText: widget.labelText,
          border: const OutlineInputBorder(),
          /*suffixIcon: IconButton(
            onPressed: () async {
              final DateTime? newDate = await showDatePicker(
                context: context, 
                initialDate: widget.selectedDate,
                initialEntryMode: DatePickerEntryMode.calendar,
                firstDate: DateTime(2000),
                lastDate: DateTime(3000),
              );
              if (newDate != null) {
                setState(() {widget.selectedDate = newDate;});
                widget.onDateChanged(newDate);
              }
            },
            icon: const Icon(Icons.calendar_today),
          )*/
        ),
      ),
    );
  }
}

// time textfield
// ignore: must_be_immutable
class TimeField extends StatefulWidget {
  TimeOfDay selectedTime;
  final String labelText;
  final Function onTimeChanged;

  TimeField({
    super.key, 
    required this.selectedTime,
    required this.labelText,
    required this.onTimeChanged,
  });

   @override
  State<TimeField> createState() => _TimeField();
}

class _TimeField extends State<TimeField> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    controller.text = '${widget.selectedTime.hour}:${widget.selectedTime.minute}';
    return Padding(
      padding: padding,
      child: TextField(
        readOnly: true,
        controller: controller,
        decoration: InputDecoration(
          labelText: widget.labelText,
          border: const OutlineInputBorder(),
          suffixIcon: IconButton(
            onPressed: () async {
              final TimeOfDay? timeOfDay = await showTimePicker(
                context: context, 
                initialTime: widget.selectedTime,
                initialEntryMode: TimePickerEntryMode.inputOnly
              );
              if (timeOfDay != null) {
                setState(() {widget.selectedTime = timeOfDay;});
                widget.onTimeChanged(timeOfDay);
              }
            },
            icon: const Icon(Icons.timer),
          )
        ),
      ),
    );
  }
}

// dropdownmenu textfield 
class Dropdown extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final List<DropdownMenuEntry<String>> entries;
  final Function onValueChanged;

  const Dropdown({
    super.key,
    required this.controller,
    required this.labelText,
    required this.entries,
    required this.onValueChanged,
  });

  @override
  State<Dropdown> createState() => _Dropdown();
}

class _Dropdown extends State<Dropdown> {
  String? selectedValue;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: DropdownMenu<String>(
        controller: widget.controller,
        label: Text(widget.labelText),
        dropdownMenuEntries: widget.entries,
        onSelected: (String? newValue) {
          setState(() {selectedValue = newValue;});
          widget.onValueChanged(selectedValue);
        },
      ),
    );
  }
}

// list textfield
class ListTextField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final bool enabled;
  final String type;
  final Function onReturnValue;
  final String? id;

  const ListTextField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.enabled,
    required this.type,
    required this.onReturnValue,
    this.id,
  });

  @override
  State<ListTextField> createState() => _ListTextFieldState();
}

class _ListTextFieldState extends State<ListTextField> {
 
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: padding,
          child: TextField(
            controller: widget.controller,
            readOnly: true,
            enabled: widget.enabled,
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ListFieldPage(objectType: widget.type, id: widget.id)),
              );
              if (result != null) {
                widget.onReturnValue(result);
              }
            },
            decoration: InputDecoration(
              labelText: widget.labelText,
              border: const OutlineInputBorder(),
              /*suffixIcon: IconButton(
                onPressed: () {
                  controller.clear();
                },
                icon: const Icon(Icons.clear),
              )*/
            ),
          ),
        ),
      ],
    );
  }
}

// dropdown textfield
class DropdownTextField extends StatefulWidget {
  final String labelText;
  final List<String> options;
  final String? initialValue;
  final bool isRequired;
  final ValueChanged<String> onValueChanged;

  const DropdownTextField({
    super.key,
    required this.labelText,
    required this.options,
    this.initialValue,
    required this.isRequired,
    required this.onValueChanged,
  });

  @override
  State<DropdownTextField> createState() => _DropdownTextFieldState();
}

class _DropdownTextFieldState extends State<DropdownTextField> {
  String? _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: DropdownButtonFormField<String>(
        value: _selectedValue,
        items: widget.options.map((option) => DropdownMenuItem<String>(
          value: option,
          child: Text(option),
        )).toList(),
        onChanged: (String? newValue) {
          setState(() {_selectedValue = newValue;});
          widget.onValueChanged(_selectedValue!);
        },
        validator: (value) { 
          if (widget.isRequired) {
            if (value == null || value.isEmpty) {
              return 'Please select an option';
            }
            if (_selectedValue == null) {
              return 'Please select an option';
            }
          }
        },
        decoration: InputDecoration(
          labelText: widget.labelText,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
