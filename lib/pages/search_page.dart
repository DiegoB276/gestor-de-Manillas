import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:parque_tematico/models/data_base.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../widgets/my_drawer.dart';
import '../widgets/my_snackbar.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final codeController = TextEditingController();
  late dynamic answer = 0;

  //QR variables
  bool statusQRButton = false;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String? result;
  bool buttonSearchPressed = false;

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData.code;
        codeController.text = result.toString();
        statusQRButton = false;
      });
    });
  }

  void validateCamps(BuildContext context) {
    if (codeController.text.isEmpty) {
      Exception exception = Exception("Hay Campos Vacíos");
      Future.delayed(const Duration(seconds: 1)).then((value) {
        launchSnackBar(context, exception.toString(), Colors.pink);
      });

      codeController.clear();
    }
  }

  Future<void> changeValueAnswer(int id) async {
    DataHelper? dataHelper = DataHelper();
    dynamic resultData = await dataHelper.searchPriceBracelet(id);
    setState(() {
      answer = resultData;
    });
  }

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void changeStatusQRButton() {
    setState(() {
      statusQRButton = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Consultar Saldo",
          style: GoogleFonts.acme(fontSize: 25),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(75, 192, 150, 1),
      ),
      drawer: const MyDrawer(),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 20, left: 10, right: 10, bottom: 20),
              child: Column(
                children: [
                  Text(
                    "Datos Solicitados",
                    style: GoogleFonts.acme(fontSize: 30),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Column(
                    children: [
                      Text(
                        "Código de Manilla",
                        style: GoogleFonts.acme(fontSize: 20),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: changeStatusQRButton,
                            child: Container(
                              decoration: BoxDecoration(
                                border: const Border(
                                  bottom: BorderSide(color: Colors.black),
                                  top: BorderSide(color: Colors.black),
                                  right: BorderSide(color: Colors.black),
                                  left: BorderSide(color: Colors.black),
                                ),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(5),
                                child: Icon(
                                  Icons.qr_code,
                                  size: 30,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          SizedBox(
                            width: 250,
                            child: TextField(
                              keyboardType: TextInputType.number,
                              controller: codeController,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Color.fromRGBO(135, 158, 237, 1),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Color.fromRGBO(135, 158, 237, 1),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  statusQRButton
                      ? Column(
                          children: [
                            SizedBox(
                              height: 300,
                              width: 320,
                              child: QRView(
                                key: qrKey,
                                onQRViewCreated: _onQRViewCreated,
                                overlay: QrScannerOverlayShape(
                                  borderColor: Colors.green,
                                  borderLength: 20,
                                  borderWidth: 7,
                                  borderRadius: 15,
                                  overlayColor: Colors.black54,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            MaterialButton(
                              elevation: 10,
                              height: 55,
                              minWidth: 160,
                              onPressed: () {
                                setState(() {
                                  statusQRButton = false;
                                  if (result == null) {
                                    codeController.text = "";
                                  } else
                                    () =>
                                        codeController.text = result.toString();
                                });
                              },
                              color: Color.fromARGB(255, 168, 167, 167),
                              child: Text(
                                "Cerrar",
                                style: GoogleFonts.acme(
                                    fontSize: 20, color: Colors.white),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        )
                      : const SizedBox(
                          height: 10,
                        ),

                  //Buttons
                  const SizedBox(height: 70),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MaterialButton(
                        elevation: 10,
                        height: 55,
                        minWidth: 150,
                        onPressed: () async {
                          final conectivity =
                              await (Connectivity().checkConnectivity());
                          try {
                            if (conectivity == ConnectivityResult.wifi) {
                              try {
                                validateCamps(context);
                                changeValueAnswer(
                                    int.parse(codeController.text));
                              } catch (e) {
                                e.toString();
                              }
                            } else if (conectivity ==
                                ConnectivityResult.mobile) {
                              try {
                                validateCamps(context);
                                changeValueAnswer(
                                  int.parse(codeController.text),
                                );

                                Future.delayed(const Duration(seconds: 1)).then(
                                  (value) {
                                    launchSnackBar(
                                      context,
                                      "Para más certeza usa \nla conexión WIFI",
                                      Colors.lightBlue,
                                    );
                                  },
                                );
                              } catch (e) {
                                e.toString();
                              }
                            } else {
                              Future.delayed(const Duration(seconds: 1)).then(
                                (value) {
                                  launchSnackBar(
                                    context,
                                    "Sin conexion a Internet",
                                    Colors.pink,
                                  );
                                },
                              );
                              codeController.clear();
                            }
                          } catch (exception) {
                            exception.toString();
                            setState(() {
                              answer = 0;
                            });
                          }
                        },
                        color: Colors.black,
                        child: Text(
                          "Consultar",
                          style: GoogleFonts.acme(
                              fontSize: 20, color: Colors.white),
                        ),
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                      MaterialButton(
                        elevation: 10,
                        height: 55,
                        minWidth: 150,
                        onPressed: () {
                          print(answer);
                          codeController.clear();
                          setState(() {
                            answer = 0;
                          });
                        },
                        color: const Color.fromRGBO(49, 184, 135, 1),
                        child: Text(
                          "Cancelar",
                          style: GoogleFonts.acme(
                              fontSize: 20, color: Colors.white),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    height: 200,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Saldo Disponible",
                            style: GoogleFonts.acme(fontSize: 20),
                          ),
                          const SizedBox(height: 5),
                          Container(
                            width: 200,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 212, 219, 217),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: (answer != 0 || answer != null)
                                  ? Text(
                                      "\$$answer",
                                      style: TextStyle(fontSize: 30),
                                    )
                                  : Text(
                                      "\$0",
                                      style: TextStyle(fontSize: 30),
                                    ),
                            ),
                          )
                        ],
                      ),
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
