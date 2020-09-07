import 'dart:math';

import 'package:flutter/material.dart';

class AnimatedListSample extends StatefulWidget {
  AnimatedListSample({Key key}) : super(key: key);

  @override
  _AnimatedListSampleState createState() => _AnimatedListSampleState();
}

final _dataSource = <String>[
  'キュウイ',
  'バナナ',
  'リンゴ',
  'オレンジ',
];

class _AnimatedListSampleState extends State<AnimatedListSample> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  List<String> _items;

  @override
  void initState() {
    super.initState();
    _items = _dataSource.toList();
  }

  void _insert({
    String item,
    int index,
  }) {
    String newItem;
    int targetIndex;
    if (item == null) {
      final index = Random().nextInt(_dataSource.length - 1);
      newItem = _dataSource[index];
      targetIndex = _items.length;
    } else {
      newItem = item;
      targetIndex = index;
    }
    _items.insert(targetIndex, newItem);
    _listKey.currentState.insertItem(targetIndex);
  }

  void _remove(int index) {
    _scaffoldKey.currentState.hideCurrentSnackBar();
    final item = _items.removeAt(index);
    _listKey.currentState.removeItem(index, (context, animation) {
      return SizeTransition(
        sizeFactor: animation,
        child: Card(
          child: Center(
            child: CheckboxListTile(
              value: false,
              onChanged: null,
              title: Text(
                item,
                style: TextStyle(
                  decoration: TextDecoration.lineThrough,
                ),
              ),
            ),
          ),
        ),
      );
    });
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(
        '$item を削除しました',
      ),
      action: SnackBarAction(
        label: '戻す',
        onPressed: () {
          _insert(
            item: item,
            index: index,
          );
        },
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('animated list sample'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _insert,
        child: Icon(Icons.add),
      ),
      body: AnimatedList(
        key: _listKey,
        itemBuilder: (context, index, animation) {
          return SizeTransition(
            sizeFactor: animation,
            child: Card(
              child: Center(
                child: CheckboxListTile(
                  value: false,
                  onChanged: (value) {
                    _remove(index);
                  },
                  title: Text(_items[index]),
                ),
              ),
            ),
          );
        },
        initialItemCount: _items.length,
      ),
    );
  }
}
