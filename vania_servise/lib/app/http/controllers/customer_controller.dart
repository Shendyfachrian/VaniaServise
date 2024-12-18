import 'package:vania_servise/app/models/customer.dart';
import 'package:vania/vania.dart';
// ignore: implementation_imports
import 'package:vania/src/exception/validation_exception.dart';

class CustomerController extends Controller {
  // Menampilkan semua customer
  Future<Response> index() async {
    try {
      final listCustomer = await Customer().query().get();
      return Response.json({
        'message': 'Daftar pelanggan',
        'data': listCustomer,
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'Gagal mengambil data pelanggan',
        'error': e.toString(),
      }, 500);
    }
  }

  // Menyimpan data customer baru
  Future<Response> create(Request request) async {
    try {
      // Validasi input
      request.validate({
        'cust_name': 'required|string|max_length:50',
        'cust_address': 'required|string|max_length:50',
        'cust_city': 'required|string|max_length:20',
        'cust_state': 'required|string|max_length:5',
        'cust_zip': 'required|string|max_length:7',
        'cust_country': 'required|string|max_length:25',
        'cust_phone': 'required|string|max_length:12',
      }, {
        'cust_name.required': 'Nama pelanggan tidak boleh kosong',
        'cust_name.string': 'Nama pelanggan harus berupa teks',
        'cust_name.max_length': 'Nama pelanggan maksimal 50 karakter',
        'cust_address.required': 'Alamat pelanggan tidak boleh kosong',
        'cust_address.string': 'Alamat pelanggan harus berupa teks',
        'cust_address.max_length': 'Alamat pelanggan maksimal 50 karakter',
        'cust_city.required': 'Kota pelanggan tidak boleh kosong',
        'cust_city.string': 'Kota pelanggan harus berupa teks',
        'cust_city.max_length': 'Kota pelanggan maksimal 20 karakter',
        'cust_state.required': 'Provinsi pelanggan tidak boleh kosong',
        'cust_state.string': 'Provinsi pelanggan harus berupa teks',
        'cust_state.max_length': 'Provinsi pelanggan maksimal 5 karakter',
        'cust_zip.required': 'Kode pos tidak boleh kosong',
        'cust_zip.string': 'Kode pos harus berupa teks',
        'cust_zip.max_length': 'Kode pos maksimal 7 karakter',
        'cust_country.required': 'Negara pelanggan tidak boleh kosong',
        'cust_country.string': 'Negara pelanggan harus berupa teks',
        'cust_country.max_length': 'Negara pelanggan maksimal 25 karakter',
        'cust_phone.required': 'Nomor telepon tidak boleh kosong',
        'cust_phone.string': 'Nomor telepon harus berupa teks',
        'cust_phone.max_length': 'Nomor telepon maksimal 12 karakter',
      });

      final requestData = await request.input();

      await Customer().query().insert(requestData);

      return Response.json({
        'message': 'Pelanggan berhasil dibuat',
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

  // Menampilkan detail customer berdasarkan ID
  Future<Response> show(int id) async {
    try {
      final customer =
          await Customer().query().where('cust_id', '=', id).first();

      if (customer == null) {
        return Response.json({'message': 'Pelanggan tidak ditemukan'}, 404);
      }

      return Response.json({
        'message': 'Detail pelanggan',
        'data': customer,
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'Internal Server Error',
        'error': e.toString(),
      }, 500);
    }
  }

  // Menampilkan form untuk mengedit customer (opsional)
  Future<Response> edit(int id) async {
    try {
      final customer =
          await Customer().query().where('cust_id', '=', id).first();

      if (customer == null) {
        return Response.json({'message': 'Pelanggan tidak ditemukan'}, 404);
      }

      return Response.json({
        'message': 'Form untuk mengedit pelanggan',
        'data': customer,
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'Internal Server Error',
        'error': e.toString(),
      }, 500);
    }
  }

  // Memperbarui data customer berdasarkan ID
  Future<Response> update(Request request, int id) async {
    try {
      // Validasi input
      request.validate({
        'cust_name': 'required|string|max_length:50',
        'cust_address': 'required|string|max_length:50',
        'cust_city': 'required|string|max_length:20',
        'cust_state': 'required|string|max_length:5',
        'cust_zip': 'required|string|max_length:7',
        'cust_country': 'required|string|max_length:25',
        'cust_phone': 'required|string|max_length:12',
      }, {
        'cust_name.required': 'Nama pelanggan tidak boleh kosong',
        'cust_name.string': 'Nama pelanggan harus berupa teks',
        'cust_name.max_length': 'Nama pelanggan maksimal 50 karakter',
        'cust_address.required': 'Alamat pelanggan tidak boleh kosong',
        'cust_address.string': 'Alamat pelanggan harus berupa teks',
        'cust_address.max_length': 'Alamat pelanggan maksimal 50 karakter',
        'cust_city.required': 'Kota pelanggan tidak boleh kosong',
        'cust_city.string': 'Kota pelanggan harus berupa teks',
        'cust_city.max_length': 'Kota pelanggan maksimal 20 karakter',
        'cust_state.required': 'Provinsi pelanggan tidak boleh kosong',
        'cust_state.string': 'Provinsi pelanggan harus berupa teks',
        'cust_state.max_length': 'Provinsi pelanggan maksimal 5 karakter',
        'cust_zip.required': 'Kode pos tidak boleh kosong',
        'cust_zip.string': 'Kode pos harus berupa teks',
        'cust_zip.max_length': 'Kode pos maksimal 7 karakter',
        'cust_country.required': 'Negara pelanggan tidak boleh kosong',
        'cust_country.string': 'Negara pelanggan harus berupa teks',
        'cust_country.max_length': 'Negara pelanggan maksimal 25 karakter',
        'cust_phone.required': 'Nomor telepon tidak boleh kosong',
        'cust_phone.string': 'Nomor telepon harus berupa teks',
        'cust_phone.max_length': 'Nomor telepon maksimal 12 karakter',
      });

      final requestData = await request.input();

      final customer =
          await Customer().query().where('cust_id', '=', id).first();

      if (customer == null) {
        return Response.json({'message': 'Pelanggan tidak ditemukan'}, 404);
      }

      await Customer().query().where('cust_id', '=', id).update(requestData);

      return Response.json({
        'message': 'Pelanggan berhasil diperbarui',
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

  // Menghapus customer berdasarkan ID
  Future<Response> destroy(int id) async {
    try {
      final customer =
          await Customer().query().where('cust_id', '=', id).first();

      if (customer == null) {
        return Response.json({'message': 'Pelanggan tidak ditemukan'}, 404);
      }

      await Customer().query().where('cust_id', '=', id).delete();

      return Response.json({
        'message': 'Pelanggan berhasil dihapus',
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'Internal Server Error',
        'error': e.toString(),
      }, 500);
    }
  }
}

// Instance dari controller Customer

final CustomerController customerController = CustomerController();
