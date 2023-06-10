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
  final priceController = TextEditingController();
  bool statusQRButton = false;
  List<String> listaDeOpciones = ["Estandar", "Premium"];
  late String? typeBracelet = "";

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String? result;

//Generar vista para escanear código----------------------------
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

//Controla el estado del botón para que se muestre el scanner.------
  void changeStatusQRButton() {
    setState(() {
      statusQRButton = true;
    });
  }

// Validar Campos vacíos-----------------------------------
  void validateCamps(BuildContext context) {
    if (codeController.text.isEmpty ||
        userController.text.isEmpty ||
        (typeBracelet == "") ||
        priceController.text.isEmpty) {
      Exception exception = Exception("Hay Campos Vacíos");
      Future.delayed(const Duration(seconds: 1)).then(
        (value) {
          launchSnackBar(context, exception.toString(), Colors.pink);
        },
      );
      userController.clear();
      codeController.clear();
      priceController.clear();
    }
  }

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
      body: Stack(
        children: [
          //Burbbles
          SizedBox(
            child: (MediaQuery.of(context).size.width <= 600)
                ? Stack(
                    children: [
                      myBurbble(5, 10, 55, 55),
                      myBurbble(255, 340, 35, 35),
                      myBurbble(600, 300, 65, 65),
                      myBurbble(585, 20, 20, 20),
                      myBurbble(440, 70, 40, 40),
                      myBurbble(490, 360, 15, 15),
                    ],
                  )
                : myBurbble(0, 0, 0, 0),
          ),

          //End Burbbles
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: (MediaQuery.of(context).size.width <= 600)
                      ? const EdgeInsets.only(
                          top: 20, left: 20, right: 20, bottom: 10)
                      : const EdgeInsets.only(
                          top: 20, left: 120, right: 120, bottom: 10),
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
                              //Botón, al ser presionado, abre el scanner------------------
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
                                width: MediaQuery.of(context).size.width * 0.50,
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
                      //Según el estado del botón de escanear QR,  muestra el scanner o no.
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
                                        () => codeController.text =
                                            result.toString();
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
                                height: 60,
                                width: (MediaQuery.of(context).size.width <=
                                        600)
                                    ? MediaQuery.of(context).size.width * 0.40
                                    : MediaQuery.of(context).size.width * 0.30,
                                child: DropdownButtonFormField(
                                  hint: Text("Seleccione"),
                                  style: TextStyle(
                                      fontSize: 17, color: Colors.black),
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
                                  items: listaDeOpciones.map((e) {
                                    return DropdownMenuItem(
                                      value: e,
                                      child: SizedBox(
                                        width: double.infinity,
                                        child: Text(
                                          e,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                  isDense: true,
                                  isExpanded: true,
                                  onChanged: (String? value) {
                                    typeBracelet = value!;
                                  },
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
                                width: (MediaQuery.of(context).size.width <=
                                        600)
                                    ? MediaQuery.of(context).size.width * 0.40
                                    : MediaQuery.of(context).size.width * 0.30,
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

                      //Buttons-----------------------------
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
                                  typeBracelet!,
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
                                priceController.clear();
                              } catch (exception) {
                                exception.toString();
                              }
                            } else if (conectivity ==
                                ConnectivityResult.mobile) {
                              try {
                                validateCamps(context);
                                DataHelper dataHelper = DataHelper();
                                dataHelper.addBracelet(
                                  int.parse(codeController.text),
                                  userController.text,
                                  typeBracelet!,
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
                          style: GoogleFonts.acme(
                              fontSize: 20, color: Colors.white),
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
                          priceController.clear();
                          print(typeBracelet);
                        },
                        color: const Color.fromRGBO(49, 184, 135, 1),
                        child: Text(
                          "Cancelar",
                          style: GoogleFonts.acme(
                              fontSize: 20, color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

//Burbujas---------------------------------
  Positioned myBurbble(
      double topP, double leftP, double heightP, double widthP) {
    return Positioned(
      top: topP,
      left: leftP,
      child: Container(
        height: heightP,
        width: widthP,
        decoration: BoxDecoration(
          color: Color.fromRGBO(237, 239, 250, 1),
          borderRadius: BorderRadius.circular(100),
        ),
      ),
    );
  }
}
