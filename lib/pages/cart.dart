import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:takopedia/model/cart_model.dart';
import 'package:takopedia/pages/payment.dart';
import 'package:takopedia/services/cart_provider.dart';
import 'package:takopedia/services/cart_service.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final CartService _cardService = CartService();
  final _user = FirebaseAuth.instance.currentUser;
  bool isEmpty = false;
  int total = 0;
  String formatCurrency(String price) {
    final formatter = NumberFormat.currency(locale: 'id', symbol: 'Rp ');
    return formatter.format(int.parse(price));
  }

  @override
  void initState() {
    super.initState();
  }

  void getTotal() async {
    total = await _cardService.getTotal(_user!.uid);
  }

  @override
  Widget build(BuildContext context) {
    final cartItems = Provider.of<CartProvider>(context).cartItems;
    // final cartItems = cartProvider.cartItems;
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(
              Icons.arrow_back_ios_new_outlined,
              size: 17,
            )),
        elevation: 1,
        surfaceTintColor: const Color.fromARGB(255, 202, 202, 202),
        shadowColor: Color.fromARGB(255, 223, 223, 223),
        title: Center(
          child: const Text(
            'Cart',
            style: TextStyle(
              color: Color.fromARGB(255, 255, 79, 79),
              fontFamily: 'Poppins-Bold',
              fontSize: 16,
            ),
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(
              Icons.list,
              size: 30,
            ),
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              cartItems.isEmpty
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: 80.0),
                            child: Text(
                              'Cart kosong, belanja dulu yuk..',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 155, 155, 155),
                                  fontFamily: 'Poppins-regular',
                                  fontSize: 20),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 80.0, 8, 8),
                          child: ElevatedButton(
                            onPressed: () =>
                                Navigator.pushReplacementNamed(context, '/'),
                            style: ButtonStyle(
                              shape: MaterialStatePropertyAll(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25))),
                              fixedSize: MaterialStateProperty.all(
                                  const Size(290, 52)),
                              padding: MaterialStateProperty.all(
                                  const EdgeInsets.fromLTRB(0, 0, 0, 0)),
                              backgroundColor: MaterialStateProperty.all(
                                  Color.fromARGB(255, 247, 108, 108)),
                              elevation: MaterialStateProperty.all(3),
                            ),
                            child: const Text(
                              'Mari...',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 255, 246, 246),
                                  fontFamily: 'Poppins-Bold'),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
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
                                                BorderRadius.circular(100),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                boxShadow: const [
                                                  BoxShadow(
                                                      offset: Offset(0.1, 0.1),
                                                      blurRadius: 1)
                                                ],
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
                                                                _user!.uid,
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
                                                                            .deleteProductFromCart(cartItem.id);
                                                                        if (mounted) {
                                                                          setState(
                                                                              () {
                                                                            getTotal();
                                                                          }); //  buat refresh cart nya (jangan di apus ya anjeng)
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
                                                                    _user!.uid,
                                                                    cartItem.product[
                                                                        'name']);
                                                            if (mounted) {
                                                              setState(() {
                                                                getTotal();
                                                              });
                                                            }
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
                    ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 250, 250),
                    border: Border(),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomSheet: isEmpty
          ? SizedBox()
          : BottomSheet(
              elevation: 1,
              enableDrag: false,
              shadowColor: Colors.black12,
              shape: Border.all(
                  width: 0, color: Color.fromARGB(255, 255, 254, 254)),
              backgroundColor: Color.fromARGB(255, 255, 251, 251),
              builder: (BuildContext context) {
                return Padding(
                  padding: const EdgeInsets.only(
                    top: 13.0,
                    left: 8,
                    bottom: 8,
                    right: 8,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const PaymentPage())),
                        style: ButtonStyle(
                          shape: MaterialStatePropertyAll(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25))),
                          fixedSize:
                              MaterialStateProperty.all(const Size(290, 52)),
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.fromLTRB(0, 0, 0, 0)),
                          backgroundColor: MaterialStateProperty.all(
                              Color.fromARGB(255, 247, 108, 108)),
                          elevation: MaterialStateProperty.all(3),
                        ),
                        child: const Text(
                          'Check Out',
                          style: TextStyle(
                              color: Color.fromARGB(255, 255, 246, 246),
                              fontFamily: 'Poppins-Bold'),
                        ),
                      ),
                    ],
                  ),
                );
              },
              onClosing: () {},
            ),
    );
  }
}
