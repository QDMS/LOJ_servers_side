import 'package:flutter/material.dart';
import 'package:lojservers/model/order_model.dart';
import 'package:firebase_database/firebase_database.dart';

class ListOfOrdersScreen extends StatefulWidget {
  const ListOfOrdersScreen({super.key});

  @override
  State<ListOfOrdersScreen> createState() => _ListOfOrdersScreenState();
}

class _ListOfOrdersScreenState extends State<ListOfOrdersScreen> {
  final DatabaseReference _ordersRef =
      FirebaseDatabase.instance.ref().child('orders');

  Future<void> _showConfirmationDialog(String orderId) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Are you sure you want to delete this order?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () async {
                await _ordersRef.child(orderId).remove();
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Order deleted successfully')),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/background.png'),
              fit: BoxFit.fill,
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            surfaceTintColor: Colors.transparent,
            title: const Text(
              'Orders List',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Container(
                  height: 200,
                  width: 200,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/logo.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: StreamBuilder(
                    stream: _ordersRef.onValue,
                    builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return const Center(
                            child: Text('Error loading orders'));
                      }

                      if (!snapshot.hasData ||
                          snapshot.data!.snapshot.value == null) {
                        return const Center(
                            child: Text(
                          'No orders available',
                          style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                          ),
                        ));
                      }

                      final ordersMap = snapshot.data!.snapshot.value
                          as Map<dynamic, dynamic>;
                      final orders = ordersMap.entries.map((entry) {
                        final orderData = entry.value as Map<dynamic, dynamic>;
                        return Order(
                          id: entry.key,
                          serverName: orderData['serverName'],
                          tableNumber: orderData['tableNumber'],
                          selectedItems:
                              List<String>.from(orderData['selectedItems']),
                          comments: orderData['comments'],
                        );
                      }).toList();

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 30.0),
                        child: ListView.builder(
                          itemCount: orders.length,
                          itemBuilder: (context, index) {
                            final order = orders[index];
                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              margin: const EdgeInsets.symmetric(vertical: 10.0),
                              child: ListTile(
                                title: Text('Server: ${order.serverName}'),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Table: ${order.tableNumber}'),
                                    Text(
                                        'Items: ${order.selectedItems.join(', ')}'),
                                    Text('Comments: ${order.comments}'),
                                  ],
                                ),
                                trailing: IconButton(
                                  icon:
                                      const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () async {
                                    await _showConfirmationDialog(order.id);
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
