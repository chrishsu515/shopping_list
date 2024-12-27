import 'package:flutter/material.dart';

import 'package:shopping_list/models/category.dart';

const categories = {
  Categories.vegetables: Category(
    '蔬菜',
    Color.fromARGB(255, 0, 255, 128),
  ),
  Categories.fruit: Category(
    '水果',
    Color.fromARGB(255, 145, 255, 0),
  ),
  Categories.meat: Category(
    '肉類',
    Color.fromARGB(255, 255, 102, 0),
  ),
  Categories.dairy: Category(
    '乳製品',
    Color.fromARGB(255, 0, 208, 255),
  ),
  Categories.carbs: Category(
    '碳水化合物',
    Color.fromARGB(255, 0, 60, 255),
  ),
  Categories.sweets: Category(
    '甜食',
    Color.fromARGB(255, 255, 149, 0),
  ),
  Categories.spices: Category(
    '調味料',
    Color.fromARGB(255, 255, 187, 0),
  ),
  Categories.convenience: Category(
    '便利食品',
    Color.fromARGB(255, 191, 0, 255),
  ),
  Categories.hygiene: Category(
    '衛生用品',
    Color.fromARGB(255, 149, 0, 255),
  ),
  Categories.other: Category(
    '其他',
    Color.fromARGB(255, 0, 225, 255),
  ),
};
