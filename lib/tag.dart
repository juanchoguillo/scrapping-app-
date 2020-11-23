import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;

class TagPage extends StatefulWidget {
  final String name;
  TagPage({this.name});
  @override
  _TagPageState createState() => _TagPageState();
}

class _TagPageState extends State<TagPage> {
  bool isDataLoading = true;
  List<String> quotes = List();
  List<String> authors = List();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() async {
    print('Getting data');
//    var url = 'https://quotes.toscrape.com/tag/${widget.name}';
    var url = 'https://quotes.toscrape.com/tag/${widget.name.toLowerCase()}/';
    var response = await http.get(url);
    dom.Document document = parser.parse(response.body);

    final mainClass = document.getElementsByClassName('quote');
    setState(() {
      isDataLoading = false;

      quotes = mainClass
          .map((element) => element.getElementsByClassName('text')[0].innerHtml)
          .toList();

      authors = mainClass
          .map((element) =>
              element.getElementsByClassName('author')[0].innerHtml)
          .toList();
    });

    print(url);
    print(mainClass[0].getElementsByClassName('tag')[1].innerHtml);
    print('--------------------');
    print(mainClass[0].innerHtml); // to see the info
    print(mainClass[0].getElementsByClassName('text')[0].innerHtml);
    print(mainClass[0].getElementsByClassName('author')[0].innerHtml);
    print('--------------------');
    print(quotes);
    print(authors);
    print(mainClass);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: isDataLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              physics: ScrollPhysics(),
              child: Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(top: 30.0),
                    child: Text(
                      '${widget.name} quotes',
                      style: GoogleFonts.montserrat(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
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
                              Container(
                                margin: EdgeInsets.only(
                                    top: 10.0,
                                    left: 20.0,
                                    bottom: 20.0,
                                    right: 10.0),
                                child: Text(
                                  quotes[index],
                                  style: GoogleFonts.montserrat(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(bottom: 15.0),
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
    );
  }
}
