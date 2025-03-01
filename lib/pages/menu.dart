import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:takopedia/model/product_model.dart';
import 'package:takopedia/pages/product_detail.dart';
import 'package:takopedia/services/product_provider.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final _locationContrller = TextEditingController();
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
    _loadDeliveryOption();
  }

  // Load the saved delivery option
  Future<void> _loadDeliveryOption() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isTakeAway = prefs.getBool('isTakeAway') ?? true;
    });
  }

  // Save the delivery option
  Future<void> _saveDeliveryOption(bool istake) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isTakeAway', istake);
    setState(() {
      isTakeAway = istake;
    });
  }

  @override
  Widget build(BuildContext context) {
    var products = Provider.of<ProductProvider>(context).product;
    // final isTakeAway =
    return Container(
      decoration:
          const BoxDecoration(color: Color.fromARGB(255, 255, 251, 251)),
      child: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 40,
                ),
                AnimatedToggleSwitch<bool>.size(
                  current: isTakeAway,
                  values: const [true, false],
                  animationDuration: Duration(milliseconds: 400),
                  iconOpacity: 0.2,
                  indicatorSize: const Size.fromWidth(170),
                  customIconBuilder: (context, local, global) => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(local.value ? 'Take Away' : 'Delivery',
                          style: TextStyle(
                              fontSize: 13,
                              fontFamily: 'Poppins-regular',
                              color: Color.lerp(Colors.black, Colors.white,
                                  local.animationValue))),
                      const SizedBox(
                        width: 10,
                      ),
                      Icon(
                        local.value
                            ? Icons.directions_walk
                            : Icons.local_shipping_rounded,
                        color: Color.lerp(
                            Colors.black, Colors.white, local.animationValue),
                      ),
                    ],
                  ),
                  borderWidth: 0.3,
                  iconAnimationType: AnimationType.onHover,
                  style: ToggleStyle(
                    backgroundColor: Color.fromARGB(255, 255, 251, 251),
                    indicatorColor: const Color.fromARGB(255, 252, 79, 79),
                    borderColor: Color.fromARGB(255, 214, 214, 214),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  selectedIconScale: 1.1,
                  onChanged: (b) {
                    setState(() {
                      isTakeAway = b;
                    });
                    _saveDeliveryOption(b);
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                isTakeAway
                    ? const SizedBox(
                        height: 10,
                      )
                    : Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: SizedBox(
                          width: 336,
                          height: 40,
                          child: TextField(
                            controller: _locationContrller,
                            decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.location_pin),
                                contentPadding:
                                    const EdgeInsets.fromLTRB(0, 8, 8, 8),
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.8),
                                hintText: 'Location',
                                hintStyle: const TextStyle(
                                    fontFamily: 'Poppins-Bold', fontSize: 14),
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color:
                                          Color.fromARGB(255, 179, 178, 178)),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: const BorderSide(
                                    color: Color.fromARGB(255, 136, 136, 136),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: const BorderSide(
                                    color: Color.fromARGB(255, 185, 185, 185),
                                  ),
                                )),
                          ),
                        ),
                      ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                  child: Container(
                    width: 336,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: const Color.fromARGB(255, 199, 199, 199),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 8),
                          child: Row(
                            children: [
                              Icon(Icons.store),
                              Padding(
                                padding: EdgeInsets.only(left: 16.0),
                                child: Text(
                                  'GLORIA',
                                  style: TextStyle(fontFamily: 'Poppins-bold'),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 8.0),
                          child: Text(
                            'Ubah',
                            style: TextStyle(
                                color: Color.fromARGB(255, 151, 151, 151)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                GroupedListView(
                  // physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  // floatingHeader: true,
                  // useStickyGroupSeparators: true,
                  elements: products,
                  groupBy: (e) => e.type,
                  footer: const Padding(
                    padding: EdgeInsets.fromLTRB(8.0, 16, 8, 8),
                    child: Center(
                      child: Text(
                        'Sampai sini aja...',
                        style: TextStyle(
                            fontFamily: 'Poppins-Bold',
                            fontSize: 17,
                            color: Color.fromARGB(255, 207, 104, 104)),
                      ),
                    ),
                  ),
                  groupSeparatorBuilder: (String val) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          val,
                          style: const TextStyle(
                              fontFamily: 'Poppins-regular', fontSize: 22),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Divider(
                          indent: 10,
                          endIndent: MediaQuery.sizeOf(context).width - 70,
                        ),
                      ),
                    ],
                  ),
                  itemBuilder: (context, ProductModel product) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ProductDetailPage(product: product)));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Card(
                          elevation: 0.3,
                          child: Container(
                            height: 100,
                            decoration:
                                const BoxDecoration(color: Colors.white),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Display item image
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      bottomLeft: Radius.circular(10)),
                                  child: AspectRatio(
                                    aspectRatio: 1,
                                    child: Image.network(
                                      product.picURL,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      // Adjust the height as needed
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            product.name,
                                            maxLines: 2,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Poppins-regular',
                                            ),
                                          ),
                                          Text(
                                            formatCurrency(
                                                product.price.toString()),
                                            style: const TextStyle(
                                                color: Color.fromARGB(
                                                    255, 114, 114, 114)),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 40,
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.star_rounded,
                                              size: 30,
                                              color: Color.fromARGB(
                                                  255, 253, 235, 72),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0),
                                              child: Text(
                                                '${product.rate.toStringAsFixed(product.rate.truncateToDouble() == product.rate ? 0 : 1)} /5',
                                                style: const TextStyle(
                                                  fontFamily: 'Poppins-regular',
                                                  fontSize: 14,
                                                  color: Color.fromARGB(
                                                      255, 165, 165, 165),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
