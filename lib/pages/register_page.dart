import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:parque_tematico/models/data_base.dart';
import 'package:parque_tematico/widgets/my_drawer.dart';
import 'package:parque_tematico/widgets/my_snackbar.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({
    super.key,
  });

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final userController = TextEditingController();
  final codeController = TextEditingController();
  final typeController = TextEditingController();
  final priceController = TextEditingController();
  bool statusQRButton = false;

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String? result;

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
    if (codeController.text.isEmpty ||
        userController.text.isEmpty ||
        typeController.text.isEmpty ||
        priceController.text.isEmpty) {
      Exception exception = Exception("Hay Campos Vacíos");
      Future.delayed(const Duration(seconds: 1)).then(
        (value) {
          launchSnackBar(context, exception.toString(), Colors.pink);
        },
      );
      userController.clear();
      codeController.clear();
      typeController.clear();
      priceController.clear();
    }
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
          "Registrar Manilla",
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
                  top: 20, left: 20, right: 20, bottom: 10),
              child: Column(
                children: [
                  Text(
                    "Datos de Registro",
                    style: GoogleFonts.acme(fontSize: 30),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Nombre de Usuario",
                        style: GoogleFonts.acme(fontSize: 20),
                      ),
                      TextField(
                        controller: userController,
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
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Código de Manilla",
                        style: GoogleFonts.acme(fontSize: 20),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
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

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text(
                            "Tipo de Manilla",
                            style: GoogleFonts.acme(fontSize: 20),
                          ),
                          SizedBox(
                            width: 160,
                            child: TextField(
                              controller: typeController,
                              style: const TextStyle(fontSize: 18),
                              textAlign: TextAlign.center,
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
                      Column(
                        children: [
                          Text(
                            "Valor de Manilla",
                            style: GoogleFonts.acme(fontSize: 20),
                          ),
                          SizedBox(
                            width: 160,
                            child: TextField(
                              keyboardType: TextInputType.number,
                              controller: priceController,
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
                      )
                    ],
                  ),

                  //Buttons
                  const SizedBox(height: 50),

                  MaterialButton(
                    elevation: 10,
                    height: 55,
                    minWidth: 160,
                    onPressed: () async {
                      final conectivity =
                          await (Connectivity().checkConnectivity());
                      try {
                        if (conectivity == ConnectivityResult.wifi) {
                          try {
                            validateCamps(context);
                            DataHelper dataHelper = DataHelper();
                            dataHelper.addBracelet(
                              int.parse(codeController.text),
                              userController.text,
                              typeController.text,
                              int.parse(priceController.text),
                            );

                            Future.delayed(const Duration(seconds: 1)).then(
                              (value) {
                                launchSnackBar(
                                  context,
                                  "Manilla Registrada",
                                  const Color.fromARGB(255, 116, 160, 118),
                                );
                              },
                            );

                            codeController.clear();
                            userController.clear();
                            typeController.clear();
                            priceController.clear();
                          } catch (exception) {
                            exception.toString();
                          }
                        } else if (conectivity == ConnectivityResult.mobile) {
                          try {
                            validateCamps(context);
                            DataHelper dataHelper = DataHelper();
                            dataHelper.addBracelet(
                              int.parse(codeController.text),
                              userController.text,
                              typeController.text,
                              int.parse(priceController.text),
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

                            codeController.clear();
                            userController.clear();
                            typeController.clear();
                            priceController.clear();
                          } catch (exception) {
                            exception.toString();
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
                        }
                      } catch (e) {
                        e.toString();
                      }
                    },
                    color: Colors.black,
                    child: Text(
                      "Registrar",
                      style:
                          GoogleFonts.acme(fontSize: 20, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 30),
                  MaterialButton(
                    elevation: 10,
                    height: 55,
                    minWidth: 160,
                    onPressed: () {
                      userController.clear();
                      codeController.clear();
                      typeController.clear();
                      priceController.clear();
                    },
                    color: const Color.fromRGBO(49, 184, 135, 1),
                    child: Text(
                      "Cancelar",
                      style:
                          GoogleFonts.acme(fontSize: 20, color: Colors.white),
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
