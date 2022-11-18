import 'package:camera/camera.dart';
import 'package:card_wallet/camera/flutter_camera_overlay.dart';
import 'package:card_wallet/camera/model.dart';
import 'package:flutter/material.dart';

class Camera extends StatefulWidget {
  const Camera({Key? key, this.title}) : super(key: key);
  final String? title;

  @override
  State<Camera> createState() => _Camera();
}

class _Camera extends State<Camera> {
  OverlayFormat format = OverlayFormat.cardID3;
  int tab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // bottomNavigationBar: BottomNavigationBar(
      //   currentIndex: tab,
      //   onTap: (value) {
      //     setState(() {
      //       tab = value;
      //     });
      //     switch (value) {
      //       case (0):
      //         setState(() {
      //           format = OverlayFormat.cardID1;
      //         });
      //         break;
      //       case (1):
      //         setState(() {
      //           format = OverlayFormat.cardID3;
      //         });
      //         break;
      //       case (2):
      //         setState(() {
      //           format = OverlayFormat.simID000;
      //         });
      //         break;
      //     }
      //   },
      //   items: const [
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.credit_card),
      //       label: 'Bankcard',
      //     ),
      //     BottomNavigationBarItem(
      //         icon: Icon(Icons.contact_mail), label: 'US ID'),
      //     BottomNavigationBarItem(icon: Icon(Icons.sim_card), label: 'Sim'),
      //   ],
      // ),
      backgroundColor: Colors.white,
      body: FutureBuilder<List<CameraDescription>?>(
        future: availableCameras(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data == null) {
              return const Align(
                  alignment: Alignment.center,
                  child: Text(
                    'No camera found',
                    style: TextStyle(color: Colors.black),
                  ));
            }
            return CameraOverlay(
                snapshot.data!.first,
                CardOverlay.byFormat(format),
                    (XFile file) => Navigator.pop(context, {"title": widget.title, "file": file}),
                info:
                'Position your card within the rectangle and ensure the image is perfectly readable.',
                label: 'Scanning Card');
          } else {
            return const Align(
                alignment: Alignment.center,
                child: Text(
                  'Fetching cameras',
                  style: TextStyle(color: Colors.black),
                ));
          }
        },
      ),
    );
  }
}