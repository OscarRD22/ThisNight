import 'package:cocoa_app/pages_cocoa/ScreenCocoaImageDetail.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../pages_cocoa/ScreenCocoaDayImages.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

//Tarjetas por dias de la galeria
//Container que envuelve ScrollGallery

Widget GalleryImages(BuildContext context) {
  return MasonryGridView.builder(
    physics: NeverScrollableScrollPhysics(),
    shrinkWrap: true,
    gridDelegate: const
        //Cambio el numero de filas
        SliverSimpleGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
    itemCount: 5,
    scrollDirection: Axis.vertical,
    crossAxisSpacing: 15,
    mainAxisSpacing: 15,
    itemBuilder: (context, index) {
      return GestureDetector(
        onTap: () {
          // ignore: unused_local_variable
          final route =
              MaterialPageRoute(builder: (context) => ScreenCocoaImageDetail());
//Argument pass idImage
          Navigator.pushNamed(context, "cocoaImageDetail", arguments: index);
        },
        child: Hero(
          tag: index,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              color: Colors.transparent,
            ),
          ),
        ),
      );
    },
  );
}

class DayText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Container(
        width: double.infinity,
        height: 80,
        //color: Colors.red,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Dissabte 11 de Novembre",
              //pictureFiles![index].dia,
              textAlign: TextAlign.center,
              style: GoogleFonts.leagueGothic(
                fontSize: 15,
                color: Colors.white,
                letterSpacing: .8,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.normal,
              ),
            ),
            Text(
              "Welcome to COCOA",
              //pictureFiles![index].tematica,
              textAlign: TextAlign.center,
              style: GoogleFonts.leagueGothic(
                fontSize: 35,
                color: Colors.white,
                letterSpacing: .8,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
