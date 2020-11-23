//import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scraping_app/tag.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isDataLoading = true;
  List<String> quotes = List();
  List<String> authors = List();

  List<String> categoryList = [
    'Love',
    'Inspiration',
    'Live',
    'Humor',
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() async {
    var url = 'https://quotes.toscrape.com/';
    var response = await http.get(url);
    dom.Document document = parser.parse(response.body);
    final mainClass = document.getElementsByClassName('quote');

    setState(() {
      quotes = mainClass
          .map((element) => element.getElementsByClassName('text')[0].innerHtml)
          .toList();
      authors = mainClass
          .map((element) =>
              element.getElementsByClassName('author')[0].innerHtml)
          .toList();
      isDataLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 30.0),
              child: Text(
                'Quotes App',
                style: GoogleFonts.montserrat(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              children: categoryList.map((categoryName) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TagPage(
                          name: categoryName,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.pink,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Center(
                      child: Text(
                        categoryName.toUpperCase(),
                        style: GoogleFonts.montserrat(
                          fontSize: 20.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(
              height: 20.0,
            ),
            Text(
              'General',
              style: GoogleFonts.montserrat(
                fontSize: 20.0,
                color: Colors.black,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Container(
              child: isDataLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : SingleChildScrollView(
                      physics: ScrollPhysics(),
                      child: Column(
                        children: <Widget>[
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: quotes.length,
                            itemBuilder: (context, index) {
                              return Container(
                                padding: EdgeInsets.all(10.0),
                                child: Card(
                                  elevation: 10.0,
                                  child: Column(
                                    children: <Widget>[
                                      ///Text
                                      Container(
                                        margin: EdgeInsets.only(
                                          left: 20.0,
                                          top: 20.0,
                                          right: 10.0,
                                          bottom: 10.0,
                                        ),
                                        child: Text(
                                          quotes[index],
                                          style: GoogleFonts.montserrat(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),

                                      ///Author
                                      Container(
                                        margin: EdgeInsets.only(
                                          bottom: 15.0,
                                        ),
                                        child: Text(
                                          authors[index],
                                          style: GoogleFonts.montserrat(
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.pink,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          )
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
