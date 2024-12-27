import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'package:shopping_list/data/categories.dart';
import 'package:shopping_list/models/category.dart';
import 'package:shopping_list/models/grocery_item.dart';

class NewItem extends StatefulWidget {
  const NewItem({super.key});
  @override
  State<NewItem> createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {
  final _fromKey = GlobalKey<FormState>();
  var _enteredName = '';
  var _enterdQuantity = 1;
  var _selectedCategory = categories[Categories.vegetables]!;

  var _isSending = false;

  void _saveItem() async {
    if (_fromKey.currentState!.validate()) {
      setState(() {
        _isSending = true;
      });
      _fromKey.currentState!.save();
      final url = Uri.https(
          'flutter-prep-529b5-default-rtdb.asia-southeast1.firebasedatabase.app',
          'shopping-list.json');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'name': _enteredName,
          'quantity': _enterdQuantity,
          'category': _selectedCategory.title,
        }),
      );

      print(response.body);
      print(response.statusCode);

      if (!context.mounted) {
        return;
      }
      final Map<String, dynamic> resData = json.decode(response.body);
      Navigator.of(context).pop(GroceryItem(
          id: resData['name'],
          name: _enteredName,
          quantity: _enterdQuantity,
          category: _selectedCategory));
    }
  }

  void _resetItems() {
    _fromKey.currentState!.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('新增項目'),
      ),
      body: Padding(
          padding: const EdgeInsets.all(12),
          child: Form(
              key: _fromKey,
              child: Column(
                children: [
                  TextFormField(
                    maxLength: 50,
                    decoration: InputDecoration(label: Text('名稱')),
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          value.trim().length <= 1 ||
                          value.trim().length > 50) {
                        return '長度必須介於1到50個字元之間。';
                      }
                      return null;
                    },
                    // validator驗證成功才會執行onSaved
                    onSaved: (value) {
                      // value已經在validator驗證過了，所以不會有空值的問題，可以直接wrap
                      _enteredName = value!;
                    },
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(
                            label: Text('數量'),
                          ),
                          keyboardType: TextInputType.number,
                          initialValue: _enterdQuantity.toString(),
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                int.tryParse(value) == null ||
                                int.tryParse(value)! <= 0) {
                              return '請輸入有效的正整數。';
                            }
                            return null;
                          },
                          // validator驗證成功才會執行onSaved
                          onSaved: (value) {
                            _enterdQuantity = int.parse(value!);
                          },
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: DropdownButtonFormField(
                            value: _selectedCategory,
                            items: [
                              for (final category in categories.entries)
                                DropdownMenuItem(
                                  value: category.value,
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 16,
                                        height: 16,
                                        color: category.value.color,
                                      ),
                                      SizedBox(
                                        width: 6,
                                      ),
                                      Text(category.value.title),
                                    ],
                                  ),
                                ),
                            ],
                            onChanged: (value) {
                              _selectedCategory = value!;
                            }),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: _isSending ? null : _resetItems,
                        child: Text('重置'),
                      ),
                      ElevatedButton(
                        onPressed: _isSending ? null : _saveItem,
                        child: _isSending
                            ? SizedBox(
                                height: 16,
                                width: 16,
                                child: CircularProgressIndicator(),
                              )
                            : Text('新增項目'),
                      ),
                    ],
                  ), // instead of TextField()
                ],
              ))),
    );
  }
}
