// ignore_for_file: unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:takopedia/services/order_provider.dart';

import '../util/style.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  int cartItem = 0;
  bool isTakeAway = false;
  int value = 0;
  bool isLoading = true;

  String formatCurrency(String price) {
    final formatter = NumberFormat.currency(locale: 'id', symbol: 'Rp ');
    return formatter.format(int.parse(price));
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final history = Provider.of<OrderProvider>(context).trans;
    // final isTakeAway =
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 245, 66, 66),
        title: const Center(
          child: Text(
            'Order History',
            style: TextStyle(
                color: Color.fromARGB(255, 247, 242, 242),
                fontFamily: "Poppins-bold",
                fontSize: 16),
          ),
        ),
      ),
      body: Container(
        decoration:
            const BoxDecoration(color: Color.fromARGB(255, 255, 245, 245)),
        child: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  history.isEmpty
                      ? const Center(
                          child: Text(
                            'Empty',
                            style: TextStyle(
                                fontFamily: 'Poppins-bold', fontSize: 30),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: history.length,
                          itemBuilder: (context, index) {
                            final historyItem = history[index];
                            int totalPrice = 0;
                            return Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 255, 255, 255),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8.0,
                                          left: 14,
                                          bottom: 8,
                                          right: 20),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            'Transaction ID',
                                            style: OrderTitleTextStyle,
                                          ),
                                          Text(
                                            historyItem.transId,
                                            style: OrderDetailTextStyle,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 6.0),
                                      child: Divider(),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 2.0,
                                          left: 14,
                                          bottom: 0,
                                          right: 20),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            historyItem.deliveryType,
                                            style: const TextStyle(
                                                fontFamily: 'Poppins-regular',
                                                fontSize: 15),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.only(
                                          top: 8.0,
                                          left: 14,
                                          bottom: 8,
                                          right: 20),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Items :',
                                            style: OrderDetailTextStyle,
                                          ),
                                        ],
                                      ),
                                    ),
                                    StreamBuilder(
                                        stream: FirebaseFirestore.instance
                                            .collection('orders')
                                            .where('trans_id',
                                                isEqualTo: historyItem.transId)
                                            .snapshots(),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return const CircularProgressIndicator(
                                              color: Color.fromARGB(
                                                  255, 236, 101, 101),
                                            );
                                          } else if (snapshot.hasError) {
                                            return Text("error");
                                          } else if (!snapshot.hasData) {
                                            return Text("Empty");
                                          } else {
                                            final datalist =
                                                snapshot.data!.docs;
                                            return ListView.builder(
                                              shrinkWrap: true,
                                              itemCount: datalist.length,
                                              itemBuilder: (context, index) {
                                                var item =
                                                    datalist[index].data();
                                                int quantity = item['quantity'];
                                                int price =
                                                    item['product']['price'];
                                                return Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 8.0,
                                                      left: 14,
                                                      bottom: 8,
                                                      right: 20),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        item['product']['name'],
                                                        style:
                                                            HistoryItemTextStyle,
                                                      ),
                                                      Text(
                                                        '${quantity}x',
                                                        style:
                                                            HistoryItemTextStyle,
                                                      )
                                                    ],
                                                  ),
                                                );
                                              },
                                            );
                                          }
                                        }),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: 8.0,
                                          left: 14,
                                          bottom: 8,
                                          right: 20),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Total',
                                            style: OrderTitleTextStyle,
                                          ),
                                          Text(
                                            '$totalPrice',
                                            style: TextStyle(
                                              fontFamily: 'Poppins-bold',
                                              fontSize: 14,
                                              color: Color.fromARGB(
                                                  255, 44, 44, 44),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                  SizedBox(
                    height: 200,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      bottomSheet: BottomSheet(
          backgroundColor: const Color.fromARGB(255, 255, 245, 245),
          elevation: 0,
          onClosing: () {},
          builder: (context) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ButtonStyle(
                      shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20))),
                      fixedSize: MaterialStateProperty.all(const Size(290, 52)),
                      padding: MaterialStateProperty.all(
                          const EdgeInsets.fromLTRB(0, 0, 0, 0)),
                      backgroundColor: MaterialStateProperty.all(
                          Color.fromARGB(255, 247, 108, 108)),
                      elevation: MaterialStateProperty.all(3),
                    ),
                    child: const Text(
                      'Back',
                      style: TextStyle(
                          color: Color.fromARGB(255, 255, 246, 246),
                          fontFamily: 'Poppins-Bold'),
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
