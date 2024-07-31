import 'package:firebase_database/firebase_database.dart';

class Order {
  final String id;
  final String serverName;
  final int tableNumber;
  final List<String> selectedItems;
  final String comments;

  Order({
    required this.id,
    required this.serverName,
    required this.tableNumber,
    required this.selectedItems,
    required this.comments,
  });

  factory Order.fromSnapshot(DataSnapshot snapshot) {
    final data = snapshot.value as Map<dynamic, dynamic>;
    return Order(
      id: snapshot.key ?? '',
      serverName: data['serverName'],
      tableNumber: data['tableNumber'],
      selectedItems: List<String>.from(data['selectedItems']),
      comments: data['comments'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'serverName': serverName,
      'tableNumber': tableNumber,
      'selectedItems': selectedItems,
      'comments': comments,
    };
  }
}
