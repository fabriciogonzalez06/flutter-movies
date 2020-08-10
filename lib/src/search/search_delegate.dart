import 'package:flutter/material.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:peliculas/src/providers/peliculas_providers.dart';

class DataSearch extends SearchDelegate {

  final peliculasProvider= new PeliculasProvider();

  String seleccion;

  final peliculas = [
    'Spiderman',
    'Aquaman',
    'Batman',
    'Shazam',
    'Iroman',
    'Capitan america'
  ];

  final peliculasRecientes = ['spiderman', 'Capitan america'];

  @override
  List<Widget> buildActions(BuildContext context) {
    // las acciones de nuestro appbar
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Icono a la izquierda del appbar
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Crea los resultados que vamos a mostrar
    return Center(
      child: Container(
        height: 100.0,
        width: 100.0,
        color: Colors.blueAccent,
        child: Text(seleccion),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Las sugerencias que aparecen cuando la persona escribe


    if(query.isEmpty){
        return Container();
    }

    return FutureBuilder(
      future: peliculasProvider.buscarPelicula(query) ,
      builder: (BuildContext context, AsyncSnapshot<List<Pelicula>> snapshot){
          if(snapshot.hasData) { 

            final peliculas = snapshot.data;

            return ListView(
              children: peliculas.map((pelicula){
                return ListTile(
                  leading: FadeInImage(
                    image: NetworkImage(pelicula.getPosterImg()),
                    placeholder: AssetImage('assets/img/no-image.jpg'),
                    fit: BoxFit.cover,
                  ),
                  title: Text(pelicula.title),
                  subtitle: Text(pelicula.originalTitle),
                  onTap: (){
                    close(context,null);
                    pelicula.uniqueId='';
                    Navigator.pushNamed(context, 'detalle',arguments: pelicula);
                  },
                );
              }).toList(),
            );
          }else{
            return Center(child: CircularProgressIndicator(),);
          }
      },
      
    );
  }
/*   @override
  Widget buildSuggestions(BuildContext context) {
    // Las sugerencias que aparecen cuando la persona escribe

    final listaSugerida = (query.isEmpty)
        ? peliculasRecientes
        : peliculas
            .where((p) => p.toLowerCase().startsWith(query.toLowerCase()))
            .toList();

    return ListView.builder(
        itemCount: listaSugerida.length,
        itemBuilder: (context, i) {
          return (listaSugerida.length == 0)
              ? Text('no hay resultados')
              : ListTile(
                  leading: Icon(Icons.movie),
                  title: Text(listaSugerida[i]),
                  onTap: () {
                    seleccion = listaSugerida[i];
                    // showResults(context);
                  },
                );
        });
  } */
}
