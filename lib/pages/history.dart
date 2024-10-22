// ignore_for_file: unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:takopedia/model/product_model.dart';
import 'package:takopedia/pages/component/rating.dart';
import 'package:takopedia/services/order_provider.dart';
import 'package:takopedia/services/product_provider.dart';

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
  List<int> quantity = [];
  List<int> price = [];

  String formatCurrency(String price) {
    final formatter = NumberFormat.currency(locale: 'id', symbol: 'Rp ');
    return formatter.format(int.parse(price));
  }

  String minSize(String size) {
    return size == 'Large' ? 'L' : 'R';
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final history = Provider.of<OrderProvider>(context).trans;
    final product = Provider.of<ProductProvider>(context);
    // final isTakeAway =
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 251, 251),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        surfaceTintColor: Color.fromARGB(255, 252, 245, 245),
        backgroundColor: Color.fromARGB(255, 255, 252, 252),
        title: const Center(
          child: Text(
            'Order History',
            style: TextStyle(
                color: Color.fromARGB(255, 255, 94, 94),
                fontFamily: "Poppins-bold",
                fontSize: 16),
          ),
        ),
      ),
      body: Container(
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
                      ? const Text('')
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: history.length,
                          itemBuilder: (context, index) {
                            final historyItem = history[index];
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
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            historyItem.deliveryType,
                                            style: const TextStyle(
                                                fontFamily: 'Poppins-regular',
                                                fontSize: 15),
                                          ),
                                          Text(
                                            DateFormat('dd MMM yyyy hh:mm a')
                                                .format(historyItem.timestamp),
                                            style: TextStyle(
                                                fontFamily: 'Poppins-regular',
                                                fontSize: 15),
                                          )
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
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              itemCount: datalist.length,
                                              itemBuilder: (context, index) {
                                                var cartItem =
                                                    datalist[index].data();
                                                return Column(
                                                  children: [
                                                    Container(
                                                      decoration:
                                                          const BoxDecoration(
                                                        color: Color.fromARGB(
                                                            255, 255, 255, 255),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    10)),
                                                      ),
                                                      width: MediaQuery.sizeOf(
                                                              context)
                                                          .width,
                                                      child: Column(
                                                        children: [
                                                          Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        8.0),
                                                                child:
                                                                    ClipRRect(
                                                                  clipBehavior:
                                                                      Clip.hardEdge,
                                                                  borderRadius:
                                                                      const BorderRadius
                                                                          .all(
                                                                          Radius.circular(
                                                                              100)),
                                                                  child:
                                                                      Container(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      boxShadow: const [
                                                                        BoxShadow(
                                                                            offset: Offset(0.1,
                                                                                0.1),
                                                                            blurRadius:
                                                                                1)
                                                                      ],
                                                                    ),
                                                                    child: Image
                                                                        .network(
                                                                      cartItem[
                                                                              'product']
                                                                          [
                                                                          'picURL'],
                                                                      height:
                                                                          80,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            3.0,
                                                                        top:
                                                                            10),
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .end,
                                                                  children: [
                                                                    SizedBox(
                                                                      width: MediaQuery.sizeOf(context)
                                                                              .width -
                                                                          180,
                                                                      child:
                                                                          Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                            cartItem['product']['name'],
                                                                            maxLines:
                                                                                1,
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                            style:
                                                                                const TextStyle(fontFamily: 'Poppins-regular', color: Color.fromARGB(255, 117, 117, 117)),
                                                                          ),
                                                                          Text(
                                                                            formatCurrency(cartItem['product']['price'].toString()),
                                                                            style:
                                                                                TextStyle(fontFamily: 'Poppins-rgular'),
                                                                          ),
                                                                          Row(
                                                                            children: [
                                                                              Container(
                                                                                height: 30,
                                                                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Color.fromARGB(255, 247, 246, 246)),
                                                                                child: Padding(
                                                                                  padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 4),
                                                                                  child: Text(
                                                                                    cartItem['size'] == 'Large' ? 'L' : 'R',
                                                                                    style: TextStyle(fontFamily: 'Poppins-regular'),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              cartItem['ice'] == 'Normal'
                                                                                  ? Padding(
                                                                                      padding: const EdgeInsets.only(left: 4.0),
                                                                                      child: SizedBox(
                                                                                        width: 1,
                                                                                      ),
                                                                                    )
                                                                                  : Padding(
                                                                                      padding: const EdgeInsets.only(left: 4.0),
                                                                                      child: Container(
                                                                                        height: 30,
                                                                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Color.fromARGB(255, 247, 246, 246)),
                                                                                        child: Padding(
                                                                                          padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 4),
                                                                                          child: Text(
                                                                                            'ice : ${cartItem['ice']}',
                                                                                            style: TextStyle(fontFamily: 'Poppins-regular'),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                              cartItem['sugar'] == 'Normal'
                                                                                  ? Padding(
                                                                                      padding: const EdgeInsets.only(left: 4.0),
                                                                                      child: SizedBox(
                                                                                        width: 1,
                                                                                      ),
                                                                                    )
                                                                                  : Padding(
                                                                                      padding: const EdgeInsets.only(left: 4.0),
                                                                                      child: Container(
                                                                                        height: 30,
                                                                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Color.fromARGB(255, 247, 246, 246)),
                                                                                        child: Padding(
                                                                                          padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 4),
                                                                                          child: Text(
                                                                                            'sugar : ${cartItem['sugar']}',
                                                                                            style: TextStyle(fontFamily: 'Poppins-regular'),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                            ],
                                                                          ),
                                                                          StarRatingWidget(onRatingSelected:
                                                                              (rate) {
                                                                            final productmap =
                                                                                ProductModel.fromMap(cartItem['product'], cartItem['product']['id']);
                                                                            product.updateProductRating(productmap,
                                                                                rate);
                                                                          })
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
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
                                            formatCurrency(
                                                historyItem.price.toString()),
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
    );
  }
}
