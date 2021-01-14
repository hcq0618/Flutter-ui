import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ui/tree_node.dart';

import 'test_utils.dart';

void main() {
  group('TreeNode', () {
    testWidgets('TreeNode widget', (WidgetTester tester) async {
      await tester.pumpWidget(
        WidgetTestBuilder(
          TreeNode(
            expand: true,
            title: Text('parent'),
            children: [
              TreeNode(
                title: Text('child'),
              ),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();

      final leadingFinder = find.byIcon(Icons.expand_more);
      expect(leadingFinder, findsOneWidget);
      final parentTitleFinder = find.text('parent');
      expect(parentTitleFinder, findsOneWidget);
      final childTitleFinder = find.text('child');
      expect(childTitleFinder, findsOneWidget);
      await tester.tap(parentTitleFinder);
      await tester.pumpAndSettle();
      expect(childTitleFinder, findsNothing);
    });
  });
}
