import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ui/edit_text.dart';

import 'test_utils.dart';

void main() {
  group('EditText', () {
    testWidgets('EditText widget: outline and clearButtonEnable is true',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        WidgetTestBuilder(
          EditText(
            defaultText: 'default',
            outline: true,
            cleanButtonEnable: true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      final stackFinder = find.byWidgetPredicate(_stackPredicate);
      expect(stackFinder, findsOneWidget);
      final textFieldFinder = find.byWidgetPredicate(
          (widget) => _textFieldPredicate(widget, 'default', true));
      expect(textFieldFinder, findsOneWidget);
      final clearButtonFinder = find.byWidgetPredicate(_clearButtonPredicate);
      expect(clearButtonFinder, findsOneWidget);
      await tester.tap(clearButtonFinder);
      await tester.pumpAndSettle();
      final textFieldFinder2 = find.byWidgetPredicate((widget) =>
          widget is TextField &&
          widget.controller.value == TextEditingValue.empty);
      expect(textFieldFinder2, findsOneWidget);
      expect(clearButtonFinder, findsNothing);
    });

    testWidgets('EditText widget: outline and clearButtonEnable is false',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        WidgetTestBuilder(
          EditText(
            defaultText: 'default',
            outline: false,
            cleanButtonEnable: false,
          ),
        ),
      );
      await tester.pumpAndSettle();

      final stackFinder = find.byWidgetPredicate(_stackPredicate);
      expect(stackFinder, findsOneWidget);
      final textFieldFinder = find.byWidgetPredicate(
          (widget) => _textFieldPredicate(widget, 'default', false));
      expect(textFieldFinder, findsOneWidget);
      final clearButtonFinder = find.byWidgetPredicate(_clearButtonPredicate);
      expect(clearButtonFinder, findsNothing);
    });

    testWidgets('EditText widget: text is empty', (WidgetTester tester) async {
      await tester.pumpWidget(
        WidgetTestBuilder(
          EditText(
            defaultText: '',
            outline: false,
            cleanButtonEnable: true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      final stackFinder = find.byWidgetPredicate(_stackPredicate);
      expect(stackFinder, findsOneWidget);
      final textFieldFinder = find.byWidgetPredicate(
          (widget) => _textFieldPredicate(widget, '', false));
      expect(textFieldFinder, findsOneWidget);
      final clearButtonFinder = find.byWidgetPredicate(_clearButtonPredicate);
      expect(clearButtonFinder, findsNothing);
    });
  });
}

bool _stackPredicate(Widget widget) {
  return widget is Stack && widget.alignment == AlignmentDirectional.centerEnd;
}

bool _textFieldPredicate(Widget widget, String defaultText, bool outline) {
  if (widget is TextField) {
    final textEditController = widget.controller;
    if (textEditController.text == defaultText) {
      final textSelection = textEditController.selection;
      if (textSelection.affinity == TextAffinity.downstream &&
          textSelection.baseOffset == defaultText.length) {
        final decoration = widget.decoration;
        final border = decoration.border;
        if (outline
            ? border is OutlineInputBorder
            : border is UnderlineInputBorder) {
          return decoration.focusedBorder.borderSide.color == Colors.green;
        }
      }
    }
  }
  return false;
}

bool _clearButtonPredicate(Widget widget) {
  if (widget is OutlineButton) {
    final icon = widget.child;
    if (widget.shape is CircleBorder) {
      if (icon is Icon) {
        return widget.highlightColor == Colors.green &&
            icon.icon == Icons.clear;
      }
    }
  }
  return false;
}
