import 'package:flutter/material.dart';

// codes from https://pub.dev/packages/flutter_tree and improve
class TreeNode extends StatefulWidget {
  final bool expand;
  final double offsetLeft;
  final List<Widget> children;

  final Widget title;
  final Widget leading;

  TreeNode({
    this.expand = false,
    this.offsetLeft = 12,
    this.children = const [],
    this.title = const Text('Title'),
    this.leading = const Icon(Icons.expand_more),
  })  : assert(children != null),
        assert(title != null),
        assert(leading != null);

  @override
  _TreeNodeState createState() => _TreeNodeState();
}

class _TreeNodeState extends State<TreeNode>
    with SingleTickerProviderStateMixin {
  final double _rowPaddingHorizontal = 12;
  final Tween<double> _turnsTween = Tween<double>(begin: 0.0, end: -0.5);
  AnimationController _rotationController;
  bool _isExpand = false;

  @override
  void initState() {
    _isExpand = widget.expand;
    _rotationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildNode(),
        _buildChildren(),
      ],
    );
  }

  Widget _buildNode() {
    return Padding(
      padding: EdgeInsets.only(
          left: _rowPaddingHorizontal, right: _rowPaddingHorizontal),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _isExpand = !_isExpand;
            if (_isExpand) {
              _rotationController.forward();
            } else {
              _rotationController.reverse();
            }
          });
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildLeading(),
            _buildTitle(),
          ],
        ),
      ),
    );
  }

  Widget _buildLeading() {
    return Visibility(
        visible: widget.children.isNotEmpty,
        child: Center(
          child: RotationTransition(
            child: widget.leading,
            turns: _turnsTween.animate(_rotationController),
          ),
        ));
  }

  Widget _buildTitle() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 6, right: 6, top: 10, bottom: 10),
        child: widget.title,
      ),
    );
  }

  Widget _buildChildren() {
    return Visibility(
      visible: widget.children.isNotEmpty && _isExpand,
      child: Padding(
        padding:
            EdgeInsets.only(left: _rowPaddingHorizontal + widget.offsetLeft),
        child: Column(
          children: widget.children,
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
      ),
    );
  }
}
