import 'package:flutter/material.dart';

class ListCategoryData {
  static const List<String> categories = [
    'Makanan',
    'Internet',
    'Edukasi',
    'Hadiah',
    'Transport',
    'Belanja',
    'AlatRumah',
    'Olahraga',
    'Hiburan',
  ];

  static const Map<String, Color> categoryColors = {
    'Makanan': Color(0xFFF2C94C),
    'Internet': Color(0xFF56CCF2),
    'Edukasi': Color(0xFFF2994A),
    'Hadiah': Color(0xFFEB5757),
    'Transport': Color(0xFF9B51E0),
    'Belanja': Color(0xFF27AE60),
    'AlatRumah': Color(0xFFBB6BD9),
    'Olahraga': Color(0xFF2D9CDB),
    'Hiburan': Color(0xFF2D9CDB),
  };
}

class CategoryIcon {
  static Map<String, Image> categoryIcons = {
    'Makanan': Image.asset('assets/png/makanan.png'),
    'Internet': Image.asset('assets/png/internet.png'),
    'Edukasi': Image.asset('assets/png/edukasi.png'),
    'Hadiah': Image.asset('assets/png/hadiah.png'),
    'Transport': Image.asset('assets/png/transport.png'),
    'Belanja': Image.asset('assets/png/belanja.png'),
    'AlatRumah': Image.asset('assets/png/rumah.png'),
    'Olahraga': Image.asset('assets/png/olahraga.png'),
    'Hiburan': Image.asset('assets/png/hiburan.png'),
  };
}
