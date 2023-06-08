//Dependências principais
import 'package:flutter/material.dart';
//Páginas
import '/pages/Busca.dart';
import '/pages/Home.dart';
import '/pages/Racas.dart';
import '/pages/Sobre.dart';
import '/pages/Favoritos.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The Cat Flutter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/racas': (context) => BreedsScreen(),
        '/buscar': (context) => SearchScreen(),
        '/favoritos': (context) => Favoritos(),
        '/sobre': (context) => AboutScreen(),
      },
    );
  }
}
