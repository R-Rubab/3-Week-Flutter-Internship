import 'package:flutter/material.dart';

class AuthTextField extends StatelessWidget {
  final String text;
  final String icon;
  final TextEditingController controller;
final TextInputAction? textInputAction;
final TextInputType? keyboardType;
final bool obscureText;
final ValueChanged<String>? onChanged;
final String? Function(String?)? validator;
  const AuthTextField({
    super.key,
    required this.text,
    required this.icon,
    required this.controller, this.textInputAction, this.keyboardType, this.obscureText = false, this.onChanged, this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.1,
        width: MediaQuery.of(context).size.width * 0.9,
        child: TextFormField(
          controller: controller,
          textAlign: TextAlign.start,
          // textInputAction: TextInputAction.next,
            onChanged: onChanged,
            validator: validator,
            
          obscureText: obscureText,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
            focusColor: Colors.black26,
            fillColor: const Color.fromARGB(255, 247, 247, 247),
            filled: true,
            prefixIcon: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Container(child: Image.asset(icon)),
            ),
            prefixIconColor: const Color.fromARGB(255, 3, 190, 150),
            label: Text(text),
            floatingLabelBehavior: FloatingLabelBehavior.never,
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(30),
              
            ),
          ),
        ),
      ),
    );
  }
}
