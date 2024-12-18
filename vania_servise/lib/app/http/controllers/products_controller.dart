import 'package:vania/vania.dart';
import 'package:vania_servise/app/models/products.dart';

// ignore: implementation_imports
import 'package:vania/src/exception/validation_exception.dart';

class ProductsController extends Controller {
  // Menampilkan semua produk
  Future<Response> index() async {
    try {
      final listProduct = await Products().query().get();
      return Response.json({
        'message': 'Daftar produk',
        'data': listProduct,
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'Gagal mengambil data',
        'error': e.toString(),
      }, 500);
    }
  }

  // Membuat produk baru
  Future<Response> create(Request request) async {
    try {
      request.validate({
        'prod_id': 'required|string|max_length:10',
        'prod_name': 'required|string|max_length:25',
        'prod_price': 'required|numeric|min:0',
        'prod_desc': 'required|string',
        'vend_id': 'required|string|max_length:5',
      }, {
        'prod_id.required': 'ID produk tidak boleh kosong',
        'prod_id.string': 'ID produk harus berupa teks',
        'prod_id.max_length': 'ID produk maksimal 10 karakter',
        'prod_name.required': 'Nama produk tidak boleh kosong',
        'prod_name.string': 'Nama produk harus berupa teks',
        'prod_name.max_length': 'Nama produk maksimal 25 karakter',
        'prod_price.required': 'Harga tidak boleh kosong',
        'prod_price.numeric': 'Harga harus berupa angka',
        'prod_price.min': 'Harga tidak boleh kurang dari 0',
        'prod_desc.required': 'Deskripsi tidak boleh kosong',
        'prod_desc.string': 'Deskripsi harus berupa teks',
        'vend_id.required': 'Vendor ID tidak boleh kosong',
        'vend_id.string': 'Vendor ID harus berupa teks',
        'vend_id.max_length': 'Vendor ID maksimal 5 karakter',
      });

      final requestData = request.input();

      await Products().query().insert(requestData);

      return Response.json({
        'message': 'Produk berhasil dibuat',
        'data': requestData,
      }, 201);
    } catch (e) {
      if (e is ValidationException) {
        final errorMessages = e.message;
        return Response.json({'message': errorMessages}, 400);
      } else {
        return Response.json({'message': 'Internal Server Error'}, 500);
      }
    }
  }

  // Menampilkan detail produk berdasarkan ID
  Future<Response> show(String prodId) async {
    try {
      final product =
          await Products().query().where('prod_id', '=', prodId).first();

      if (product == null) {
        return Response.json({'message': 'Produk tidak ditemukan'}, 404);
      }

      return Response.json({
        'message': 'Detail produk',
        'data': product,
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'Internal Server Error',
        'error': e.toString(),
      }, 500);
    }
  }

  // Mengupdate data produk berdasarkan ID
  Future<Response> update(Request request, String prodId) async {
    try {
      request.validate({
        'prod_name': 'required|string|max_length:25',
        'prod_price': 'required|integer|min:0',
        'prod_desc': 'required|string',
        'vend_id': 'required|string|max_length:5',
      }, {
        'prod_name.required': 'Nama produk tidak boleh kosong',
        'prod_name.string': 'Nama produk harus berupa teks',
        'prod_name.max_length': 'Nama produk maksimal 25 karakter',
        'prod_price.required': 'Harga tidak boleh kosong',
        'prod_price.integer': 'Harga harus berupa bilangan bulat',
        'prod_price.min': 'Harga tidak boleh kurang dari 0',
        'prod_desc.required': 'Deskripsi tidak boleh kosong',
        'prod_desc.string': 'Deskripsi harus berupa teks',
        'vend_id.required': 'Vendor ID tidak boleh kosong',
        'vend_id.string': 'Vendor ID harus berupa teks',
        'vend_id.max_length': 'Vendor ID maksimal 5 karakter',
      });

      final requestData = request.input();

      final product =
          await Products().query().where('prod_id', '=', prodId).first();

      if (product == null) {
        return Response.json({'message': 'Produk tidak ditemukan'}, 404);
      }

      await Products().query().where('prod_id', '=', prodId).update(requestData);

      return Response.json({
        'message': 'Produk berhasil diperbarui',
        'data': requestData,
      }, 200);
    } catch (e) {
      if (e is ValidationException) {
        final errorMessages = e.message;
        return Response.json({
          'error': errorMessages,
        }, 400);
      } else {
        return Response.json({
          'error': 'Internal Server Error',
        }, 500);
      }
    }
  }

  // Menghapus produk berdasarkan ID
  Future<Response> destroy(String prodId) async {
    try {
      final product =
          await Products().query().where('prod_id', '=', prodId).first();

      if (product == null) {
        return Response.json({'message': 'Produk tidak ditemukan'}, 404);
      }

      await Products().query().where('prod_id', '=', prodId).delete();

      return Response.json({
        'message': 'Produk berhasil dihapus',
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'Internal Server Error',
        'error': e.toString(),
      }, 500);
    }
  }
}


final ProductsController productsController = ProductsController();
// final ProductController productController = ProductController();