import 'package:vania/vania.dart';

class CreateOrderitemsTable extends Migration {

  @override
  Future<void> up() async{
   super.up();
   await createTableNotExists('orderitems', () {
    bigIncrements('order_item');
      bigInt('order_num', unsigned: true);
      string('prod_id',length: 10);
      integer('quantity');
      integer('size');
      foreign('order_num', 'orders', 'order_num', constrained: true, onDelete: 'CASCADE');
      foreign('prod_id', 'products', 'prod_id', constrained: true, onDelete: 'CASCADE');
      primary('order_item');
    });
  }
  @override
  Future<void> down() async {
    super.down();
    await dropIfExists('orderitems');
  }
}
