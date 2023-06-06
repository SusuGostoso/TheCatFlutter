import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AppConfig {
  int gostei = 0;
  int likeCats = 0;
  int likeDogs = 0;
}

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The Cat Flutter',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  dynamic catImage;
  bool loading = false;
  String? errorMessage;
  int gostei = AppConfig().gostei;

  @override
  void initState() {
    super.initState();
    fetchCatImage();
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
      final response = await http.get(Uri.parse(apiLinks[gostei]));

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
    if (gostei == 1) {
      gostei = 0;
    } else {
      gostei = 1;
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
                    fetchCatImage();
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
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => BreedsScreen()),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SearchScreen()),
            );
          } else if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AboutScreen()),
            );
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

class BreedsScreen extends StatefulWidget {
  @override
  _BreedsScreenState createState() => _BreedsScreenState();
}

class _BreedsScreenState extends State<BreedsScreen> {
  List<String> catBreeds = [
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
  String? selectedBreed;
  String? selectedBreedID = "abys";

  List<dynamic> catImages = [];
  bool loading = false;
  String? errorMessage;

  // Mapa que associa cada nome de raça ao seu ID correspondente
  Map<String, String> breedIds = {
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
    // Adicione aqui outros nomes de raças e seus IDs correspondentes
  };

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
    // Define o valor inicial de selectedBreed como o primeiro item da lista de raças
    selectedBreed = catBreeds.first;
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
                  String? breedId = breedIds[
                      selectedBreed!]; // Obtém o ID da raça selecionada
                  selectedBreedID = breedId;
                  fetchCatImages();
                });
              },
              items: catBreeds.map<DropdownMenuItem<String>>((String breed) {
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
              itemCount: catImages
                  .length, // Replace with actual image count based on selected breed
              itemBuilder: (context, index) {
                final imageUrl = catImages[index]['url'] as String?;

                return Card(
                  child: Image.network(
                    imageUrl!,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                          child: Text('Erro ao carregam a imagem!'));
                    },
                  ), // Replace with an Image widget using the corresponding image URL
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
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          } else if (index == 1) {
            fetchCatImages();
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SearchScreen()),
            );
          } else if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AboutScreen()),
            );
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

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<String> catCategories = [
    'Nenhuma',
    "Caixas",
    "Roupas",
    "Chapéus",
    "Pias",
    "Espaço",
    "Óculos de sol",
    "Laços"
  ];

  Map<String, String> categoriesIds = {
    'Nenhuma': '',
    'Caixas': '5',
    'Roupas': '15',
    'Chapéus': '1',
    'Pias': '14',
    'Espaço': '2',
    'Óculos de sol': '4',
    'Laços': '7'
  };

  String? selectedCategory;
  String? selectedCategoryID = "";

  List<String> catBreeds = [
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
  String? selectedBreed;
  String? selectedBreedID = "";

  List<dynamic> catImages = [];
  bool loading = false;
  String? errorMessage;

  // Mapa que associa cada nome de raça ao seu ID correspondente
  Map<String, String> breedIds = {
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

  Future<void> fetchCatImages() async {
    setState(() {
      loading = true;
      errorMessage = null;
    });

    try {
      final response = await http.get(Uri.parse(
          'https://api.thecatapi.com/v1/images/search?limit=10&breed_ids=$selectedBreedID&category_ids=$selectedCategoryID'));
      if (response.statusCode == 200) {
        setState(() {
          catImages = jsonDecode(response.body) as List<dynamic>;
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
    selectedBreed = catBreeds.first;
    selectedCategory = catCategories.first;
    fetchCatImages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Busca'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            margin: const EdgeInsets.only(left: 5.0, right: 5.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Raça/Categoria:"),
                DropdownButton<String>(
                  value: selectedBreed,
                  icon: const Icon(Icons.arrow_downward),
                  elevation: 16,
                  onChanged: (value) {
                    setState(() {
                      selectedBreed = value;
                      String? breedId = breedIds[
                          selectedBreed!]; // Obtém o ID da raça selecionada
                      selectedBreedID = breedId;
                      fetchCatImages();
                    });
                  },
                  items:
                      catBreeds.map<DropdownMenuItem<String>>((String breed) {
                    return DropdownMenuItem<String>(
                      value: breed,
                      child: Text(breed),
                    );
                  }).toList(),
                ),
                DropdownButton<String>(
                  value: selectedCategory,
                  icon: const Icon(Icons.arrow_downward),
                  elevation: 16,
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value;
                      String? categoryID = categoriesIds[
                          selectedCategory!]; // Obtém o ID da raça selecionada
                      selectedCategoryID = categoryID;
                      //print(categoryID);
                      fetchCatImages();
                    });
                  },
                  items: catCategories
                      .map<DropdownMenuItem<String>>((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                ),
              ],
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

                return Card(
                  child: Image.network(
                    imageUrl!,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                          child: Text('Erro ao carregar a imagem!'));
                    },
                  ),
                );
              },
            ),
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
        onTap: (index) {
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => BreedsScreen()),
            );
          } else if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AboutScreen()),
            );
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
            icon: Icon(Icons.info),
            label: 'Sobre',
          ),
        ],
      ),
    );
  }
}

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sobre'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'The Cat Flutter',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Desenvolvido por:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            /*
            Text('Daniel Leônidas de Medeiros'),
            Text('Sueliton dos Santos Medeiros'),
            Text('Vinicius Victor de Lima'),
            */
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0),
                bottomRight: Radius.circular(10.0),
                bottomLeft: Radius.circular(10.0),
              ),
              child: Container(
                alignment: Alignment.center,
                constraints: const BoxConstraints(
                  maxWidth: 350,
                  maxHeight: 60,
                ),
                color: Colors.blue,
                child: Card(
                  child: ListTile(
                    leading: Image.asset("images/oxe1.jpg"),
                    title: Text('Daniel Leônidas de Medeiros'),
                    trailing: Icon(Icons.catching_pokemon),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0),
                bottomRight: Radius.circular(10.0),
                bottomLeft: Radius.circular(10.0),
              ),
              child: Container(
                alignment: Alignment.center,
                constraints: const BoxConstraints(
                  maxWidth: 350,
                  maxHeight: 60,
                ),
                color: Colors.blue,
                child: Card(
                  child: ListTile(
                    leading: Image.asset("images/oxe0.jpg"),
                    title: Text('Sueliton dos Santos Medeiros'),
                    trailing: Icon(Icons.catching_pokemon),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0),
                bottomRight: Radius.circular(10.0),
                bottomLeft: Radius.circular(10.0),
              ),
              child: Container(
                alignment: Alignment.center,
                constraints: const BoxConstraints(
                  maxWidth: 350,
                  maxHeight: 60,
                ),
                color: Colors.blue,
                child: Card(
                  child: ListTile(
                    leading: Image.asset("images/oxe2.png"),
                    title: Text('Vinicius Victor de Lima'),
                    trailing: Icon(Icons.catching_pokemon),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 3,
        onTap: (index) {
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => BreedsScreen()),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SearchScreen()),
            );
          }
        },
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
            icon: Icon(Icons.info),
            label: 'Sobre',
          ),
        ],
      ),
    );
  }
}
