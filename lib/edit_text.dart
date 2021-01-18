import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// textField with a clear button
class EditText extends StatefulWidget {
  final String defaultText;
  final bool outline;
  final bool cleanButtonEnable;
  final double height;
  final EdgeInsets padding;
  final Color highlightColor;
  final List<TextInputFormatter> inputFormatters;
  final ValueChanged<String> onSubmitted;
  final ValueNotifier<String> textNotifier;

  EditText({
    this.defaultText,
    this.outline = false,
    this.cleanButtonEnable = true,
    this.height,
    this.padding = const EdgeInsets.symmetric(horizontal: 6),
    this.highlightColor = Colors.green,
    this.inputFormatters,
    this.onSubmitted,
    this.textNotifier,
  });

  @override
  State<StatefulWidget> createState() => _EditTextState();
}

class _EditTextState extends State<EditText> {
  final _maxCleanButtonIconSize = 18.0;
  final _cleanButtonPadding = 4.0;
  bool _clearButtonVisible;
  TextEditingController _textEditingController;

  @override
  void initState() {
    _clearButtonVisible = widget.cleanButtonEnable &&
        widget.defaultText != null &&
        widget.defaultText.isNotEmpty;
    _textEditingController = TextEditingController.fromValue(
      TextEditingValue(
        text: widget.defaultText ?? '',
        selection: TextSelection.fromPosition(
          TextPosition(
            affinity: TextAffinity.downstream,
            offset: widget.defaultText != null ? widget.defaultText.length : 0,
          ),
        ),
      ),
    )..addListener(_textEditingListener);

    super.initState();
  }

  void _textEditingListener() {
    _onTextChanged(_textEditingController.text);
  }

  @override
  void dispose() {
    _textEditingController.removeListener(_textEditingListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.centerEnd,
      children: [
        SizedBox(
          height: widget.height,
          child: _buildTextField(),
        ),
        Padding(
          padding: EdgeInsets.only(right: widget.padding.right),
          child: _buildClearButton(),
        ),
      ],
    );
  }

  Widget _buildTextField() {
    final borderSide = BorderSide(color: widget.highlightColor);
    return TextField(
      controller: _textEditingController,
      decoration: InputDecoration(
        border: widget.outline ? OutlineInputBorder() : UnderlineInputBorder(),
        focusedBorder: widget.outline
            ? OutlineInputBorder(borderSide: borderSide)
            : UnderlineInputBorder(borderSide: borderSide),
        contentPadding: EdgeInsets.only(
            left: widget.padding.left,
            right: _getClearButtonWidth() + widget.padding.right * 2),
      ),
      inputFormatters: widget.inputFormatters,
      onSubmitted: widget.onSubmitted,
    );
  }

  double _getClearButtonIconSize() {
    return widget.height == null
        ? _maxCleanButtonIconSize
        : min(_maxCleanButtonIconSize,
            widget.height - max(10.0, widget.padding.vertical));
  }

  double _getClearButtonWidth() {
    return _getClearButtonIconSize() + _cleanButtonPadding * 2;
  }

  Widget _buildClearButton() {
    return Visibility(
      visible: _clearButtonVisible,
      child: SizedBox(
        width: _getClearButtonWidth(),
        child: OutlineButton(
          highlightColor: widget.highlightColor,
          child: Icon(
            Icons.clear,
            size: _getClearButtonIconSize(),
          ),
          padding: EdgeInsets.all(_cleanButtonPadding),
          shape: const CircleBorder(),
          onPressed: () {
            _textEditingController.clear();
            _onTextChanged('');
          },
        ),
      ),
    );
  }

  void _onTextChanged(String value) {
    final clearButtonVisible = value.isNotEmpty;
    if (widget.cleanButtonEnable && _clearButtonVisible != clearButtonVisible) {
      setState(() {
        _clearButtonVisible = clearButtonVisible;
      });
    }

    if (widget.textNotifier != null) {
      widget.textNotifier.value = value;
    }
  }
}
