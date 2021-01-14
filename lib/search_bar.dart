import 'package:flutter/material.dart';
import 'edit_text.dart';

class SearchBar extends StatelessWidget {
  final _searchButtonWidth = 45.0;
  final ValueNotifier<String> _searchTextNotifier = ValueNotifier('');

  final ValueChanged<String> _onSearch;
  final String defaultText;
  final Color backgroundColor;
  final Color highlightColor;
  final EdgeInsets padding;
  final double height;

  SearchBar(
    this._onSearch, {
    this.defaultText,
    this.backgroundColor = Colors.white,
    this.highlightColor = Colors.green,
    this.padding = const EdgeInsets.all(6),
    this.height = 50,
  }) : assert(_onSearch != null);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      height: height,
      decoration: BoxDecoration(
          color: backgroundColor,
          border: Border(
            bottom: BorderSide(color: Colors.grey, width: 0.5),
          )),
      child: Row(
        children: [
          Expanded(
            child: _buildEditText(),
          ),
          Padding(
            padding: EdgeInsets.only(left: padding.right),
            child: SizedBox(
              width: _searchButtonWidth,
              child: _buildSearchButton(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditText() {
    return EditText(
      defaultText: defaultText,
      outline: true,
      height: height - padding.vertical,
      onSubmitted: _onSearch,
      textNotifier: _searchTextNotifier,
    );
  }

  Widget _buildSearchButton() {
    final iconSize = 25.0;
    final paddingVertical = (_searchButtonWidth - iconSize) / 2;
    return OutlineButton(
      highlightColor: highlightColor,
      child: Icon(
        Icons.search,
        size: iconSize,
      ),
      padding:
          EdgeInsets.only(bottom: paddingVertical, top: paddingVertical - 2),
      onPressed: () => _onSearch(_searchTextNotifier.value),
    );
  }
}
