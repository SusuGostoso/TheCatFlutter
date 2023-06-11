import 'package:flutter/material.dart';
import '/data/Config.dart';
import '/pages/Info.dart';

class Favoritos extends StatefulWidget {
  @override
  _FavoritosState createState() => _FavoritosState();
}

class _FavoritosState extends State<Favoritos> {
  void _removeFavorite(Animal animal) {
    setState(() {
      AppConfig.animaisFavoritos.remove(animal);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Removido dos favoritos com sucesso!"),
        duration: Duration(milliseconds: 600),
      ),
    );
  }

  void _removeAllFavorites() {
    setState(() {
      AppConfig.animaisFavoritos.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Todos os favoritos removidos com sucesso!"),
        duration: Duration(milliseconds: 1000),
      ),
    );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favoritos'),
        actions: [
          if (AppConfig.animaisFavoritos.isNotEmpty)
            NamedIcon(
              text: 'Total',
              iconData: Icons.favorite,
              notificationCount: AppConfig.animaisFavoritos.length,
              onTap: () {},
            ),
        ],
      ),
      body: AppConfig.animaisFavoritos.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error,
                    size: 64,
                    color: Colors.blue,
                  ),
                  Text(
                    'Nenhum favorito! :(',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    itemCount: AppConfig.animaisFavoritos.length,
                    itemBuilder: (context, index) {
                      Animal animal = AppConfig.animaisFavoritos[index];

                      return GestureDetector(
                        onTap: () async {
                          exibirDetalhes(context, animal);
                        },
                        child: Card(
                          child: Stack(
                            children: [
                              Container(
                                alignment: Alignment.center,
                                child: Image.network(
                                  animal.url,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Center(
                                      child: Text('Erro ao carregar a imagem!'),
                                    );
                                  },
                                ),
                              ),
                              Positioned(
                                top: 8,
                                right: 8,
                                child: Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        _removeFavorite(animal);
                                      },
                                      child: Tooltip(
                                        message: 'Remover favorito',
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            color: Colors.red,
                                            shape: BoxShape.circle,
                                          ),
                                          padding: const EdgeInsets.all(6),
                                          child: const Icon(
                                            Icons.delete,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    GestureDetector(
                                      onTap: () async {
                                        exibirDetalhes(context, animal);
                                      },
                                      child: Tooltip(
                                        message: 'Informações',
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            color: Colors.blue,
                                            shape: BoxShape.circle,
                                          ),
                                          padding: const EdgeInsets.all(6),
                                          child: const Icon(
                                            Icons.info,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
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
          }
        },
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
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
        ],
      ),
      floatingActionButton: AppConfig.animaisFavoritos.isEmpty
          ? SizedBox(height: 20)
          : Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton(
                  heroTag: "bt1",
                  onPressed: _removeAllFavorites,
                  tooltip: 'Remover tudo',
                  child: const Icon(Icons.delete),
                ),
                const SizedBox(width: 16),
              ],
            ),
    );
  }
}
