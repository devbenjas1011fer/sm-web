import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../infra/utils/validaciones.dart';

class UpperCaseTextFormatter extends TextInputFormatter {
  const UpperCaseTextFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return newValue.copyWith(text: newValue.text.toUpperCase());
  }
}

class CampoTexto extends StatelessWidget {
  const CampoTexto({
    super.key,
    required this.label,
    this.icon,
    this.controller,
    this.initialValue,
    this.enabled = true,
    this.maxLines = 1,
    this.obscureText = false,
    this.keyboardType,
    this.inputFormatters,
    this.textCapitalization = TextCapitalization.none,
    this.onChanged,
    this.validator,
  }) : assert(
         controller == null || initialValue == null,
         'Usa controller o initialValue, no ambos.',
       );

  final String label;
  final IconData? icon;
  final TextEditingController? controller;
  final String? initialValue;
  final bool enabled;
  final int maxLines;
  final bool obscureText;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final TextCapitalization textCapitalization;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;

  factory CampoTexto.curp({
    Key? key,
    String label = 'CURP',
    TextEditingController? controller,
    String? initialValue,
    bool enabled = true,
    ValueChanged<String>? onChanged,
    String? Function(String?)? validator,
  }) {
    return CampoTexto(
      key: key,
      label: label,
      icon: Icons.badge_outlined,
      controller: controller,
      initialValue: initialValue,
      enabled: enabled,
      textCapitalization: TextCapitalization.characters,
      inputFormatters: [
        const UpperCaseTextFormatter(),
        LengthLimitingTextInputFormatter(18),
      ],
      onChanged: onChanged,
      validator: validator ?? Validaciones.curp,
    );
  }

  factory CampoTexto.telefono({
    Key? key,
    String label = 'Número',
    TextEditingController? controller,
    String? initialValue,
    bool enabled = true,
    ValueChanged<String>? onChanged,
    String? Function(String?)? validator,
  }) {
    return CampoTexto(
      key: key,
      label: label,
      icon: Icons.phone_outlined,
      controller: controller,
      initialValue: initialValue,
      enabled: enabled,
      keyboardType: TextInputType.phone,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(10),
      ],
      onChanged: onChanged,
      validator: validator ?? Validaciones.telefono,
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      initialValue: initialValue,
      enabled: enabled,
      maxLines: obscureText ? 1 : maxLines,
      obscureText: obscureText,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      textCapitalization: textCapitalization,
      onChanged: onChanged,
      validator: enabled ? validator : null,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: icon == null ? null : Icon(icon),
      ),
    );
  }
}
