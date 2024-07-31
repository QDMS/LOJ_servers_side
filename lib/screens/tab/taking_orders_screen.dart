import 'package:flutter/material.dart';
import 'package:lojservers/model/order_model.dart';
import 'package:firebase_database/firebase_database.dart';

class TakingOrdersScreen extends StatefulWidget {
  const TakingOrdersScreen({Key? key}) : super(key: key);

  @override
  State<TakingOrdersScreen> createState() => _TakingOrdersScreenState();
}

class _TakingOrdersScreenState extends State<TakingOrdersScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _serverNameController = TextEditingController();
  final TextEditingController _tableNumberController = TextEditingController();
  final TextEditingController _commentsController = TextEditingController();
  List<bool> _checkboxValues = List.generate(35, (index) => false);
  List<String> _menuItems = [
    'Injera Chips with Hummus',
    'Watermelon Fries',
    'Sambusa',
    'Corn Ribs',
    'Doro Wot',
    'Beef Tibs',
    'Chicken Tibs',
    'Tofu Tibs',
    'Chickpea Wot (Shurro)',
    'Lentil Wot (Messir)',
    'Kay Wot',
    'Greens (Gomen)',
    'Sauteed Beets (Key Sir)',
    'Vegetable Medley (Atkil)',
    'Yellow Rice',
    'Homemade Injera',
    'Avocado Salad',
    'Nana\'s Salad',
    'Vanilla Ice Cream Crunch',
    'Buna Brownie',
    'Mrs. Barbara\'s Famous Pecan Pie',
    'Mini Coffee Ceremony',
    'Personal Teapot',
    'Ethiopian Mineral Water',
    'Soda',
    'Ethiopian Spice Ice Tea',
    'Taste of Ethiopia',
    'Vegan\'s Dream',
    'Hulet',
    'Soast',
    'PickUp',
    'DoorDash',
    'Uber Eats',
    'UnPaid',
    'Paid',
  ];

  final DatabaseReference _ordersRef =
      FirebaseDatabase.instance.ref().child('orders');

  @override
  void dispose() {
    _serverNameController.dispose();
    _tableNumberController.dispose();
    _commentsController.dispose();
    super.dispose();
  }

  void _clearForm() {
    _serverNameController.clear();
    _tableNumberController.clear();
    _commentsController.clear();
    setState(() {
      _checkboxValues = List.generate(35, (index) => false);
    });
  }

   void _submitOrder(Order order) async {
    try {
      await _ordersRef.push().set(order.toJson());
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Order submitted successfully')),
      );
      _clearForm();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error submitting order: $error')),
      );
    }
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
            centerTitle: true,
            title: const Text(
              'Take Order',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _serverNameController,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 16,
                                horizontal: 12,
                              ),
                              labelText: 'Server Name',
                              labelStyle: TextStyle(
                                fontSize: 18,
                                color: Colors.brown.shade300,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.brown.shade300,
                                  width: 2,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.brown.shade300,
                                  width: 2,
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please Enter Server Name';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: TextFormField(
                            controller: _tableNumberController,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 16,
                                horizontal: 12,
                              ),
                              labelText: 'Table Number',
                              labelStyle: TextStyle(
                                fontSize: 18,
                                color: Colors.brown.shade300,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.brown.shade300,
                                  width: 2,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.brown.shade300,
                                  width: 2,
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please Enter Table Number';
                              }
                              if (int.tryParse(value) == null) {
                                return 'Please Enter A Valid Number';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Column(
                      children: [
                        for (int i = 0; i < (_menuItems.length / 4).ceil(); i++)
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                4,
                                (index) {
                                  int itemIndex = i * 4 + index;
                                  if (itemIndex >= _menuItems.length)
                                    return const SizedBox.shrink();
                                  return Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                      children: [
                                        Checkbox(
                                          value: _checkboxValues[itemIndex],
                                          onChanged: (bool? value) {
                                            setState(() {
                                              _checkboxValues[itemIndex] =
                                                  value ?? false;
                                            });
                                          },
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          _menuItems[itemIndex],
                                          style: const TextStyle(
                                            fontSize: 18,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _commentsController,
                      maxLines: 7,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 12,
                        ),
                        labelText: 'Extra/Comments',
                        labelStyle: TextStyle(
                          fontSize: 18,
                          color: Colors.brown.shade300,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: Colors.brown.shade300,
                            width: 2,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: Colors.brown.shade300,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          List<String> selectedItems = [];
                          for (int i = 0; i < _checkboxValues.length; i++) {
                            if (_checkboxValues[i]) {
                              selectedItems.add(_menuItems[i]);
                            }
                          }
                          Order order = Order(
                            serverName: _serverNameController.text,
                            tableNumber:
                                int.tryParse(_tableNumberController.text) ?? 0,
                            selectedItems: selectedItems,
                            comments: _commentsController.text, id: '',
                          );

                          _submitOrder(order);// Submit Order To Firebase

                          _clearForm(); // Clear the form after submission

                        }
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 32,
                        ),
                        child: Text(
                          'Submit',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 75,),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
