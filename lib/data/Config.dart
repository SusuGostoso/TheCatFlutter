import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '/pages/Info.dart';

class AppConfig {
  int tipoAnimal = 0;

  Future<void> exibirDetalhes(context, Animal animal) async {
    Map<String, dynamic> animalDetails =
        await AppConfig.getAnimalDetails(animal.id, animal.tipo);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InfoAnimal(animalDetails),
      ),
    );
  }

  static Future<Map<String, dynamic>> getAnimalDetails(
      String animalId, int typeAnimal) async {
    String api_link = "";

    if (typeAnimal == 0) {
      api_link = "https://api.thecatapi.com/v1/images/$animalId";
    } else {
      api_link = "https://api.thedogapi.com/v1/images/$animalId";
    }

    final response = await http.get(Uri.parse(api_link));

    if (response.statusCode == 200) {
      final animals = jsonDecode(response.body);

      animals['tipo'] = typeAnimal;

      return animals;
    } else {
      throw Exception('Falha ao buscar as informações do bixin!');
    }
  }

  static List<Animal> animaisFavoritos = [];

  static List<String> catCategories = [
    'Nenhuma',
    "Caixas",
    "Roupas",
    "Chapéus",
    "Pias",
    "Espaço",
    "Óculos de sol",
    "Laços",
    "Caturday",
    "Cozinha"
  ];

  static Map<String, String> categoriesIds = {
    'Nenhuma': '',
    'Caixas': '5',
    'Roupas': '15',
    'Chapéus': '1',
    'Pias': '14',
    'Espaço': '2',
    'Óculos de sol': '4',
    'Laços': '7',
    'Caturday': '6',
    'Cozinha': '10'
  };

  static List<String> catBreeds = [
    'Nenhuma',
    'Abyssinian',
    'Aegean',
    'American Bobtail',
    'American Curl',
    'American Shorthair',
    'American Wirehair',
    'Arabian Mau',
    'Australian Mist',
    'Balinese',
    'Bambino',
    'Bengal',
    'Birman',
    'Bombay',
    'British Longhair',
    'British Shorthair',
    'Burmese',
    'Burmilla',
    'California Spangled',
    'Chantilly-Tiffany',
    'Chartreux',
    'Chausie',
    'Cheetoh',
    'Colorpoint Shorthair',
    'Cornish Rex',
    'Cymric',
    'Cyprus',
    'Devon Rex',
    'Donskoy',
    'Dragon Li',
    'Egyptian Mau',
    'European Burmese',
    'Exotic Shorthair',
    'Havana Brown',
    'Himalayan',
    'Japanese Bobtail',
    'Javanese',
    'Khao Manee',
    'Korat',
    'Kurilian',
    'LaPerm',
    'Maine Coon',
    'Malayan',
    'Manx',
    'Munchkin',
    'Nebelung',
    'Norwegian Forest Cat',
    'Ocicat',
    'Oriental',
    'Persian',
    'Pixie-bob',
    'Ragamuffin',
    'Ragdoll',
    'Russian Blue',
    'Savannah',
    'Scottish Fold',
    'Selkirk Rex',
    'Siamese',
    'Siberian',
    'Singapura',
    'Snowshoe',
    'Somali',
    'Sphynx',
    'Tonkinese',
    'Toyger',
    'Turkish Angora',
    'Turkish Van',
    'York Chocolate'
  ];

  static Map<String, String> breedIds = {
    'Nenhuma': '',
    'Abyssinian': 'abys',
    'Aegean': 'aege',
    'American Bobtail': 'abob',
    'American Curl': 'acur',
    'American Shorthair': 'asho',
    'American Wirehair': 'awir',
    'Arabian Mau': 'amau',
    'Australian Mist': 'amis',
    'Balinese': 'bali',
    'Bambino': 'bamb',
    'Bengal': 'beng',
    'Birman': 'birm',
    'Bombay': 'bomb',
    'British Longhair': 'bslo',
    'British Shorthair': 'bsho',
    'Burmese': 'bure',
    'Burmilla': 'buri',
    'California Spangled': 'cspa',
    'Chantilly-Tiffany': 'ctif',
    'Chartreux': 'char',
    'Chausie': 'chau',
    'Cheetoh': 'chee',
    'Colorpoint Shorthair': 'csho',
    'Cornish Rex': 'crex',
    'Cymric': 'cymr',
    'Cyprus': 'cypr',
    'Devon Rex': 'drex',
    'Donskoy': 'dons',
    'Dragon Li': 'lihu',
    'Egyptian Mau': 'emau',
    'European Burmese': 'ebur',
    'Exotic Shorthair': 'esho',
    'Havana Brown': 'hbro',
    'Himalayan': 'hima',
    'Japanese Bobtail': 'jbob',
    'Javanese': 'java',
    'Khao Manee': 'khao',
    'Korat': 'kora',
    'Kurilian': 'kuri',
    'LaPerm': 'lape',
    'Maine Coon': 'mcoo',
    'Malayan': 'mala',
    'Manx': 'manx',
    'Munchkin': 'munc',
    'Nebelung': 'nebe',
    'Norwegian Forest Cat': 'norw',
    'Ocicat': 'ocic',
    'Oriental': 'orie',
    'Persian': 'pers',
    'Pixie-bob': 'pixi',
    'Ragamuffin': 'raga',
    'Ragdoll': 'ragd',
    'Russian Blue': 'rblu',
    'Savannah': 'sava',
    'Scottish Fold': 'sfol',
    'Selkirk Rex': 'srex',
    'Siamese': 'siam',
    'Siberian': 'sibe',
    'Singapura': 'sing',
    'Snowshoe': 'snow',
    'Somali': 'soma',
    'Sphynx': 'sphy',
    'Tonkinese': 'tonk',
    'Toyger': 'toyg',
    'Turkish Angora': 'tang',
    'Turkish Van': 'tvan',
    'York Chocolate': 'ycho'
  };

  bool animalExists(String id) {
    return animaisFavoritos.any((animal) => animal.id == id);
  }
}

class Animal {
  final String id;
  final String url;
  final int tipo;

  Animal({required this.id, required this.url, required this.tipo});
}
