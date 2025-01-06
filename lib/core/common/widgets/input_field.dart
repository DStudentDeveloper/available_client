// coverage:ignore-file
import 'package:available/core/res/colours.dart';
import 'package:flutter/material.dart';

class InputField extends StatefulWidget {
  /// Creates a custom [TextField] and exposes a variety of properties to be
  /// changed at will, for better control.
  const InputField({
    required this.controller,
    required this.label,
    super.key,
    this.validator,
    this.keyboardType,
    this.focusNode,
    this.suffixIcon,
    this.labelStyle,
    this.prefixText,
    this.required = true,
    this.obscureText = false,
    this.textInputAction,
    this.onFieldSubmitted,
  });

  final TextEditingController controller;
  final String? Function(String? value)? validator;
  final String label;
  final TextInputType? keyboardType;
  final bool obscureText;
  final FocusNode? focusNode;
  final Widget? suffixIcon;
  final TextStyle? labelStyle;
  final String? prefixText;
  final bool required;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onFieldSubmitted;

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
  }

  @override
  void dispose() {
    if (widget.focusNode == null) _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 5,
        children: [
          Text(
            widget.label,
            style: widget.labelStyle ??
                const TextStyle(fontSize: 15, color: Colours.primary),
          ),
          TextFormField(
            controller: widget.controller,
            obscureText: widget.obscureText,
            textInputAction: widget.textInputAction,
            focusNode: _focusNode,
            keyboardType: widget.keyboardType,
            decoration: InputDecoration(suffixIcon: widget.suffixIcon),
            onTapOutside: (_) => _focusNode.unfocus(),
            onFieldSubmitted: widget.onFieldSubmitted,
            validator: (value) {
              if (widget.required && (value == null || value.isEmpty)) {
                return 'This field is required';
              }
              return widget.validator?.call(value);
            },
          ),
        ],
      ),
    );
  }
}
