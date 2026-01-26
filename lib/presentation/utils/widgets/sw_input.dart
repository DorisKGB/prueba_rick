import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SWInput extends StatefulWidget {
  const SWInput(
      {super.key,
      required this.outData,
      required this.inData,
      this.maxLines = 1,
      this.obscureText = false,
      this.myFocusNode,
      this.textAlign = TextAlign.start,
      this.textInputType = TextInputType.text,
      this.isAutoFocus = false,
      this.textInputAction,
      this.lenght,
      this.nextFocus = false,
      this.contentPadding,
      this.enable = true,
      this.textEditingController,
      this.inputFormatters,
      this.maxLength,
      required this.decoration,
      this.textStyle});

  final Stream<String> outData;
  final Function(String) inData;
  final int? lenght;
  final int? maxLines;
  final bool obscureText;
  final FocusNode? myFocusNode;
  final bool isAutoFocus;
  final TextAlign textAlign;
  final TextInputType textInputType;
  final TextInputAction? textInputAction;
  final bool nextFocus;
  final bool enable;
  final EdgeInsetsGeometry? contentPadding;
  final TextEditingController? textEditingController;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;
  final TextStyle? textStyle;
  final InputDecoration Function(String? error) decoration;

  @override
  State<SWInput> createState() => _SWInputState();
}

class _SWInputState extends State<SWInput> {
  late TextEditingController controller;
  bool writting = false;

  @override
  void initState() {
    controller = widget.textEditingController ?? TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
      stream: widget.outData,
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.hasData && controller.text != snapshot.data) {
          controller.text = snapshot.data.toString();
          controller.selection = TextSelection.fromPosition(
              TextPosition(offset: controller.text.length));
        }

        return getInput(
            snapshot.hasError ? snapshot.error.toString() : null, context);
      },
    );
  }

  Widget getInput(String? error, BuildContext context) {
    return TextField(
      onTapOutside: (PointerDownEvent event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      textAlign: widget.textAlign,
      textInputAction: widget.textInputAction ?? TextInputAction.done,
      textAlignVertical: TextAlignVertical.center,
      inputFormatters: widget.inputFormatters ??
          <TextInputFormatter>[
            LengthLimitingTextInputFormatter(widget.lenght ?? 250),
          ],
      decoration: widget.decoration(error),
      style: widget.textStyle,
      onChanged: (String value) {
        if (widget.nextFocus) {
          if (value.length > widget.lenght! - 1) {
            FocusScope.of(context).nextFocus();
          }
        }
        widget.inData(value);
      },
      focusNode: widget.myFocusNode,
      controller: controller,
      obscureText: widget.obscureText,
      keyboardType: widget.textInputType,
      maxLines: widget.maxLines,
      enabled: widget.enable,
      maxLength: widget.maxLength,
      autofocus: widget.isAutoFocus,
    );
  }
}
