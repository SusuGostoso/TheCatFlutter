import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '/data/Config.dart';

class BreedsScreen extends StatefulWidget {
  @override
  _BreedsScreenState createState() => _BreedsScreenState();
}

class _BreedsScreenState extends State<BreedsScreen> {
  String? selectedBreed;
  String? selectedBreedID = "abys";

  List<dynamic> catImages = [];
  bool loading = false;
  String? errorMessage;

  Future<void> fetchCatImages() async {
    setState(() {
      loading = true;
      errorMessage = null;
    });

    try {
      final response = await http.get(Uri.parse(
          'https://api.thecatapi.com/v1/images/search?limit=10&breed_ids=$selectedBreedID'));
      if (response.statusCode == 200) {
        setState(() {
          catImages = jsonDecode(response.body) as List<dynamic>;

          catImages.forEach((element) {
            if (AppConfig().animalExists(element["id"])) {
              element["isFavorite"] = true;
            } else {
              element["isFavorite"] = false;
            }
          });
        });
      } else {
        setState(() {
          errorMessage = 'Não foi possível carregar a imagem.';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Algum erro aconteceu, verifique sua conexão!';
      });
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    selectedBreed = AppConfig.catBreeds.first;
    fetchCatImages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Raças'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButton<String>(
              value: selectedBreed,
              icon: const Icon(Icons.arrow_downward),
              elevation: 16,
              onChanged: (value) {
                setState(() {
                  selectedBreed = value;
                  String? breedId = AppConfig.breedIds[
                      selectedBreed!]; // Obtém o ID da raça selecionada
                  selectedBreedID = breedId;
                  fetchCatImages();
                });
              },
              items: AppConfig.catBreeds
                  .map<DropdownMenuItem<String>>((String breed) {
                return DropdownMenuItem<String>(
                  value: breed,
                  child: Text(breed),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemCount: catImages.length,
              itemBuilder: (context, index) {
                final imageUrl = catImages[index]['url'] as String?;
                final isFavorite = catImages[index]['isFavorite'] as bool;

                return GestureDetector(
                  onTap: () async {
                    Animal uAnimmal = Animal(
                        id: catImages[index]["id"],
                        url: catImages[index]["url"],
                        tipo: 0);

                    AppConfig().exibirDetalhes(context, uAnimmal);
                  },
                  child: Card(
                    child: Stack(
                      children: [
                        Image.network(
                          imageUrl!,
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                                child: Text('Erro ao carregar a imagem!'));
                          },
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Visibility(
                            visible: !isFavorite,
                            child: Tooltip(
                              message: 'Favoritar',
                              child: IconButton(
                                icon: Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  Animal likeAnimmal = Animal(
                                      id: catImages[index]["id"],
                                      url: catImages[index]["url"],
                                      tipo: 0);

                                  //Adicionou aos favoritos
                                  AppConfig.animaisFavoritos.add(likeAnimmal);

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          "Adicionado aos favoritos com sucesso!"),
                                      duration: Duration(milliseconds: 600),
                                    ),
                                  );

                                  setState(() {
                                    catImages[index]['isFavorite'] = true;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushNamed(context, '/');
          } else if (index == 1) {
            fetchCatImages();
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
            onPressed: fetchCatImages,
            tooltip: 'Atualizar',
            child: const Icon(Icons.refresh_outlined),
          ),
          const SizedBox(width: 16),
        ],
      ),
    );
  }
}
