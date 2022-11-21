import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hrm_app/screens/appFlow/home/attendeance/attendance.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../utils/nav_utail.dart';


class QRCodeScannerView extends StatefulWidget {
  const QRCodeScannerView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRCodeScannerViewState();
}

class _QRCodeScannerViewState extends State<QRCodeScannerView> with SingleTickerProviderStateMixin{

  String? barcode;

  MobileScannerController controller = MobileScannerController(
    torchEnabled: false,
    // formats: [BarcodeFormat.qrCode]
    // facing: CameraFacing.front,
  );

  bool isStarted = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Builder(
        builder: (context) {
          return Stack(
            children: [
              MobileScanner(
                controller: controller,
                fit: BoxFit.contain,
                // allowDuplicates: true,
                // controller: MobileScannerController(
                //   torchEnabled: true,
                //   facing: CameraFacing.front,
                // ),
                onDetect: (barcode, args) {
                  NavUtil.replaceScreen(context, Attendance(navigationMenu: true,qrData: barcode.rawValue));
                },
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  alignment: Alignment.bottomCenter,
                  height: 100,
                  color: Colors.black.withOpacity(0.4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        color: Colors.white,
                        icon: ValueListenableBuilder(
                          valueListenable: controller.torchState,
                          builder: (context, state, child) {
                            if (state == null) {
                              return const Icon(
                                CupertinoIcons.lightbulb_fill,
                                color: Colors.grey,
                              );
                            }
                            switch (state as TorchState) {
                              case TorchState.off:
                                return const Icon(
                                  CupertinoIcons.lightbulb_slash,
                                  color: Colors.grey,
                                );
                              case TorchState.on:
                                return const Icon(
                                  CupertinoIcons.lightbulb_fill,
                                  color: Colors.yellow,
                                );
                            }
                          },
                        ),
                        iconSize: 32.0,
                        onPressed: () => controller.toggleTorch(),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Opacity(
                  opacity: 0.7,
                  child: Image.asset(
                    "assets/images/face.png",fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}