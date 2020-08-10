import 'package:flutter/material.dart';
import 'package:peliculas/src/providers/peliculas_providers.dart';
import 'package:peliculas/src/search/search_delegate.dart';
import 'package:peliculas/src/widgets/card_swiper_widget.dart';
import 'package:peliculas/src/widgets/movie_horizontal.dart';


class HomePage extends StatelessWidget{

   final peliculasProvider= new PeliculasProvider();
   //final _mediaQuery = MediaQuery.of(context).size;

  @override
  Widget build(BuildContext context){

   // peliculasProvider.getPopulares();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Películas en cine'),
        backgroundColor: Colors.indigoAccent,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: (){
             showSearch(context: context, delegate: DataSearch());
             
            },
          )
        ],
      ),
     // body: SafeArea(
        //child:Text('Hola mundo'),
      
      //)
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _swiperTarjetas(),
            _footer(context)
          ],
        ),
      ),
      
    );
  }

  Widget _swiperTarjetas(){
    
  // this.peliculasProvider.getEnCines();
    return  FutureBuilder(
        future: this.peliculasProvider.getEnCines(),
        //initialData: [],
        builder: (BuildContext context ,AsyncSnapshot<List<dynamic>> snapshot ){
          
          if(snapshot.hasData){
            
          return CardSwiper(peliculas: snapshot.data);
          }else {
           return  Container(
             height: 150.0,
             child:Center(
                child: CircularProgressIndicator()
             )
           );
          }

        },
    );
  }

  Widget _footer( BuildContext context){
    this.peliculasProvider.getPopulares();
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding:EdgeInsets.only(left:7.0) ,
            child: Text('populares',
               style: Theme.of(context).textTheme.subhead ,
            ),
          ),
          SizedBox(height: 3.0,),
          StreamBuilder(
            stream: peliculasProvider.popularesStream,
            //initialData: [],
            builder: (BuildContext context, AsyncSnapshot<List> snapshot){
              //print(snapshot.data[0]);
              if(snapshot.hasData){  
              return MovieHorizontalWidget(peliculas: snapshot.data,siguientePagina: peliculasProvider.getPopulares,);
              }else{
                return Center(child: CircularProgressIndicator());
              }
            },
          )
        ],
      ),
    );
  }
}