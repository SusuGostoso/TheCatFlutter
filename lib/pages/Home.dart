//Dependências principais
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
//Outras dependências
import '/data/Config.dart';
import '/pages/Info.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  dynamic catImage;
  bool loading = false;
  String? errorMessage;
  int tipoAnimal = AppConfig.tipoAnimal;
  String nomeApp = "The Cat Flutter";

  @override
  void initState() {
    super.initState();
    fetchCatImage();
  }

  Future<void> amei() async {
    if (catImage != null) {
      if (AppConfig().animalExists(catImage["id"])) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Desculpe, você já favoritou esse bixinho."),
            duration: Duration(milliseconds: 1000),
          ),
        );
      } else {
        Animal likeAnimmal =
            Animal(id: catImage["id"], url: catImage["url"], tipo: tipoAnimal);

        AppConfig.animaisFavoritos.add(likeAnimmal);
      }

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

          nomeApp = (tipoAnimal == 0) ? "The Cat Flutter" : "The Dog Flutter";
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
    tipoAnimal = (tipoAnimal == 1) ? 0 : 1;
    setState(() {
      AppConfig.tipoAnimal = tipoAnimal;
    });

    fetchCatImage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(nomeApp),
        actions: [
          if (AppConfig.animaisFavoritos.isNotEmpty)
            NamedIcon(
              text: 'Favoritos',
              iconData: Icons.favorite,
              notificationCount: AppConfig.animaisFavoritos.length,
              onTap: () {
                Navigator.pushNamed(context, '/favoritos');
              },
            ),
        ],
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
        items: <BottomNavigationBarItem>[
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.pets),
            label: 'Raças',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Busca',
          ),
          AppConfig.animaisFavoritos.isNotEmpty
              ? BottomNavigationBarItem(
                  icon: Stack(
                    children: <Widget>[
                      Icon(Icons.favorite),
                      Positioned(
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(1),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          constraints: BoxConstraints(
                            minWidth: 12,
                            minHeight: 12,
                          ),
                          child: Text(
                            '${AppConfig.animaisFavoritos.length}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    ],
                  ),
                  label: 'Favoritos',
                )
              : BottomNavigationBarItem(
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
            child: const Icon(Icons.favorite),
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
            heroTag: "bt3",
            onPressed: likeImage,
            tooltip: 'Gostei',
            child: const Icon(Icons.thumb_up),
          ),
          const SizedBox(width: 16),
        ],
      ),
    );
  }
}
