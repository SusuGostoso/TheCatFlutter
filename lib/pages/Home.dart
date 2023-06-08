//Dependências principais
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
//Outras dependências
import '/data/Config.dart';
import '/pages/Info.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  dynamic catImage;
  bool loading = false;
  String? errorMessage;
  int tipoAnimal = AppConfig().tipoAnimal;

  @override
  void initState() {
    super.initState();
    fetchCatImage();
  }

  Future<void> amei() async {
    if (catImage != null) {
      Animal likeAnimmal =
          Animal(id: catImage["id"], url: catImage["url"], tipo: tipoAnimal);

      AppConfig.animaisFavoritos.add(likeAnimmal);

      fetchCatImage();
    }
  }

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

  Future<void> fetchCatImage() async {
    setState(() {
      loading = true;
      errorMessage = null;
    });

    var apiLinks = [
      'https://api.thecatapi.com/v1/images/search',
      'https://api.thedogapi.com/v1/images/search'
    ];

    try {
      final response = await http.get(Uri.parse(apiLinks[tipoAnimal]));

      if (response.statusCode == 200) {
        final catImages = jsonDecode(response.body) as List<dynamic>;
        setState(() {
          catImage = catImages.isNotEmpty ? catImages[0] : null;
        });
      } else {
        setState(() {
          errorMessage =
              'Falha ao carregar a imagem, tente novamente mais tarde.';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Ocorreu um erro. Verifique sua conexão com a internet.';
      });
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  void likeImage() {
    fetchCatImage();
  }

  void dislikeImage() {
    if (tipoAnimal == 1) {
      tipoAnimal = 0;
    } else {
      tipoAnimal = 1;
    }
    fetchCatImage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('The Cat Flutter'),
      ),
      body: Stack(
        children: [
          if (loading)
            const Center(
              child: CircularProgressIndicator(),
            )
          else if (errorMessage != null)
            Center(
              child: Text(errorMessage!),
            )
          else if (catImage != null)
            ListView(
              children: [
                GestureDetector(
                  onTap: () {
                    //fetchCatImage();
                    Animal iAnimal = Animal(
                        id: catImage["id"],
                        url: catImage['url'],
                        tipo: tipoAnimal);

                    exibirDetalhes(context, iAnimal);
                  },
                  child: Card(
                    child: Image.network(
                      catImage['url'] as String,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                            child: Text('Erro ao carregar a imagem'));
                      },
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          if (index == 0) {
            fetchCatImage();
          } else if (index == 1) {
            Navigator.pushNamed(context, '/racas');
          } else if (index == 2) {
            Navigator.pushNamed(context, '/buscar');
          } else if (index == 3) {
            Navigator.pushNamed(context, '/favoritos');
          } else if (index == 4) {
            Navigator.pushNamed(context, '/sobre');
          }
        },
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pets),
            label: 'Raças',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Busca',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favoritos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'Sobre',
          ),
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "bt1",
            onPressed: dislikeImage,
            tooltip: 'Odiei',
            child: const Icon(Icons.thumb_down),
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
            heroTag: "bt2",
            onPressed: amei,
            tooltip: 'Gostei',
            child: const Icon(Icons.thumb_up),
          ),
          const SizedBox(width: 16),
        ],
      ),
    );
  }
}
