import 'package:flutter/material.dart';
import 'package:flutter_ui/edit_text.dart';
import 'package:flutter_ui/filter_menu.dart';
import 'package:flutter_ui/search_bar.dart';
import 'package:flutter_ui/tree_node.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter UI Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter UI Demo Home Page'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;

  MyHomePage({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            _buildSearchBar(),
            Expanded(child: _buildFilterMenu()),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return SearchBar((String searchText) {});
  }

  Widget _buidListView(List<Widget> widgets) {
    return ListView.builder(
      shrinkWrap: true,
      itemBuilder: (context, index) => widgets[index],
      itemCount: widgets.length,
    );
  }

  Widget _buildEditText() {
    return EditText(
      defaultText: 'default text',
      outline: true,
    );
  }

  Widget _buildFilterMenu() {
    final data = [
      ['All', 'text11', 'text12'],
      ['All', 'text21', 'text22'],
    ];
    return FilterMenu(
      initialHeader: data.map((menu) => menu[0]).toList(),
      menuItemCountGetter: (menuIndex) => data[menuIndex].length,
      menuItemBuilder: (context, menuIndex, menuItemIndex, highlight) =>
          Container(
        padding: EdgeInsets.all(8),
        height: 35,
        child: Text(
          data[menuIndex][menuItemIndex],
          style: TextStyle(
            color: highlight ? Colors.green : Colors.black,
          ),
        ),
      ),
      menuItemTextGetter: (menuIndex, menuItemIndex) =>
          data[menuIndex][menuItemIndex],
      onMenuItemSelected: (menuIndex, menuItemText) => VoidCallback,
      overlap: _buidListView([_buildEditText(), _buildTreeView()]),
    );
  }

  Widget _buildTreeView() {
    return TreeNode(
      expand: true,
      title: Text('parent'),
      children: [
        TreeNode(
          title: Text('child'),
        ),
      ],
    );
  }
}
