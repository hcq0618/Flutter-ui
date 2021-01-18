import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

typedef MenuItemBuilder = Widget Function(
    BuildContext context, int menuIndex, int menuItemIndex, bool highlight);
typedef MenuItemCountGetter = int Function(int menuIndex);
typedef MenuItemTextGetter = String Function(int menuIndex, int menuItemIndex);
typedef MenuItemSelected = void Function(int menuIndex, String menuItemText);

class _FilterMenuValue {
  int _index = -1;
  List<String> _header;

  set index(int index) => _index = _index == index ? -1 : index;
}

class _FilterMenuValueNotifier extends ValueNotifier<_FilterMenuValue> {
  _FilterMenuValueNotifier(List<String> header) : super(_FilterMenuValue()) {
    value._header = header;
  }

  void selectItem(int menuIndex, String itemText) {
    value._header[menuIndex] = itemText;
  }

  void toggle(int index) {
    value.index = index;
    notifyListeners();
  }

  void hide() {
    toggle(value._index);
  }
}

class FilterMenu extends StatelessWidget {
  final _FilterMenuValueNotifier _menuValueNotifier;

  final MenuItemBuilder menuItemBuilder;
  final MenuItemCountGetter menuItemCountGetter;
  final MenuItemTextGetter menuItemTextGetter;
  final Widget overlap;
  final Color menuMaskColor;
  final Color backgroundColor;
  final TextStyle headerStyle;
  final TextStyle headerHighlightStyle;
  final double headerHeight;
  final MenuItemSelected onMenuItemSelected;

  FilterMenu({
    @required List<String> initialHeader,
    @required this.menuItemCountGetter,
    @required this.menuItemBuilder,
    @required this.menuItemTextGetter,
    @required this.overlap,
    this.backgroundColor = Colors.white,
    this.headerStyle = const TextStyle(color: Colors.grey, fontSize: 15),
    this.headerHighlightStyle =
        const TextStyle(color: Colors.green, fontSize: 15),
    this.headerHeight = 40,
    this.menuMaskColor = Colors.black54,
    this.onMenuItemSelected,
  })  : assert(initialHeader != null),
        assert(menuItemCountGetter != null),
        assert(menuItemBuilder != null),
        assert(menuItemTextGetter != null),
        assert(overlap != null),
        _menuValueNotifier = _FilterMenuValueNotifier(initialHeader);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            _FilterMenuHeader(
              _menuValueNotifier,
              headerStyle,
              headerHighlightStyle,
              headerHeight,
              backgroundColor,
            ),
            overlap,
          ],
        ),
        _FilterDropdownMenu(
          _menuValueNotifier,
          menuItemCountGetter,
          menuItemBuilder,
          menuItemTextGetter,
          onMenuItemSelected,
          headerHeight,
          menuMaskColor,
          backgroundColor,
        )
      ],
    );
  }
}

class _FilterDropdownMenu extends StatelessWidget {
  final _FilterMenuValueNotifier _menuValueNotifier;
  final MenuItemBuilder _itemBuilder;
  final MenuItemCountGetter _itemCountGetter;
  final MenuItemTextGetter _menuItemTextGetter;
  final MenuItemSelected _onMenuItemSelected;
  final double _headerHeight;
  final Color _maskColor;
  final Color _backgroundColor;

  List<String> get _header => _menuValueNotifier.value._header;

  _FilterDropdownMenu(
    this._menuValueNotifier,
    this._itemCountGetter,
    this._itemBuilder,
    this._menuItemTextGetter,
    this._onMenuItemSelected,
    this._headerHeight,
    this._maskColor,
    this._backgroundColor,
  );

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<_FilterMenuValue>(
      valueListenable: _menuValueNotifier,
      builder: _buildMenu,
      child: _buildMask(context),
    );
  }

  Widget _buildMenu(
      BuildContext context, _FilterMenuValue menuValue, Widget mask) {
    final menuIndex = menuValue._index;
    final itemCount = menuIndex < 0 ? 0 : _itemCountGetter(menuIndex);
    final size = MediaQuery.of(context).size;

    return Visibility(
      visible: menuIndex >= 0 && menuIndex < itemCount,
      child: Positioned(
        top: _headerHeight,
        child: Column(
          children: [
            Container(
              width: size.width,
              color: _backgroundColor,
              child: _buildList(menuIndex, itemCount),
            ),
            mask,
          ],
        ),
      ),
    );
  }

  Widget _buildList(int menuIndex, int itemCount) {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: itemCount,
      itemBuilder: (context, index) => GestureDetector(
        onTap: () {
          final itemText = _menuItemTextGetter(menuIndex, index);
          _menuValueNotifier.selectItem(menuIndex, itemText);
          _menuValueNotifier.hide();

          if (_onMenuItemSelected != null) {
            _onMenuItemSelected(menuIndex, itemText);
          }
        },
        child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Expanded(
            child: _itemBuilder(context, menuIndex, index,
                _menuItemTextGetter(menuIndex, index) == _header[menuIndex]),
          ),
        ]),
      ),
      separatorBuilder: (context, index) =>
          const Divider(height: 0.5, color: Colors.grey),
    );
  }

  Widget _buildMask(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        _menuValueNotifier.hide();
      },
      child: Container(
        height: size.height,
        width: size.width,
        color: _maskColor,
      ),
    );
  }
}

class _FilterMenuHeader extends StatelessWidget {
  final _FilterMenuValueNotifier _menuValueNotifier;
  final Color _backgroundColor;
  final TextStyle _style;
  final TextStyle _highlightStyle;
  final double _height;

  List<String> get _header => _menuValueNotifier.value._header;

  _FilterMenuHeader(
    this._menuValueNotifier,
    this._style,
    this._highlightStyle,
    this._height,
    this._backgroundColor,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _height,
      decoration: BoxDecoration(
        color: _backgroundColor,
        border: const Border(
          bottom: const BorderSide(color: Colors.grey, width: 0.5),
        ),
      ),
      child: _buildHeader(context),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final count = _header.length;
    final itemWidth = MediaQuery.of(context).size.width / count;
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: count,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: count,
        childAspectRatio: itemWidth / _height,
      ),
      itemBuilder: (ctx, index) => _buildItem(index),
    );
  }

  Widget _buildItem(int index) {
    return GestureDetector(
      onTap: () {
        _menuValueNotifier.toggle(index);
      },
      child: ValueListenableBuilder<_FilterMenuValue>(
        valueListenable: _menuValueNotifier,
        builder: (context, value, child) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildItemTextAndIcon(value._index, index),
              child,
            ],
          );
        },
        child: _buildItemDivider(index),
      ),
    );
  }

  Widget _buildItemTextAndIcon(int menuIndex, int index) {
    final isDropdown = index == menuIndex;
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _header[index],
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: isDropdown ? _highlightStyle : _style,
          ),
          Icon(
            !isDropdown ? Icons.arrow_drop_down : Icons.arrow_drop_up,
            color: isDropdown ? _highlightStyle.color : _style.color,
            size: 20,
          )
        ],
      ),
    );
  }

  Widget _buildItemDivider(int index) {
    final indent = _height / 4;
    return Visibility(
      visible: index < _header.length - 1,
      child: VerticalDivider(
        color: Colors.grey,
        thickness: 0.5,
        indent: indent,
        endIndent: indent,
      ),
    );
  }
}
