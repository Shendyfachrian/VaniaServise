import 'package:vania/vania.dart';
import 'package:vania_servise/app/models/orders.dart';

// ignore: implementation_imports
import 'package:vania/src/exception/validation_exception.dart';

class OrdersController extends Controller {
  // Menampilkan semua data order
  Future<Response> index() async {
    try {
      final listOrders = await Orders().query().get();
      return Response.json({
        'message': 'Daftar pesanan',
        'data': listOrders,
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'Gagal mengambil data pesanan',
        'error': e.toString(),
      }, 500);
    }
  }

  // Membuat order baru
  Future<Response> create(Request request) async {
    try {
      request.validate({
        'cust_id': 'required|integer',
      }, {
        'cust_id.required': 'ID pelanggan tidak boleh kosong',
        'cust_id.integer': 'ID pelanggan harus berupa bilangan bulat',
      });

      final requestData = request.input();

      requestData['order_date'] = DateTime.now().toIso8601String();

      await Orders().query().insert(requestData);

      return Response.json({
        'message': 'Pesanan berhasil dibuat',
        'data': requestData,
      }, 201);
    } catch (e) {
      if (e is ValidationException) {
        return Response.json({'message': e.message}, 400);
      } else {
        return Response.json({'message': 'id_customer tidak ditemukan'}, 200);
      }
    }
  }

  // Menampilkan detail order berdasarkan ID
  Future<Response> show(int orderId) async {
    try {
      final order = await Orders().query().where('order_num', '=', orderId).first();

      if (order == null) {
        return Response.json({'message': 'Pesanan tidak ditemukan'}, 404);
      }

      return Response.json({
        'message': 'Detail pesanan',
        'data': order,
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'Internal Server Error',
        'error': e.toString(),
      }, 500);
    }
  }

  // Mengupdate data order berdasarkan ID
  Future<Response> update(Request request, int orderId) async {
    try {
      request.validate({
        'cust_id': 'required|integer',
      }, {
        'cust_id.required': 'ID pelanggan tidak boleh kosong',
        'cust_id.integer': 'ID pelanggan harus berupa bilangan bulat',
      });

      final requestData = request.input();

      final order = await Orders().query().where('order_num', '=', orderId).first();

      if (order == null) {
        return Response.json({'message': 'Pesanan tidak ditemukan'}, 404);
      }

      await Orders().query().where('order_num', '=', orderId).update(requestData);

      return Response.json({
        'message': 'Pesanan berhasil diperbarui',
        'data': requestData,
      }, 200);
    } catch (e) {
      if (e is ValidationException) {
        return Response.json({'message': e.message}, 400);
      } else {
        return Response.json({'message': 'Order number tidak ditemukan'}, 200);
      }
    }
  }

  // Menghapus order berdasarkan ID
  Future<Response> destroy(int orderId) async {
    try {
      final order = await Orders().query().where('order_num', '=', orderId).first();

      if (order == null) {
        return Response.json({'message': 'Pesanan tidak ditemukan'}, 404);
      }

      await Orders().query().where('order_num', '=', orderId).delete();

      return Response.json({
        'message': 'Pesanan berhasil dihapus',
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'Internal Server Error',
        'error': e.toString(),
      }, 500);
    }
  }
}

final OrdersController orderController = OrdersController();