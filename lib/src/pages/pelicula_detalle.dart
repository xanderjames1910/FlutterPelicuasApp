import 'package:animate_do/animate_do.dart';
import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
// Local Imports
import 'package:peliculas/src/models/actores_model.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:peliculas/src/providers/peliculas_providers.dart';

class PeliculaDetalle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Pelicula pelicula = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      body: ColorfulSafeArea(
        color: Colors.white.withOpacity(0.4),
        overflowRules: OverflowRules.all(true),
        child: CustomScrollView(
          slivers: <Widget>[
            _crearAppbar(pelicula),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  SizedBox(height: 10.0),
                  _posterTitulo(context, pelicula),
                  _descripcion(pelicula),
                  _descripcion(pelicula),
                  _descripcion(pelicula),
                  _descripcion(pelicula),
                  _crearCasting(pelicula),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _crearAppbar(Pelicula pelicula) {
    return SliverAppBar(
      elevation: 2.0,
      centerTitle: true,
      backgroundColor: Colors.indigoAccent,
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        // titlePadding: EdgeInsets.only(left: 20.0),
        centerTitle: true,
        title: FadeIn(
          delay: Duration(milliseconds: 300),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              pelicula.title,
              maxLines: 2,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.white, fontSize: 16.0),
            ),
          ),
        ),
        background: FadeInImage(
          placeholder: AssetImage('assets/img/loading.gif'),
          image: NetworkImage(pelicula.getBackgroundImg()),
          fadeInDuration: Duration(milliseconds: 250),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _posterTitulo(BuildContext context, Pelicula pelicula) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Row(
          children: <Widget>[
            Hero(
              tag: pelicula.uniqueId,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Image(
                  image: NetworkImage(pelicula.getPosterImg()),
                  height: 150.0,
                ),
              ),
            ),
            SizedBox(width: 20.0),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  FadeIn(
                    delay: Duration(milliseconds: 300),
                    child: Text(
                      pelicula.title,
                      style: Theme.of(context).textTheme.headline6,
                      overflow: TextOverflow.clip,
                    ),
                  ),
                  SizedBox(height: 5.0),
                  FadeIn(
                    delay: Duration(milliseconds: 400),
                    child: Text(
                      pelicula.originalTitle,
                      style: Theme.of(context).textTheme.subtitle1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(height: 5.0),
                  FadeIn(
                    delay: Duration(milliseconds: 500),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.star_border),
                          SizedBox(width: 5.0),
                          Text(
                            pelicula.voteAverage.toString(),
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                        ]),
                  )
                ],
              ),
            )
          ],
        ));
  }

  Widget _descripcion(Pelicula pelicula) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: FadeIn(
          delay: Duration(milliseconds: 600),
          child: Text(
            pelicula.overview,
            // textAlign: TextAlign.justify,
          ),
        ));
  }

  Widget _crearCasting(Pelicula pelicula) {
    final peliProvider = new PeliculasProvider();

    return FutureBuilder(
      future: peliProvider.getCast(pelicula.id.toString()),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        if (snapshot.hasData) {
          return _crearActoresPageView(snapshot.data);
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _crearActoresPageView(List<Actor> actores) {
    return SizedBox(
      height: 200.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        controller: PageController(
          viewportFraction: 0.3,
          // initialPage: 1,
        ),
        itemCount: actores.length,
        itemBuilder: (context, i) => _actorTarjeta(actores[i]),
      ),
    );
  }

  Widget _actorTarjeta(Actor actor) {
    return Container(
      margin: EdgeInsets.only(left: 10.0),
      child: Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: FadeInImage(
              placeholder: AssetImage('assets/img/no-image.jpg'),
              image: NetworkImage(actor.getPhoto()),
              height: 150.0,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 5.0),
          Container(
            width: 110.0,
            child: Text(
              actor.name,
              maxLines: 2,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
