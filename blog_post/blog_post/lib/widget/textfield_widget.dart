import 'package:flutter/material.dart';

class TextfieldWidget extends StatelessWidget {
  const TextfieldWidget({
    required this.textController,
    required this.labelTxt,
    this.formValidator,
  });

  final TextEditingController textController;
  final String labelTxt;
  final FormFieldValidator<String>? formValidator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textController,
      decoration: InputDecoration(labelText: labelTxt),
      maxLines: null,
      minLines: 1,
      validator: formValidator,
    );
  }
}
