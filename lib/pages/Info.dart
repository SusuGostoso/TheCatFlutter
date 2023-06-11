import 'package:flutter/material.dart';
import '/data/Config.dart';

class InfoAnimal extends StatefulWidget {
  final Map<String, dynamic> animalDetails;

  InfoAnimal(this.animalDetails);

  @override
  _InfoAnimalState createState() => _InfoAnimalState();
}

class _InfoAnimalState extends State<InfoAnimal> {
  String titulo = "The Cat Flutter!";
  bool isFavorite = false;

  List<Map<String, dynamic>> getInfos = [];

  @override
  void initState() {
    super.initState();
    isFavorite = AppConfig().animalExists(widget.animalDetails['id']);

    if (widget.animalDetails.containsKey('breeds')) {
      //Existe informação no ID do gato

      if (widget.animalDetails["breeds"][0].containsKey('description')) {
        getInfos.add(
            {"Descrição": widget.animalDetails["breeds"][0]["description"]});
      }

      if (widget.animalDetails["breeds"][0].containsKey('name')) {
        titulo = widget.animalDetails["breeds"][0]["name"];
        getInfos.add({"Raça": titulo});
      }

      if (widget.animalDetails["breeds"][0].containsKey('origin')) {
        getInfos.add({"Origem": widget.animalDetails["breeds"][0]["origin"]});
      }

      if (widget.animalDetails["breeds"][0].containsKey('life_span')) {
        getInfos.add({
          "Vida útil (anos)": widget.animalDetails["breeds"][0]["life_span"]
        });
      }

      if (widget.animalDetails["breeds"][0].containsKey('weight')) {
        if (widget.animalDetails["breeds"][0]["weight"].containsKey('metric')) {
          getInfos.add({
            "Peso (kg)": widget.animalDetails["breeds"][0]["weight"]["metric"]
          });
        }
      }

      if (widget.animalDetails["breeds"][0].containsKey('height')) {
        if (widget.animalDetails["breeds"][0]["height"].containsKey('metric')) {
          getInfos.add({
            "Altura (cm)": widget.animalDetails["breeds"][0]["height"]["metric"]
          });
        }
      }

      if (widget.animalDetails["breeds"][0].containsKey('temperament')) {
        getInfos.add(
            {"Temperamento": widget.animalDetails["breeds"][0]["temperament"]});
      }

      if (widget.animalDetails["breeds"][0].containsKey('intelligence')) {
        getInfos.add({
          "Inteligência": widget.animalDetails["breeds"][0]["intelligence"]
        });
      }

      if (widget.animalDetails["breeds"][0].containsKey('adaptability')) {
        getInfos.add({
          "Capacidade de Adaptação": widget.animalDetails["breeds"][0]
              ["adaptability"]
        });
      }

      if (widget.animalDetails["breeds"][0].containsKey('affection_level')) {
        getInfos.add({
          "Nível de Afeição": widget.animalDetails["breeds"][0]
              ["affection_level"]
        });
      }

      if (widget.animalDetails["breeds"][0].containsKey('child_friendly')) {
        getInfos.add({
          "Amigo de Criança": widget.animalDetails["breeds"][0]
              ["child_friendly"]
        });
      }

      if (widget.animalDetails["breeds"][0].containsKey('energy_level')) {
        getInfos.add({
          "Nível de energia": widget.animalDetails["breeds"][0]["energy_level"]
        });
      }

      if (widget.animalDetails["breeds"][0].containsKey('health_issues')) {
        getInfos.add({
          "Problemas de Saúde": widget.animalDetails["breeds"][0]
              ["health_issues"]
        });
      }

      if (widget.animalDetails["breeds"][0].containsKey('social_needs')) {
        getInfos.add({
          "Necessidade de socialização": widget.animalDetails["breeds"][0]
              ["social_needs"]
        });
      }

      if (widget.animalDetails["breeds"][0].containsKey('stranger_friendly')) {
        getInfos.add({
          "Afeição por Estranhos": widget.animalDetails["breeds"][0]
              ["stranger_friendly"]
        });
      }

      if (widget.animalDetails["breeds"][0].containsKey('vocalisation')) {
        getInfos.add(
            {"Vocalização": widget.animalDetails["breeds"][0]["vocalisation"]});
      }

      if (widget.animalDetails["breeds"][0].containsKey('hairless')) {
        getInfos.add(
            {"Queda de pelo": widget.animalDetails["breeds"][0]["hairless"]});
      }

      if (widget.animalDetails["breeds"][0].containsKey('rare')) {
        getInfos.add({"Raridade": widget.animalDetails["breeds"][0]["rare"]});
      }
    } else {
      //print("Não existe breeds! - id: ${widget.animalDetails['id']}");
    }

    if (widget.animalDetails.containsKey('categories')) {
      print("Existe categories - id: ${widget.animalDetails['id']}");
    } else {
      //print("Não existe categories! - id: ${widget.animalDetails['id']}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titulo),
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
      body: Padding(
        padding: EdgeInsets.all(16),
        child: getInfos.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.network(
                        widget.animalDetails['url'],
                        fit: BoxFit.contain,
                        width: 250,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Nenhuma informação encontrada :(',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.network(
                        widget.animalDetails['url'],
                        fit: BoxFit.contain,
                        width: 250,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Informações:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Expanded(
                    child: ListView.builder(
                      itemCount: getInfos.length,
                      itemBuilder: (context, index) {
                        String chave = getInfos[index].keys.first;
                        dynamic valor = getInfos[index][chave];

                        return Card(
                          child: Container(
                            child: Column(
                              children: [
                                ListTile(
                                  title: Text(chave),
                                  subtitle: (valor is int)
                                      ? Row(
                                          children: List.generate(5, (i) {
                                            if (i < valor) {
                                              return Icon(Icons.star,
                                                  color: Colors.blue);
                                            } else {
                                              return Icon(Icons.star_border,
                                                  color: Colors.grey);
                                            }
                                          }),
                                        )
                                      : Text(valor.toString()),
                                ),
                                Container(
                                  height: 1,
                                  color: Colors.blue, // Cor da linha azul
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
      ),
      floatingActionButton: isFavorite
          ? null
          : FloatingActionButton(
              heroTag: "bt1",
              onPressed: () {
                Animal likeAnimmal = Animal(
                    id: widget.animalDetails['id'],
                    url: widget.animalDetails['url'],
                    tipo: widget.animalDetails['tipo']);

                setState(() {
                  AppConfig.animaisFavoritos.add(likeAnimmal);
                  isFavorite = true;
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Adicionado aos favoritos!"),
                    duration: Duration(milliseconds: 600),
                  ),
                );
              },
              tooltip: 'Favoritar',
              child: const Icon(Icons.favorite),
            ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 3,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushNamed(context, '/');
          } else if (index == 1) {
            Navigator.pushNamed(context, '/racas');
          } else if (index == 2) {
            Navigator.pushNamed(context, '/buscar');
          } else if (index == 3) {
            Navigator.pushNamed(context, '/favoritos');
          }
        },
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
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
    );
  }
}
