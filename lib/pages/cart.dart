import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
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
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.sizeOf(context).height,
            decoration:
                const BoxDecoration(color: Color.fromARGB(255, 246, 249, 255)),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(6),
                                    bottomLeft: Radius.circular(6)),
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
                                  child: Image.asset(
                                    'assets/img/excee-carousel.jpg',
                                    height: 120,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 3.0, top: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  SizedBox(
                                    width:
                                        MediaQuery.sizeOf(context).width - 170,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Air Max Excee Green Olive',
                                          style: TextStyle(
                                              fontFamily: 'Poppins-regular',
                                              color: Color.fromARGB(
                                                  255, 117, 117, 117)),
                                        ),
                                        Text(
                                          'Rp. 1.599.000,00',
                                          style: TextStyle(),
                                        ),
                                        Container(
                                          height: 30,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: const Color.fromARGB(
                                                  255, 241, 241, 241)),
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                left: 8.0, right: 8.0, top: 4),
                                            child: Text(
                                              'Ukuran : 41',
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
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: Container(
                                      height: 30,
                                      width: 100,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: const Color.fromARGB(
                                                  255, 158, 158, 158)),
                                          borderRadius:
                                              BorderRadius.circular(40),
                                          color: const Color.fromARGB(
                                              255, 247, 247, 247)),
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            left: 8.0, right: 8),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            GestureDetector(
                                              onTap: () {},
                                              child: const Text(
                                                '-',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20),
                                              ),
                                            ),
                                            Text(
                                              '1',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            GestureDetector(
                                              onTap: () {},
                                              child: const Text(
                                                '+',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w400,
                                                    color: Color.fromARGB(
                                                        255, 51, 51, 51)),
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
