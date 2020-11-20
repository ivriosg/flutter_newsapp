// Modelo encargado de realizar peticiones https

import 'package:flutter/material.dart';
import 'package:newsapp/src/models/news_models.dart';
import 'package:newsapp/src/models/category_model.dart';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Definimos las URL's principales
final _urlNews = 'https://newsapi.org/v2';
final _apiKey = 'c5d143c293904545895221c78e681d48';

class NewsService with ChangeNotifier {
  // Cargamos los artículos en una variable
  List<Article> headlines = [];

  // Definimos categoria por defecto
  String _selectedCategory = 'business';

  bool _isLoading = true;

  //Creamos listado de categorias
  List<Category> categories = [
    Category(FontAwesomeIcons.building, 'business'),
    Category(FontAwesomeIcons.tv, 'entertainment'),
    Category(FontAwesomeIcons.addressCard, 'general'),
    Category(FontAwesomeIcons.headSideVirus, 'health'),
    Category(FontAwesomeIcons.vials, 'science'),
    Category(FontAwesomeIcons.volleyballBall, 'sports'),
    Category(FontAwesomeIcons.memory, 'technology'),
  ];

  // Guardamos las categorías para hacer mas eficiente la app
  Map<String, List<Article>> categoryArticles = {};

  NewsService() {
    this.getTopHeadlines();

    // Inicializamos categorias
    categories.forEach((item) {
      // Asignamos artñiculas a cada categoria
      this.categoryArticles[item.name] = new List();
    });
  }

  bool get isLoading => this._isLoading;

  get selectedCategory => this._selectedCategory;
  set selectedCategory(String valor) {
    // Asignamos el valor al string
    this._selectedCategory = valor;

    this._isLoading = true;
    // Asigno la nueva seleccion de la categoria
    this.getArticlesByCategory(valor);

    notifyListeners();
  }

  // Mostrar ar´ticulos de la categoría seleccionada
  List<Article> get getArticulosCategoriaSeleccionada =>
      this.categoryArticles[this.selectedCategory];

  getTopHeadlines() async {
    // Creando llamada a la API
    final url = '$_urlNews/top-headlines?apiKey=$_apiKey&country=mx';
    final resp = await http.get(url);

    // Obtenemos la respuesta y lo regresamos en JSON
    final newsResponse = newsResponseFromJson(resp.body);

    // Agregamos todos los artículos de la respusta
    this.headlines.addAll(newsResponse.articles);

    // Avisamos al notify que los artículos ya están en el sistema
    notifyListeners();
  }

  getArticlesByCategory(String category) async {
    // Verificamos que la categoria tenga valores
    if (this.categoryArticles[category].length > 0) {
      this._isLoading = false;
      notifyListeners();
      return this.categoryArticles[category];
    }
    // Creando llamada a la API
    final url =
        '$_urlNews/top-headlines?apiKey=$_apiKey&country=mx&category=$category';
    final resp = await http.get(url);

    // Obtenemos la respuesta y lo regresamos en JSON
    final newsResponse = newsResponseFromJson(resp.body);

    // Asignamos los artículos de la categoría seleccionada a la respuesta
    this.categoryArticles[category].addAll(newsResponse.articles);

    this._isLoading = false;
    // Avisamos al notify que los artículos ya están en el sistema
    notifyListeners();
  }
}
