import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:takopedia/model/cart_model.dart';
import 'package:takopedia/model/sales_model.dart';
import 'package:takopedia/pages/payment.dart';
import 'package:takopedia/services/cart_service.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final CartService _cardService = CartService();
  final _user = FirebaseAuth.instance.currentUser;
  int total = 0;
  String formatCurrency(String price) {
    final formatter = NumberFormat.currency(locale: 'id', symbol: 'Rp ');
    return formatter.format(int.parse(price));
  }

  @override
  void initState() {
    super.initState();
    getTotal();
  }

  void getTotal() async {
    total = await _cardService.getTotal(_user!.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cart',
          style: TextStyle(
            fontFamily: 'Poppins-regular',
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: MediaQuery.sizeOf(context).height - 240,
              decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 246, 249, 255)),
              child: FutureBuilder(
                future: _cardService.fetchSales(_user!.uid),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                        child: Text(
                            'Error: ${snapshot.error}')); // Show error if fetching failed
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text('cart Kosong'),
                    ); // Show error if fetching failed
                  } else {
                    List<CartModel> cartItems = snapshot.data!;

                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ListView.builder(
                        itemCount: cartItems.length,
                        itemBuilder: (context, index) {
                          CartModel cartItem = cartItems[index];

                          return Column(
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(6),
                                      bottomLeft: Radius.circular(6)),
                                ),
                                height: 140,
                                width: MediaQuery.sizeOf(context).width,
                                child: Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ClipRRect(
                                            borderRadius:
                                                const BorderRadius.only(
                                                    topLeft: Radius.circular(6),
                                                    bottomLeft:
                                                        Radius.circular(6)),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                boxShadow: [
                                                  const BoxShadow(
                                                      offset: Offset(0.1, 0.1),
                                                      blurRadius: 1)
                                                ],
                                                border: Border.all(
                                                    color: const Color.fromARGB(
                                                        255, 240, 239, 239)),
                                              ),
                                              child: Image.network(
                                                cartItem.product['picURL'],
                                                height: 120,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 3.0, top: 10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              SizedBox(
                                                width:
                                                    MediaQuery.sizeOf(context)
                                                            .width -
                                                        170,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      cartItem.product['name'],
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'Poppins-regular',
                                                          color: Color.fromARGB(
                                                              255,
                                                              117,
                                                              117,
                                                              117)),
                                                    ),
                                                    Text(
                                                      formatCurrency(cartItem
                                                          .product['price']
                                                          .toString()),
                                                      style: TextStyle(),
                                                    ),
                                                    Container(
                                                      height: 30,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          color: const Color
                                                              .fromARGB(255,
                                                              241, 241, 241)),
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 8.0,
                                                                right: 8.0,
                                                                top: 4),
                                                        child: Text(
                                                          'Ukuran : ${cartItem.size}',
                                                          style: TextStyle(),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 8.0),
                                                child: Container(
                                                  height: 30,
                                                  width: 100,
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: const Color
                                                              .fromARGB(255,
                                                              158, 158, 158)),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              40),
                                                      color:
                                                          const Color.fromARGB(
                                                              255,
                                                              247,
                                                              247,
                                                              247)),
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 8.0, right: 8),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        GestureDetector(
                                                          onTap: () async {
                                                            if (cartItem
                                                                    .quantity >
                                                                1) {
                                                              _cardService
                                                                  .min1Quantity(
                                                                _user.uid,
                                                                cartItem.product[
                                                                    'name'],
                                                              );
                                                              if (mounted) {
                                                                setState(() {});
                                                              }
                                                            } else {
                                                              showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (context) =>
                                                                        AlertDialog(
                                                                  title: Text(
                                                                      'Hapus??'),
                                                                  actions: [
                                                                    TextButton(
                                                                      onPressed:
                                                                          () =>
                                                                              Navigator.of(context).pop(),
                                                                      child: Text(
                                                                          'Cancel'),
                                                                    ),
                                                                    TextButton(
                                                                      onPressed:
                                                                          () async {
                                                                        await _cardService
                                                                            .deleteProductFromCart(
                                                                          _user
                                                                              .uid,
                                                                          cartItem
                                                                              .product['name'],
                                                                        );
                                                                        if (mounted) {
                                                                          setState(
                                                                              () {}); //  buat refresh cart nya (jangan di apus ya anjeng)
                                                                        }

                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                      child: Text(
                                                                          'sure'),
                                                                    ),
                                                                  ],
                                                                ),
                                                              );
                                                            }
                                                          },
                                                          child: Container(
                                                            child: const Icon(
                                                              Icons.remove,
                                                              size: 20,
                                                            ),
                                                          ),
                                                        ),
                                                        Text(
                                                          '${cartItem.quantity}',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                        GestureDetector(
                                                          onTap: () async {
                                                            await _cardService
                                                                .plus1Quantity(
                                                                    _user.uid,
                                                                    cartItem.product[
                                                                        'name']);
                                                            setState(() {});
                                                          },
                                                          child: Container(
                                                            child: const Icon(
                                                              Icons.add,
                                                              size: 20,
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
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
                              Divider(
                                thickness: 0.4,
                                height: 4,
                              ),
                            ],
                          );
                        },
                      ),
                    );
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Total : $total',
                style: TextStyle(fontFamily: 'Poppins-regular', fontSize: 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 13.0,
                left: 8,
                bottom: 8,
                right: 8,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () => _showDeliveryOption(context),
                    style: ButtonStyle(
                      side: const MaterialStatePropertyAll(BorderSide(
                        color: Color.fromARGB(255, 255, 255, 255),
                      )),
                      shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(17))),
                      fixedSize: MaterialStateProperty.all(const Size(52, 52)),
                      padding: MaterialStateProperty.all(
                          const EdgeInsets.fromLTRB(0, 0, 0, 0)),
                      backgroundColor: MaterialStateProperty.all(
                          Color.fromARGB(255, 54, 199, 90)),
                      elevation: MaterialStateProperty.all(1),
                    ),
                    child: const Icon(
                      Icons.local_shipping_outlined,
                      color: Color.fromARGB(255, 250, 253, 255),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const PaymentPage())),
                    style: ButtonStyle(
                      side: const MaterialStatePropertyAll(BorderSide(
                          color: Color.fromARGB(255, 216, 38, 38), width: 2)),
                      shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(17))),
                      fixedSize: MaterialStateProperty.all(const Size(290, 52)),
                      padding: MaterialStateProperty.all(
                          const EdgeInsets.fromLTRB(0, 0, 0, 0)),
                      backgroundColor: MaterialStateProperty.all(
                          Color.fromARGB(255, 255, 245, 245)),
                      elevation: MaterialStateProperty.all(3),
                    ),
                    child: const Text(
                      'Check Out',
                      style: TextStyle(
                          color: Color.fromARGB(255, 216, 38, 38),
                          fontFamily: 'Poppins-Bold'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeliveryOption(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allows the modal to expand if necessary
      builder: (context) {
        // Use StatefulBuilder to have access to setState inside the modal
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter modalSetState) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: const Color.fromARGB(255, 252, 254, 255),
              ),
              height: 300, // Set a fixed height for the bottom sheet
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: const Text(
                      'Delivery Option',
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'Poppins',
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  const Divider(height: 0.3),
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Jangan Telat yaa  <3'),
                            backgroundColor:
                                const Color.fromARGB(255, 55, 129, 58),
                            duration: Duration(seconds: 1),
                          ));
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Text(
                            'Ambil Sendiri Jangan Malas',
                            style: TextStyle(
                              fontFamily: 'Poppins-regular',
                              fontSize: 20,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ),
                      Divider(
                        thickness: 0.5,
                      ),
                      GestureDetector(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Makasih Banyak <3'),
                            backgroundColor:
                                const Color.fromARGB(255, 55, 129, 58),
                            duration: Duration(seconds: 1),
                          ));
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Text(
                            'Kasih Ke Admin <3',
                            style: TextStyle(
                              fontFamily: 'Poppins-regular',
                              fontSize: 20,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ),
                      Divider(
                        thickness: 0.5,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
