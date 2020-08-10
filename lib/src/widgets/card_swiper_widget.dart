import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:peliculas/src/models/pelicula_model.dart';

class CardSwiper  extends StatelessWidget {
 
  final List<Pelicula> peliculas;

  CardSwiper({ @required this.peliculas});


  @override
  Widget build(BuildContext context) {
    final  _screenSize = MediaQuery.of(context).size;


    return  Container(
     //width: _screenSize.width * 0.7,
      padding: EdgeInsets.only(top:10),
     // height: _screenSize.height * 0.5,
          child: Swiper(
          itemBuilder: (BuildContext context, int index) {

          peliculas[index].uniqueId='${peliculas[index].id}-tarjeta';

          return Hero(
            tag: peliculas[index].uniqueId,
             child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: GestureDetector(
                onTap: ()=>Navigator.pushNamed( context, 'detalle',arguments: peliculas[index]),
                  child: FadeInImage(
                  image: (peliculas[index].getPosterImg() != null) ? NetworkImage(peliculas[index].getPosterImg()) : AssetImage('assets/img/no-image.jpg') ,
                  placeholder: AssetImage('assets/img/loading.gif'),
                  fit: BoxFit.fill,
                ),
              )
            ),
          );
          
          
          },
         // pagination: new SwiperPagination(),
         // control: new SwiperControl(),
          itemCount: peliculas.length,
          itemWidth: _screenSize.width * 0.6,
          itemHeight: _screenSize.height * 0.45,
          layout: SwiperLayout.STACK,
  ),
    );
  }
}