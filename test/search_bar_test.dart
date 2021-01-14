import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ui/edit_text.dart';
import 'package:flutter_ui/search_bar.dart';

import 'test_utils.dart';

void main() {
  group('SearchBar', () {
    testWidgets('SearchBar widget', (WidgetTester tester) async {
      var isOnSearchCallback = false;

      await tester.pumpWidget(
        WidgetTestBuilder(
          SearchBar(
            (String keyword) => isOnSearchCallback = true,
            defaultText: 'default',
          ),
        ),
      );
      await tester.pumpAndSettle();

      final containerFinder = find.byWidgetPredicate(_containerPredicate);
      expect(containerFinder, findsOneWidget);

      final editTextFinder = find.byWidgetPredicate(_editTextPredicate);
      expect(editTextFinder, findsOneWidget);

      final searchButtonFinder = find.byWidgetPredicate(_searchButtonPredicate);
      expect(searchButtonFinder, findsOneWidget);
      await tester.tap(searchButtonFinder);
      expect(isOnSearchCallback, true);
    });
  });
}

bool _containerPredicate(Widget widget) {
  if (widget is Container) {
    final decoration = widget.decoration;
    if (decoration is BoxDecoration) {
      if (decoration.color == Colors.white) {
        final border = decoration.border;
        if (border is Border) {
          final bottom = border.bottom;
          return bottom is BorderSide && bottom.color == Colors.grey;
        }
      }
    }
  }
  return false;
}

bool _editTextPredicate(Widget widget) {
  if (widget is EditText) {
    return widget.defaultText == 'default' && widget.outline;
  }
  return false;
}

bool _searchButtonPredicate(Widget widget) {
  if (widget is OutlineButton) {
    if (widget.highlightColor == Colors.green) {
      final icon = widget.child;
      if (icon is Icon) {
        return icon.icon == Icons.search;
      }
    }
  }
  return false;
}
