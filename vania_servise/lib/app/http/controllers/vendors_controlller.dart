import 'package:vania/vania.dart';

// ignore: implementation_imports
import 'package:vania/src/exception/validation_exception.dart';
import 'package:vania_servise/app/models/vendors.dart';

class VendorsController extends Controller {
  // Menampilkan semua data vendor
  Future<Response> index() async {
    try {
      final listVendors = await Vendors().query().get();
      return Response.json({
        'message': 'Daftar vendor',
        'data': listVendors,
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'Gagal mengambil data vendor',
        'error': e.toString(),
      }, 500);
    }
  }

  // Membuat vendor baru
  Future<Response> create(Request request) async {
    try {
      // Validasi input
      request.validate({
        'vend_id': 'required|string|max_length:5',
        'vend_name': 'required|string|max_length:50',
        'vend_address': 'required|string|max_length:255',
        'vend_kota': 'required|string|max_length:25',
        'vend_state': 'required|string|max_length:5',
        'vend_zip': 'required|string|max_length:7',
        'vend_country': 'required|string|max_length:25',
      }, {
        'vend_id.required': 'ID vendor tidak boleh kosong',
        'vend_id.string': 'ID vendor harus berupa teks',
        'vend_id.max_length': 'ID vendor maksimal 5 karakter',
        'vend_name.required': 'Nama vendor tidak boleh kosong',
        'vend_name.string': 'Nama vendor harus berupa teks',
        'vend_name.max_length': 'Nama vendor maksimal 50 karakter',
        'vend_address.required': 'Alamat vendor tidak boleh kosong',
        'vend_address.string': 'Alamat vendor harus berupa teks',
        'vend_address.max_length': 'Alamat vendor maksimal 255 karakter',
        'vend_kota.required': 'Kota vendor tidak boleh kosong',
        'vend_kota.string': 'Kota vendor harus berupa teks',
        'vend_kota.max_length': 'Kota vendor maksimal 25 karakter',
        'vend_state.required': 'Provinsi vendor tidak boleh kosong',
        'vend_state.string': 'Provinsi vendor harus berupa teks',
        'vend_state.max_length': 'Provinsi vendor maksimal 5 karakter',
        'vend_zip.required': 'Kode pos vendor tidak boleh kosong',
        'vend_zip.string': 'Kode pos vendor harus berupa teks',
        'vend_zip.max_length': 'Kode pos vendor maksimal 7 karakter',
        'vend_country.required': 'Negara vendor tidak boleh kosong',
        'vend_country.string': 'Negara vendor harus berupa teks',
        'vend_country.max_length': 'Negara vendor maksimal 25 karakter',
      });

      // Ambil data dari request
      final requestData = request.input();

      // Insert data ke tabel vendor
      await Vendors().query().insert({
        'vend_id': requestData['vend_id'],
        'vend_name': requestData['vend_name'],
        'vend_address': requestData['vend_address'],
        'vend_kota': requestData['vend_kota'],
        'vend_state': requestData['vend_state'],
        'vend_zip': requestData['vend_zip'],
        'vend_country': requestData['vend_country'],
      });

      return Response.json({
        'message': 'Vendor berhasil dibuat',
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


  // Menampilkan detail vendor berdasarkan ID
  Future<Response> show(String vendorId) async {
    try {
      final vendor = await Vendors().query().where('vend_id', '=', vendorId).first();

      if (vendor == null) {
        return Response.json({'message': 'Vendor tidak ditemukan'}, 404);
      }

      return Response.json({
        'message': 'Detail vendor',
        'data': vendor,
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'Internal Server Error',
        'error': e.toString(),
      }, 500);
    }
  }

  // Mengupdate data vendor berdasarkan ID
  Future<Response> update(Request request, String vendorId) async {
    try {
      request.validate({
        'vend_name': 'required|string|max_length:50',
        'vend_address': 'required|string|max_length:255',
        'vend_kota': 'required|string|max_length:25',
        'vend_state': 'required|string|max_length:5',
        'vend_zip': 'required|string|max_length:7',
        'vend_country': 'required|string|max_length:25',
      }, {
        'vend_name.required': 'Nama vendor tidak boleh kosong',
        'vend_name.string': 'Nama vendor harus berupa teks',
        'vend_name.max_length': 'Nama vendor maksimal 50 karakter',
        'vend_address.required': 'Alamat vendor tidak boleh kosong',
        'vend_address.string': 'Alamat vendor harus berupa teks',
        'vend_address.max_length': 'Alamat vendor maksimal 255 karakter',
        'vend_kota.required': 'Kota vendor tidak boleh kosong',
        'vend_kota.string': 'Kota vendor harus berupa teks',
        'vend_kota.max_length': 'Kota vendor maksimal 25 karakter',
        'vend_state.required': 'Provinsi vendor tidak boleh kosong',
        'vend_state.string': 'Provinsi vendor harus berupa teks',
        'vend_state.max_length': 'Provinsi vendor maksimal 5 karakter',
        'vend_zip.required': 'Kode pos vendor tidak boleh kosong',
        'vend_zip.string': 'Kode pos vendor harus berupa teks',
        'vend_zip.max_length': 'Kode pos vendor maksimal 7 karakter',
        'vend_country.required': 'Negara vendor tidak boleh kosong',
        'vend_country.string': 'Negara vendor harus berupa teks',
        'vend_country.max_length': 'Negara vendor maksimal 25 karakter',
      });

      final requestData = request.input();
      // requestData['updated_at'] = DateTime.now().toIso8601String();

      final vendor = await Vendors().query().where('vend_id', '=', vendorId).first();

      if (vendor == null) {
        return Response.json({'message': 'Vendor tidak ditemukan'}, 404);
      }

      await Vendors().query().where('vend_id', '=', vendorId).update(requestData);

      return Response.json({
        'message': 'Vendor berhasil diperbarui',
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

  // Menghapus vendor berdasarkan ID
  Future<Response> destroy(String vendorId) async {
    try {
      final vendor = await Vendors().query().where('vend_id', '=', vendorId).first();

      if (vendor == null) {
        return Response.json({'message': 'Vendor tidak ditemukan'}, 404);
      }

      await Vendors().query().where('vend_id', '=', vendorId).delete();

      return Response.json({
        'message': 'Vendor berhasil dihapus',
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'Internal Server Error',
        'error': e.toString(),
      }, 500);
    }
  }
}

final VendorsController vendorController = VendorsController();
