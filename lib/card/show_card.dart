import 'package:barcode_widget/barcode_widget.dart';
import 'package:card_wallet/model/card_model.dart';
import 'package:flutter/material.dart';

class ShowCard extends StatefulWidget {
  const ShowCard({super.key, this.card});
  final CardModel? card;

  @override
  State<ShowCard> createState() => _ShowCard();
}

class _ShowCard extends State<ShowCard> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context);
    var size = media.size;
    double width = media.orientation == Orientation.portrait
        ? size.shortestSide * .9
        : size.longestSide * .5;
    double height = width / 1.59;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.card!.title!),
        actions: <Widget>[
          Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () async {
                  Navigator.pop(context, widget.card);
                },
                child: const Icon(
                  Icons.delete,
                  size: 26.0,
                ),
              )
          ),
        ],
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back, size: 26,)
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(height: 20),
                ClipRRect(
                  borderRadius: BorderRadius.circular(0.064*height),
                  child: Container(
                    height: height,
                    width: width,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(0.064*height),
                        image: DecorationImage(
                            image: AssetImage(widget.card!.image!),
                            fit: BoxFit.fill)
                    ),
                  ),
                ),
                Container(height: 20),
                BarcodeWidget(
                  height: height/2,
                  width: width,
                  barcode: Barcode.code128(),
                  data: widget.card!.barcode!,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}