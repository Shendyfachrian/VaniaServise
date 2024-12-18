import 'package:vania/vania.dart';

class CreateOrdersTable extends Migration {

  @override
  Future<void> up() async{
   super.up();
   await createTableNotExists('orders', () {
      bigIncrements('order_num');
      date('order_date');
      bigInt('cust_id', unsigned: true);
      foreign('cust_id', 'customer', 'cust_id', constrained: true, onDelete: 'CASCADE');
      primary('order_num');
    });
  }

  @override
  Future<void> down() async {
    super.down();
    await dropIfExists('orders');
  }
}
