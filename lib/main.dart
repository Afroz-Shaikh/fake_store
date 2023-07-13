import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geekyants_flutter_gauges/geekyants_flutter_gauges.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:neopop/widgets/buttons/neopop_tilted_button/neopop_tilted_button.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DFC Session 2',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: GoogleFonts.pressStart2p().fontFamily,
        primarySwatch: Colors.blue,
      ),
      home: const StartPage(),
    );
  }
}

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              'Hello World',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 40,
                fontFamily: GoogleFonts.pressStart2p().fontFamily,
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          NeoPopTiltedButton(
            isFloating: true,
            onTapUp: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoaderPage(),
                ),
              );
            },
            decoration: const NeoPopTiltedButtonDecoration(
              color: Color.fromRGBO(255, 235, 52, 1),
              plunkColor: Color.fromRGBO(255, 235, 52, 1),
              shadowColor: Color.fromRGBO(36, 36, 36, 1),
              showShimmer: true,
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 70.0,
                vertical: 15,
              ),
              child: Text('Shop Now'),
            ),
          ),
        ],
      ),
    );
  }
}

class ShoppingPage extends StatefulWidget {
  const ShoppingPage({super.key});

  @override
  State<ShoppingPage> createState() => _ShoppingPageState();
}

class _ShoppingPageState extends State<ShoppingPage> {
  List<Product> products = [];
  List<Product> filteredProducts = [];

  bool isloaded = false;
  bool showSearch = false;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  fetchData() async {
    const String url = 'https://fakestoreapi.com/products';
    final response = await http.get(Uri.parse(url));
    var data = jsonDecode(response.body);
    List<Product> products = [];
    for (var i in data) {
      products.add(Product(
        title: i['title'],
        description: i['description'],
        price: i['price'],
        category: i['category'],
        imageUrl: i['image'],
      ));
    }
    setState(() {
      this.products = products;
      isloaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: !showSearch ? null : const BackButton(),
          title: !showSearch
              ? const Text("SHOP")
              : TextField(
                  onChanged: (value) {
                    setState(() {
                      filteredProducts = products
                          .where((element) => element.title!
                              .toLowerCase()
                              .contains(value.toLowerCase()))
                          .toList();
                    });
                  },
                  decoration: InputDecoration(
                    hintText: "Search",
                    border: InputBorder.none,
                  ),
                ),
          actions: [
            showSearch
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        showSearch = false;
                      });
                    },
                    icon: Icon(Icons.close))
                : IconButton(
                    onPressed: () {
                      setState(() {
                        showSearch = true;
                      });
                    },
                    icon: const Icon(Icons.search),
                  )
          ],
        ),
        body: Visibility(
          visible: isloaded,
          replacement: const Center(
            child: CircularProgressIndicator(),
          ),
          child: showSearch
              ? ListView(
                  children: [
                    for (var i in filteredProducts)
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DescPage(product: i),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            minLeadingWidth: 70,
                            leading: Image.network(i.imageUrl),
                            title: Text(
                              i.title,
                              style: const TextStyle(fontSize: 10),
                            ),
                            subtitle: Text(
                              "\$${i.price}",
                              style: TextStyle(fontSize: 20),
                            ),
                            // trailing: Text(i.category ?? "Item"),
                          ),
                        ),
                      )
                  ],
                )
              : ListView(
                  children: [
                    for (var i in products)
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DescPage(product: i),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            minLeadingWidth: 70,
                            leading: Image.network(i.imageUrl),
                            title: Text(
                              i.title,
                              style: const TextStyle(fontSize: 10),
                            ),
                            subtitle: Text(
                              "\$${i.price}",
                              style: TextStyle(fontSize: 20),
                            ),
                            // trailing: Text(i.category ?? "Item"),
                          ),
                        ),
                      )
                  ],
                ),
        ));
  }
}

class DescPage extends StatelessWidget {
  DescPage({super.key, required this.product});

  Product product = Product();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(product.title ?? "Item"),
      ),
    );
  }
}

class LoaderPage extends StatefulWidget {
  const LoaderPage({super.key});

  @override
  State<LoaderPage> createState() => _LoaderPageState();
}

class _LoaderPageState extends State<LoaderPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 5), () {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const ShoppingPage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: LinearGauge(
            enableGaugeAnimation: true,
            animationGap: 0.9,
            linearGaugeBoxDecoration: LinearGaugeBoxDecoration(
                thickness: 30.0,
                borderRadius: 30,
                linearGaugeValueColor: Colors.green,
                edgeStyle: LinearEdgeStyle.bothCurve,
                backgroundColor: Colors.grey.shade300),
            start: 0,
            end: 100,
            gaugeOrientation: GaugeOrientation.horizontal,
            valueBar: const [
              ValueBar(
                  value: 100,
                  animationDuration: 5000,
                  color: Colors.green,
                  valueBarThickness: 30,
                  borderRadius: 30)
            ],
            pointers: const [
              Pointer(
                  animationDuration: 5000,
                  shape: PointerShape.rectangle,
                  value: 100,
                  color: Colors.yellowAccent,
                  pointerAlignment: PointerAlignment.start,
                  height: 35)
            ],
            rulers: RulerStyle(
              secondaryRulersWidth: 4,
              secondaryRulerPerInterval: 1,
              secondaryRulersHeight: 30,
              secondaryRulerColor: Colors.black,
              showPrimaryRulers: false,
              rulersOffset: 10,
              labelOffset: 10,
              inverseRulers: false,
              rulerPosition: RulerPosition.center,
              showLabel: false,
            ),
          ),
        ),
        const Text("LOADING ...")
      ],
    ));
  }
}

//* Model For Product
class Product {
  final String title;
  final String description;
  final num price;
  final String? category;
  final String imageUrl;

  Product({
    this.title = "",
    this.description = "",
    this.price = 0,
    this.category = "",
    this.imageUrl = "",
  });
}
