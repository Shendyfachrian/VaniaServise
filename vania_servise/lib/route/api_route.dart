import 'package:vania/vania.dart';
import 'package:vania_servise/app/http/controllers/auth_controller.dart';
import 'package:vania_servise/app/http/controllers/customer_controller.dart';
import 'package:vania_servise/app/http/controllers/orderitems_controller.dart';
import 'package:vania_servise/app/http/controllers/orders_controller.dart';
import 'package:vania_servise/app/http/controllers/productnotes_controller.dart';
import 'package:vania_servise/app/http/controllers/products_controller.dart';
import 'package:vania_servise/app/http/controllers/vendors_controlller.dart';
import 'package:vania_servise/app/http/middleware/authenticate.dart';

// import 'package:vania_servise/app/http/middleware/authenticate.dart';
// import 'package:vania_servise/app/http/middleware/home_middleware.dart';
// import 'package:vania_servise/app/http/middleware/error_response_middleware.dart';

class ApiRoute implements Route {
  @override
  void register() {
    /// Base RoutePrefix
  Router.basePrefix('api');

    Router.post('/product', productsController.create);
    Router.get('/product', productsController.index);
    Router.put('/product/{prod_id}', productsController.update);
    Router.delete('/product/{prod_id}', productsController.destroy);

    Router.post('/customer', customerController.create);
    Router.get('/customer', customerController.index).middleware([AuthenticateMiddleware()]);
    Router.put('/customer/{cust_id}', customerController.update);
    Router.delete('/customer/{cust_id}', customerController.destroy);

    Router.post('/vendor', vendorController.create);
    Router.get('/vendor', vendorController.index);
    Router.put('/vendor/{vend_id}', vendorController.update);
    Router.delete('/vendor/{vend_id}', vendorController.destroy);

    Router.post('/order', orderController.create);
    Router.get('/order', orderController.index);
    Router.put('/order/{order_num}', orderController.update);
    Router.delete('/order/{order_num}', orderController.destroy);

    Router.post('/order/item', orderItemController.create);
    Router.get('/order/item', orderItemController.index);
    Router.put('/order/item/{order_item}', orderItemController.update);
    Router.delete('/order/item/{order_item}', orderItemController.destroy);

    Router.post('/product/note', productNoteController.create);
    Router.get('/product/note', productNoteController.index);
    Router.put('/product/note/{note_id}', productNoteController.update);
    Router.delete('/product/note/{note_id}', productNoteController.destroy);

    Router.post('/login', authController.login);
    Router.delete('/delete/token', authController.allLogout);
    Router.post('/register', authController.register);
  }
}