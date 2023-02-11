import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:web_scrapping/kitap.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var url = Uri.parse(
      'https://www.kitapyurdu.com/kategori/kitap-cocuk-kitaplari/1_2.html');
  var data;

  List<Kitap> kitaplar = [];

  bool isLoading = false;

  Future getData() async {
    setState(() {
      isLoading = true;
    });
    var res = await http.get(url);
    final body = res.body;
    final document = parser.parse(body);

    /*
    resim:(element.children[2].children[0].children[0].children[0].attributes['src'].toString());
    kitaplar:(element.children[3].text.toString());
    yayınevi:(element.children[4].text.toString());
    yazar:(element.children[5].text.toString());
    fiyat:(element.children[6].text.toString());
    
    */

    var response = document
        .getElementsByClassName('product-grid')[0]
        .getElementsByClassName('product-cr')
        .forEach((element) {
      debugPrint(element.children[7].children[1].text.toString());
      setState(() {
        kitaplar.add(
          Kitap(
            image: element.children[2].children[0].children[0].children[0]
                .attributes['src']
                .toString(),
            kitapAdi: (element.children[3].text.toString()),
            yayinEvi: (element.children[4].text.toString()),
            yazari: (element.children[5].children[0].text.toString()),
            fiyati:
                (element.children[7].children[1].children[1].text.toString()),
          ),
        );
      });
      ;
    });

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();

    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Web Scrapping ')),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.55,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: kitaplar.length,
                  itemBuilder: (context, index) => Card(
                        elevation: 10,
                        color: Colors.black26,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Stack(
                                  children: [
                                    ClipRect(
                                      child:
                                          Image.network(kitaplar[index].image),
                                    ),
                                    Align(
                                      alignment: Alignment.topCenter,
                                      child: Text(
                                        index.toString(),
                                        style: const TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 22),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'Kitap Adi:${kitaplar[index].kitapAdi}',
                                  style: _textStyle,
                                ),
                                Text(
                                  'Kitap Yayin Evi:${kitaplar[index].yayinEvi}',
                                  style: _textStyle,
                                ),
                                Text(
                                  'Kitap Yazari:${kitaplar[index].yazari}',
                                  style: _textStyle,
                                ),
                                Text(
                                  'Kitap Fiyati:${kitaplar[index].fiyati}',
                                  style: _textStyle,
                                ),
                              ]),
                        ),
                      )),

              /* Center(
          child: Column(
            children: [
              Expanded(child: Text(data.toString())),
              ElevatedButton(
                  onPressed: () => getData(),
                  child: const Text('Datalari Getir'))
            ],
          ),
        ), */
            ),
    );
  }

  final TextStyle _textStyle =
      const TextStyle(color: Colors.white, fontSize: 15);
}
