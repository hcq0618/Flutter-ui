import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ui/filter_menu.dart';

import 'test_utils.dart';

void main() {
  group('FilterMenu', () {
    testWidgets('FilterMenu widget: click header', (WidgetTester tester) async {
      await tester.pumpWidget(_buildPage());
      await tester.pumpAndSettle();

      final allTextFinder = find.text('All');
      expect(allTextFinder, findsNWidgets(2));
      final listViewFinder = find.byType(ListView);

      await tester.tap(allTextFinder.first);
      await tester.pumpAndSettle();
      expect(listViewFinder, findsOneWidget);
      expect(allTextFinder, findsNWidgets(3));
      final highlightItemFinder = find.byWidgetPredicate(
          (widget) => widget is Text && widget.style.color == Colors.green);
      expect(highlightItemFinder, findsNWidgets(2));
      final menu1Item2Finder = find.text('text11');
      expect(menu1Item2Finder, findsOneWidget);
      final menu1Item3Finder = find.text('text12');
      expect(menu1Item3Finder, findsOneWidget);
    });

    testWidgets('FilterMenu widget: click menu mask',
        (WidgetTester tester) async {
      await tester.pumpWidget(_buildPage());
      await tester.pumpAndSettle();

      final allTextFinder = find.text('All');
      final listViewFinder = find.byType(ListView);

      await tester.tap(allTextFinder.first);
      await tester.pumpAndSettle();
      expect(listViewFinder, findsOneWidget);
      final maskFinder = find.byWidgetPredicate(
          (widget) => widget is Container && widget.color == Colors.black);
      expect(maskFinder, findsOneWidget);

      await tester.tap(maskFinder);
      await tester.pumpAndSettle();
      expect(allTextFinder, findsNWidgets(2));
      expect(listViewFinder, findsNothing);
    });

    testWidgets('FilterMenu widget: click menu item',
        (WidgetTester tester) async {
      await tester.pumpWidget(_buildPage());
      await tester.pumpAndSettle();

      final allTextFinder = find.text('All');
      final listViewFinder = find.byType(ListView);

      await tester.tap(allTextFinder.first);
      await tester.pumpAndSettle();
      expect(listViewFinder, findsOneWidget);
      final menu1Item2Finder = find.text('text11');
      final menu1Item3Finder = find.text('text12');

      await tester.tap(menu1Item3Finder);
      await tester.pumpAndSettle();
      expect(listViewFinder, findsNothing);
      expect(allTextFinder, findsOneWidget);
      expect(menu1Item2Finder, findsNothing);
      expect(menu1Item3Finder, findsOneWidget);
    });
  });
}

Widget _buildPage() {
  final data = [
    ['All', 'text11', 'text12'],
    ['All', 'text21', 'text22'],
  ];
  return WidgetTestBuilder(
    FilterMenu(
      initialHeader: data.map((menu) => menu[0]).toList(),
      menuItemCountGetter: (menuIndex) => data[menuIndex].length,
      menuItemBuilder: (context, menuIndex, menuItemIndex, highlight) => Text(
        data[menuIndex][menuItemIndex],
        style: TextStyle(
          color: highlight ? Colors.green : Colors.black,
        ),
      ),
      menuItemTextGetter: (menuIndex, menuItemIndex) =>
          data[menuIndex][menuItemIndex],
      onMenuItemSelected: (menuIndex, menuItemText) => VoidCallback,
      overlap: SizedBox(),
      menuMaskColor: Colors.black,
    ),
  );
}
