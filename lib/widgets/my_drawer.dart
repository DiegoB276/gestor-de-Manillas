import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:parque_tematico/pages/payment_page.dart';
import 'package:parque_tematico/pages/register_page.dart';
import 'package:parque_tematico/pages/reload_page.dart';
import 'package:parque_tematico/pages/search_page.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: 330,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(15),
          bottomRight: Radius.circular(15),
        ),
      ),
      child: ListView(
        children: [
          DrawerHeader(
            child: Image.asset(
              'assets/logo.png',
              fit: BoxFit.fitHeight,
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => RegisterPage(),
                ),
              );
            },
            leading: const Icon(
              Icons.add_circle_outline,
              color: Color.fromARGB(255, 86, 184, 127),
              size: 30,
            ),
            title: Text(
              "Registrar Manilla",
              style: GoogleFonts.acme(fontSize: 25),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const ReloadPage(),
                ),
              );
            },
            leading: const Icon(
              Icons.autorenew_rounded,
              color: Color.fromARGB(255, 86, 184, 127),
              size: 30,
            ),
            title: Text(
              "Recargar Manilla",
              style: GoogleFonts.acme(fontSize: 25),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const PaymentPage(),
                ),
              );
            },
            leading: const Icon(
              Icons.monetization_on_outlined,
              color: Color.fromARGB(255, 86, 184, 127),
              size: 30,
            ),
            title: Text(
              "Pagar Entrada",
              style: GoogleFonts.acme(fontSize: 25),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const SearchPage(),
                ),
              );
            },
            leading: const Icon(
              Icons.search_rounded,
              color: Color.fromARGB(255, 86, 184, 127),
              size: 30,
            ),
            title: Text(
              "Consultar Saldo",
              style: GoogleFonts.acme(fontSize: 25),
            ),
          ),
        ],
      ),
    );
  }
}
