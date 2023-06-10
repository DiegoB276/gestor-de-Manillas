import 'package:postgres/postgres.dart';

class DataHelper {
  final connection = PostgreSQLConnection("###", 5432, "###",
      username: "###", password: "###");

//Añadir una Nueva manilla
  Future<void> addBracelet(int codeBracelet, String userBracelete,
      String typeBracelete, int priceBracelete) async {
    try {
      await connection.open();

      String sql =
          'INSERT INTO ###(id_manilla, usuario_manilla, tipo_manilla, saldo_manilla) VALUES(@code_bracelet, @user_bracelet, @type_bracelet, @price_bracelet)';

      Map<String, dynamic> values = {
        'code_bracelet': codeBracelet,
        'user_bracelet': userBracelete,
        'type_bracelet': typeBracelete,
        'price_bracelet': priceBracelete,
      };

      await connection.execute(sql, substitutionValues: values);
      await connection.close();
    } catch (exception) {
      exception.toString();
    }
  }

  //Recargar Manilla
  Future<void> reloadBracelet(int id, int price) async {
    try {
      await connection.open();

      final query =
          'UPDATE ### SET saldo_manilla = (saldo_manilla + @price_manilla) WHERE id_manilla = @id_bracelet';

      final values = {
        'price_manilla': price,
        'id_bracelet': id,
      };

      await connection.query(query, substitutionValues: values);
      await connection.close();
    } catch (exception) {
      exception.toString();
    }
  }

  //Pagar Entrada
  Future<void> payBracelet(int id) async {
    const price = 5000;
    await connection.open();

    final query =
        'UPDATE ### SET saldo_manilla = (saldo_manilla - @price_manilla) WHERE id_manilla = @id_bracelet';

    final values = {
      'price_manilla': price,
      'id_bracelet': id,
    };

    await connection.query(query, substitutionValues: values);

    await connection.close();
  }

  //Consultar Saldo Manillas
  Future<dynamic> searchPriceBracelet(int id) async {
    try {
      await connection.open();
      final sql =
          'SELECT saldo_manilla FROM ### WHERE id_manilla = @id_bracelet';

      final values = {
        'id_bracelet': id,
      };

      final result = await connection.query(sql, substitutionValues: values);
      await connection.close();

      if (result.isNotEmpty) {
        return result.first.single;
      } else {
        return 0;
      }
    } catch (e) {
      e.toString();
    }
  }
}
