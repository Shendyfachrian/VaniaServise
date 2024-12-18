import 'package:vania/vania.dart';
import 'package:vania_servise/app/models/productnotes.dart';


// ignore: implementation_imports
import 'package:vania/src/exception/validation_exception.dart';

class ProductNotesController extends Controller {
  // Menampilkan semua catatan produk
  Future<Response> index() async {
    try {
      final listProductNotes = await Productnotes().query().get();
      return Response.json({
        'message': 'Daftar catatan produk',
        'data': listProductNotes,
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'Gagal mengambil data catatan produk',
        'error': e.toString(),
      }, 500);
    }
  }

  // Membuat catatan produk baru
  Future<Response> create(Request request) async {
    try {
      request.validate({
        'note_id': 'required|string',
        'prod_id': 'required|string',
        'note_text': 'required|string',
      }, {
        'note_id.required': 'ID catatan tidak boleh kosong',
        'note_id.string': 'ID catatan harus berupa teks',
        'prod_id.required': 'ID produk tidak boleh kosong',
        'prod_id.string': 'ID produk harus berupa teks',
        'note_text.required': 'Catatan tidak boleh kosong',
        'note_text.string': 'Catatan harus berupa teks',
      });

      final requestData = request.input();
      requestData['note_date'] = DateTime.now().toIso8601String();

      await Productnotes().query().insert(requestData);

      return Response.json({
        'message': 'Catatan produk berhasil dibuat',
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

  // Menampilkan detail catatan produk berdasarkan ID
  Future<Response> show(String productNoteId) async {
    try {
      final productNote = await Productnotes()
          .query()
          .where('note_id', '=', productNoteId)
          .first();

      if (productNote == null) {
        return Response.json(
            {'message': 'Catatan produk tidak ditemukan'}, 404);
      }

      return Response.json({
        'message': 'Detail catatan produk',
        'data': productNote,
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'Internal Server Error',
        'error': e.toString(),
      }, 500);
    }
  }

  // Mengupdate data catatan produk berdasarkan ID
  Future<Response> update(Request request, String productNoteId) async {
    try {
      request.validate({
        'prod_id': 'required|string',
        'note_text': 'required|string',
      }, {
        'prod_id.required': 'ID produk tidak boleh kosong',
        'prod_id.string': 'ID produk harus berupa teks',
        'note_text.required': 'Catatan tidak boleh kosong',
        'note_text.string': 'Catatan harus berupa teks',
      });

      final requestData = request.input();
      requestData['note_date'] = DateTime.now().toIso8601String();

      final productNote = await Productnotes()
          .query()
          .where('note_id', '=', productNoteId)
          .first();

      if (productNote == null) {
        return Response.json(
            {'message': 'Catatan produk tidak ditemukan'}, 404);
      }

      await Productnotes()
          .query()
          .where('note_id', '=', productNoteId)
          .update(requestData);

      return Response.json({
        'message': 'Catatan produk berhasil diperbarui',
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

  // Menghapus catatan produk berdasarkan ID
  Future<Response> destroy(String productNoteId) async {
    try {
      final productNote = await Productnotes()
          .query()
          .where('note_id', '=', productNoteId)
          .first();

      if (productNote == null) {
        return Response.json(
            {'message': 'Catatan produk tidak ditemukan'}, 404);
      }

      await Productnotes()
          .query()
          .where('note_id', '=', productNoteId)
          .delete();

      return Response.json({
        'message': 'Catatan produk berhasil dihapus',
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'Internal Server Error',
        'error': e.toString(),
      }, 500);
    }
  }
}

final ProductNotesController productNoteController = ProductNotesController();