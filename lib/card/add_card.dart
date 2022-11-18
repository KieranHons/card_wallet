import 'dart:io';

import 'package:card_wallet/camera.dart';
import 'package:card_wallet/camera/model.dart';
import 'package:card_wallet/model/card_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:path_provider/path_provider.dart';

class AddCard extends StatefulWidget {
  const AddCard({super.key});

  @override
  State<AddCard> createState() => _AddCard();
}

class _AddCard extends State<AddCard> {
  final textController = TextEditingController();
  final codeController = TextEditingController();
  String _cardTitle = '';
  String _cardCode = '';
  File? _imageFile;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void initState() {
    super.initState();
    textController.addListener(_addTitle);
    codeController.addListener(_addCode);
  }

  void _addTitle() {
    setState(() {
      _cardTitle = textController.text;
    });
  }

  void _addCode() {
    setState(() {
      _cardCode = codeController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context);
    var size = media.size;
    double width = media.orientation == Orientation.portrait
        ? size.shortestSide * .9
        : size.longestSide * .5;
    double height = width / CardOverlay.byFormat(OverlayFormat.cardID3).ratio;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Card'),
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
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: TextField(
                    controller: textController,
                    decoration: const InputDecoration(
                      labelText: 'Name of card',
                      border: OutlineInputBorder(),
                      hintText: 'Enter a name for this card',
                    ),
                  ),
                ),
                TextButton(
                  style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.blue)
                  ),
                  onPressed: () async {
                    String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
                        "#FF0000",
                        "Cancel",
                        false,
                        ScanMode.BARCODE);
                    codeController.text = barcodeScanRes == "-1" ? "" : barcodeScanRes;
                  },
                  child: const Text('Scan barcode'),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: TextField(
                    controller: codeController,
                    decoration: const InputDecoration(
                      labelText: 'Code on card',
                      border: OutlineInputBorder(),
                      hintText: 'Enter a code or scan',
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Camera(title: _cardTitle)),
                    ).then((res) => {
                      _addImage(res)
                    });
                  },
                  child: _imageFile == null
                      ? Container(
                    width: width,
                    height: height,
                    margin: const EdgeInsets.only(top: 20),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(0.064*height),
                        image: const DecorationImage(
                            image: AssetImage('images/no_image.jpeg'),
                            fit: BoxFit.fitHeight)
                    ),
                  )
                      : ClipRRect(
                      borderRadius: BorderRadius.circular(0.064*height),
                      child: Image.file(
                        _imageFile!,
                        width: width,
                        height: height,
                        fit: BoxFit.fill,
                      ),
                  ),
                ),
                TextButton(
                  style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.yellow)
                  ),
                  onPressed: () async {
                    if (_cardTitle != '') {
                      String img = 'images/no_image.jpeg';
                      if (_imageFile != null) {
                        final String path = (await getApplicationDocumentsDirectory()).path;
                        img = '$path/$_cardTitle.jpg';
                        await _imageFile!.copy(img);
                      }
                      CardModel cardModel = CardModel(_cardTitle, img, _cardCode);
                      Navigator.pop(context, cardModel);
                    } else {
                      print('no');
                    }
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _addImage(res) async {
      ImageProperties properties =
      await FlutterNativeImage.getImageProperties(res["file"].path);
      int width = (properties.width! * 0.9).round();
      int height = (width / (CardOverlay.byFormat(OverlayFormat.cardID3).ratio + 0.3)).round();
      var offset = ((properties.height! / 2) - (height / 2)).round();

      File croppedFile = await FlutterNativeImage.cropImage(
          res["file"].path,
          (properties.width! * 0.05).round(),
          offset,
          width,
          height);
      setState(() {
      _imageFile = croppedFile;
      });
  }

  @override
  void dispose() {
    textController.dispose();
    codeController.dispose();
    super.dispose();
  }
}