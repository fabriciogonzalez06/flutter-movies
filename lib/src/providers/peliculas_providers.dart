import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:peliculas/src/models/actores_model.dart';
import 'package:peliculas/src/models/pelicula_model.dart';

class PeliculasProvider {
  String _apiKey = '43f8eabd75ffd672a608ce57d5aabc50';
  String _url = 'api.themoviedb.org';
  String _lenguage = 'es-ES';
  bool cargando = false;

  int _popularesPage = 0;

  List<Pelicula> _populares = new List();

  final _popularesStreamController =
      StreamController<List<Pelicula>>.broadcast();

  //introducir peliculas
  Function(List<Pelicula>) get popularesSink =>
      _popularesStreamController.sink.add;
  //escuchar streams
  Stream<List<Pelicula>> get popularesStream =>
      _popularesStreamController.stream;

  void disponseStreams() {
    this._popularesStreamController?.close();
  }

  Future<List<Pelicula>> _procesarRespuesta(Uri url) async {
    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);

    final peliculas = new Peliculas.fromJsonList(decodedData['results']);

    return peliculas.items;
  }

  Future<List<Pelicula>> getEnCines() async {
    final url = Uri.https(_url, '3/movie/now_playing',
        {'api_key': _apiKey, 'lenguage': _lenguage});

    final respuesta = await _procesarRespuesta(url);
    _populares.addAll(respuesta);
    popularesSink(_populares);
    // return await _procesarRespuesta(url);
    return respuesta;
  }

  Future<List<Pelicula>> getPopulares() async {
    if (cargando) return [];

    cargando = true;

    _popularesPage++;

    final url = Uri.https(_url, '3/movie/popular',
        {'api_key': this._apiKey, 'page': _popularesPage.toString()});

    final respuesta = await _procesarRespuesta(url);
    _populares.addAll(respuesta);
    popularesSink(_populares);
    cargando = false;
    return respuesta;
  }

  Future<List<Actor>> getCast(String peliculaId) async {
    final url = Uri.https(this._url, '3/movie/$peliculaId/credits',
        {'api_key': this._apiKey, 'languague': this._lenguage});

    final res = await http.get(url);
    final decodeData = json.decode(res.body);

    final cast = new Cast.fromJsonList(decodeData['cast']);

    return cast.actores;
  }

  Future<List<Pelicula>> buscarPelicula(String query) async {
    final url = Uri.https(_url, '3/search/movie',
        {'api_key': _apiKey, 'lenguage': _lenguage, 'query': query});

    final respuesta = await _procesarRespuesta(url);
    _populares.addAll(respuesta);
    popularesSink(_populares);
    // return await _procesarRespuesta(url);
    return respuesta;
  }
}
