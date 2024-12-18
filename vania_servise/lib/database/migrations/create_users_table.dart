import 'package:vania/vania.dart';

class CreateUserTable extends Migration {
  @override
  Future<void> up() async {
    super.up();
    await createTableNotExists('users', () {
      id();
      string('username', length: 80); // Kolom username dengan panjang maksimum 80 karakter dan unik
      string('email', length: 80); // Kolom email dengan panjang maksimum 80 karakter dan unik
      string('password', length: 225);
    });
  } 

  @override
  Future<void> down() async {
    super.down();
    await dropIfExists('users');
  }
}
