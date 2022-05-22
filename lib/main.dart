import './pokehub.dart';
import 'pokemondetails.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
    );
  }
}

class Home extends StatefulWidget{
  @override
  HomePageState createState(){
    return HomePageState();
  }
}

class HomePageState extends State<Home>{

  final url = 'https://raw.githubusercontent.com/Biuni/PokemonGO-Pokedex/master/pokedex.json';

  late PokeHub pokeHub = new PokeHub();

  @override
  void initState(){
     super.initState();
     getPokemons(url);
     print(pokeHub.pokemon);
  }

  //Obtenemos la data del API
  getPokemons(String apiUrl) async {
    final url = Uri.parse(apiUrl);
    final response = await http.get(url);

    final json = jsonDecode(response.body);
    pokeHub = PokeHub.fromJson(json);
  }

  //This Widget is root screen in the App
  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.red[800],
        title: Center(child: Text('Pokedex'),),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        children: pokeHub.pokemon?.map((poke) => Padding(
            padding: const EdgeInsets.all(2.0),
            child: Container(
            child: InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) =>  PokeDetail(
                  pokemon: poke,
                )));
              },
              child: Card(
              elevation: 3.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    height: 100.0,
                    width: 100.0,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(poke.img ?? '')),
                    ),
                  ),
                  Text(poke.name ?? '', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),)
                ],
              ),
            ),
            ),
            ),
        )
        ).toList() ?? [],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        backgroundColor:  Colors.red[800],
        child: Icon(Icons.refresh),
      ),
    );
  }

}

