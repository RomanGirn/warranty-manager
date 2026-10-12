import 'package:flutter/material.dart';
import '../models/warranty_item.dart';
import '../theme/app_theme.dart';

/// Hardcoded data used instead of a backend.
class MockData {
  static const String firstName = 'Олександр';
  static const String lastName = 'Коваленко';
  static const String fullName = '$firstName $lastName';
  static const String initials = 'ОК';
  static const String email = 'o.kovalenko@example.com';
  static const String phone = '+380 67 123 45 67';
  static const String registrationDate = '14 травня 2023 року';
  static const String syncLabel = 'Синхронізовано 2 хв тому';

  static const int totalItems = 4;
  static const int activeItems = 1;
  static const int expiringItems = 2;
  static const int expiredItems = 1;

  static const List<WarrantyItem> items = [
    WarrantyItem(
      category: 'Електроніка',
      title: 'Смартфон Apple iPhone 15 Pro',
      purchaseDate: '15.09.2024',
      price: '48 999 ₴',
      icon: Icons.smartphone,
      documentTitle: 'Фіскальний чек #UA-48021',
      documentNote: 'Чек підтверджено OCR',
      documentNoteIcon: Icons.verified_outlined,
      documentNoteColor: AppColors.success,
      statusLabel: 'Активна (ще 280 днів)',
      endLabel: 'до 15.09.2025',
      progress: 0.23,
      status: WarrantyStatus.active,
    ),
    WarrantyItem(
      category: 'Електроніка',
      title: 'Ноутбук ASUS ROG Zephyrus',
      purchaseDate: '20.04.2023',
      price: '64 000 ₴',
      icon: Icons.laptop_mac,
      documentTitle: 'Гарантійний талон Comfy #6104',
      documentNote: '2 файли додано',
      documentNoteIcon: Icons.attach_file,
      documentNoteColor: AppColors.info,
      statusLabel: 'Закінчується (18 днів)',
      endLabel: 'до 20.04.2025',
      progress: 0.95,
      status: WarrantyStatus.expiring,
    ),
    WarrantyItem(
      category: 'Побутова техніка',
      title: 'Пральна машина LG AI DD',
      purchaseDate: '10.12.2022',
      price: '21 500 ₴',
      icon: Icons.local_laundry_service_outlined,
      documentTitle: 'Чек Rozetka #RT-08312',
      documentNote: 'Потребує уваги',
      documentNoteIcon: Icons.error_outline,
      documentNoteColor: AppColors.danger,
      statusLabel: 'Критична (4 дні)',
      endLabel: 'до 10.12.2024',
      progress: 0.98,
      status: WarrantyStatus.critical,
    ),
    WarrantyItem(
      category: 'Побутова техніка',
      title: "Кавомашина De'Longhi Magnifica",
      purchaseDate: '05.11.2021',
      price: '17 299 ₴',
      icon: Icons.coffee_maker_outlined,
      statusLabel: 'Закінчилась',
      endLabel: 'Термін сплив 05.11.2023',
      progress: 1.0,
      status: WarrantyStatus.expired,
    ),
  ];
}
