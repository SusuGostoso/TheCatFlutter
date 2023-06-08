import 'package:flutter/material.dart';

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
            Image.asset(
              "images/src/gatosusu.png",
              width: 300,
            ),
            SizedBox(height: 16),
            Text(
              'Desenvolvido por:',
              style: TextStyle(fontSize: 18),
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
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushNamed(context, '/');
          }
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
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
