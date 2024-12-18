import 'package:vania/vania.dart';
import 'package:vania_servise/app/models/orderitems.dart';
// ignore: implementation_imports
import 'package:vania/src/exception/validation_exception.dart';

class OrderItemsController extends Controller {
  // Menampilkan semua data order item
  Future<Response> index() async {
    try {
      final listOrderItems = await Orderitems().query().get();
      return Response.json({
        'message': 'Daftar item pesanan',
        'data': listOrderItems,
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'Gagal mengambil data item pesanan',
        'error': e.toString(),
      }, 500);
    }
  }

  // Membuat order item baru
  Future<Response> create(Request request) async {
    try {
      request.validate({
        'order_num': 'required|integer',
        'prod_id': 'required|string',
        'quantity': 'required|integer',
        'size': 'required|integer',
      }, {
        'order_num.required': 'Nomor pesanan tidak boleh kosong',
        'order_num.integer': 'Nomor pesanan harus berupa bilangan bulat',
        'prod_id.required': 'ID produk tidak boleh kosong',
        'prod_id.string': 'ID produk harus berupa teks',
        'quantity.required': 'Jumlah tidak boleh kosong',
        'quantity.integer': 'Jumlah harus berupa bilangan bulat',
        'size.required': 'Ukuran tidak boleh kosong',
        'size.integer': 'Ukuran harus berupa bilangan bulat',
      });

      final requestData = request.input();

      await Orderitems().query().insert(requestData);

      return Response.json({
        'message': 'Item pesanan berhasil dibuat',
        'data': requestData,
      }, 201);
    } catch (e) {
      if (e is ValidationException) {
        return Response.json({'message': e.message}, 400);
      } else {
        return Response.json({'message': 'Internal Server Error'}, 500);
      }
    }
  }

  // Menampilkan detail order item berdasarkan ID
  Future<Response> show(int orderItemId) async {
    try {
      final orderItem = await Orderitems()
          .query()
          .where('order_item', '=', orderItemId)
          .first();

      if (orderItem == null) {
        return Response.json({'message': 'Item pesanan tidak ditemukan'}, 404);
      }

      return Response.json({
        'message': 'Detail item pesanan',
        'data': orderItem,
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'Internal Server Error',
        'error': e.toString(),
      }, 500);
    }
  }

  // Mengupdate data order item berdasarkan ID
  Future<Response> update(Request request, int orderItemId) async {
    try {
      request.validate({
        'prod_id': 'required|string',
        'quantity': 'required|integer',
        'size': 'required|integer',
      }, {
        'prod_id.required': 'ID produk tidak boleh kosong',
        'prod_id.string': 'ID produk harus berupa teks',
        'quantity.required': 'Jumlah tidak boleh kosong',
        'quantity.integer': 'Jumlah harus berupa bilangan bulat',
        'size.required': 'Ukuran tidak boleh kosong',
        'size.integer': 'Ukuran harus berupa bilangan bulat',
      });

      final requestData = request.input();

      final orderItem = await Orderitems()
          .query()
          .where('order_item', '=', orderItemId)
          .first();

      if (orderItem == null) {
        return Response.json({'message': 'Item pesanan tidak ditemukan'}, 404);
      }

      await Orderitems()
          .query()
          .where('order_item', '=', orderItemId)
          .update(requestData);

      return Response.json({
        'message': 'Item pesanan berhasil diperbarui',
        'data': requestData,
      }, 200);
    } catch (e) {
      if (e is ValidationException) {
        return Response.json({'message': e.message}, 400);
      } else {
        return Response.json({'message': 'Internal Server Error'}, 500);
      }
    }
  }

  // Menghapus order item berdasarkan ID
  Future<Response> destroy(int orderItemId) async {
    try {
      final orderItem = await Orderitems()
          .query()
          .where('order_item', '=', orderItemId)
          .first();

      if (orderItem == null) {
        return Response.json({'message': 'Item pesanan tidak ditemukan'}, 404);
      }

      await Orderitems()
          .query()
          .where('order_item', '=', orderItemId)
          .delete();

      return Response.json({
        'message': 'Item pesanan berhasil dihapus',
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'Internal Server Error',
        'error': e.toString(),
      }, 500);
    }
  }
}

final OrderItemsController orderItemController = OrderItemsController();

