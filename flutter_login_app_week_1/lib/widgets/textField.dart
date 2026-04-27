import 'package:flutter/material.dart';

class TextField extends StatelessWidget {
  final String hint;
  final String label;
  final VoidCallback? onTap;
  final TextEditingController controller;
  final IconData icon;
  final TextInputType keyboardType;
  final bool hide;
  final Color enableColor;
  final Color focuseColor;
  final Color errorColor;
  final Color borderColor;
  final String? Function(String?)? validator;
  // final Function(String)? onChanged;
  const TextField({
    super.key,
    required this.hint,
    required this.controller,
    required this.icon,
    required this.keyboardType,
    required this.validator,
    this.hide = false,
    required this.label,
    this.onTap,
    this.enableColor = Colors.white,
    this.focuseColor = Colors.pink,
    this.errorColor = Colors.red,
    this.borderColor = Colors.white,
    required Color textFieldFillColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0.0),
      child: TextFormField(
        style: TextStyle(
          // fontSize: FontSize.size20,
          fontSize: 15.5,
          color: Colors.black,
        ),
        maxLines: 1,
        controller: controller,
        keyboardType: keyboardType,
        obscureText: hide,
        obscuringCharacter: '*',
        validator: validator,
        decoration: InputDecoration(
          // helperText: controller.text,
          label: Text(label, style: const TextStyle(color: Colors.black)),
          fillColor: Colors.grey.withOpacity(.05),
          filled: true,
          hintText: hint,
          hintStyle: TextStyle(fontSize: 15, color: Colors.black54),
          suffixIcon: InkWell(
            onTap: onTap,
            child: Icon(icon, size: 026, color: Colors.pink),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(02),
            borderSide: const BorderSide(color: Color(0xFFFCDEEF), width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(02),
            borderSide: BorderSide(color: enableColor, width: 007),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(02),
            borderSide: BorderSide(color: borderColor, width: 007),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(18)),
            borderSide: BorderSide(color: errorColor, width: 0075),
          ),
        ),
      ),
    );
  }
}
