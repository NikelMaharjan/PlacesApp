import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:places/src/model/dashboard/places_model.dart';
import 'package:places/src/utils/image_helper.dart';
import 'package:places/src/utils/location_helper.dart';
import 'package:places/src/widgets/favourite_section.dart';
import 'package:places/src/widgets/map_input.dart';

class PlaceDetailViewScreen extends StatelessWidget {
  const PlaceDetailViewScreen({Key? key, required this.place}) : super(key: key);
  final PlaceModel place;
  final dummyText = """
  The name "Nepal" is first recorded in texts from the Vedic period of the Indian subcontinent, the era in ancient Nepal when Hinduism was founded, the predominant religion of the country.
  In the middle of the first millennium BC, Gautama Buddha, the founder of Buddhism, was born in Lumbini in southern Nepal.
  Parts of northern Nepal were intertwined with the culture of Tibet. The centrally located Kathmandu Valley is intertwined with the culture of Indo-Aryans, and was the seat of the prosperous Newar confederacy known as Nepal Mandala.
  The Himalayan branch of the ancient Silk Road was dominated by the valley's traders. The cosmopolitan region developed distinct traditional art and architecture. 
  By the 18th century, the Gorkha Kingdom achieved the unification of Nepal. The Shah dynasty established the Kingdom of Nepal and later formed an alliance with the British Empire, under its Rana dynasty of premiers.
  The country was never colonized but served as a buffer state between Imperial China and British India. Parliamentary democracy was introduced in 1951 but was twice suspended by Nepalese monarchs, in 1960 and 2005. The Nepalese Civil War in the 1990s and early 2000s resulted in the establishment of a secular republic in 2008, ending the world's last Hindu monarchy.
  """;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildHeaderImage(context),
          SliverList(delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 12),
                      Text("Near:${place.monument}"),
                      SizedBox(height: 12),
                      Text("${place.city}"),
                      SizedBox(height: 12),
                      Text("${place.address}"),
                      SizedBox(height: 12),
                      Text("${place.description}"),
                      SizedBox(height: 12),
                      _buildStaticImage(context),
                      SizedBox(height: 12),
                      Text(dummyText),
                      SizedBox(height: MediaQuery.of(context).size.height/10),

                    ],
                  ),
                );
              },
              childCount: 1
          ))
        ],
      ),
      bottomSheet: _buildButton(context),
    );
  }
  Widget _buildStaticImage(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 5,
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(),
      ),
      child: Image.network(
        LocationHelper.generateLocationPreviewImage(LatLng(place.latitude!, place.longitude!)),
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildHeaderImage(BuildContext context) {
    return SliverAppBar(
      floating: true,
      pinned: true,
      snap: true,
      flexibleSpace: Stack(
        children: [
          FlexibleSpaceBar(
            background: Image.network(
              getImage(place.image!),
              height:MediaQuery.of(context).size.height / 3 ,
              fit: BoxFit.cover,
            ),
            collapseMode: CollapseMode.pin,
            title: Text("${place.name}"),
          ),
          Positioned(child: FavoriteSection(id: place.sId!), right: 32, top: 32,)
        ],
      ),
      expandedHeight: MediaQuery.of(context).size.height / 3,
    );
  }
  Widget _buildButton(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0,bottom: 10),
      width: MediaQuery.of(context).size.width,
      child: ButtonTheme(
        minWidth: MediaQuery.of(context).size.width,
        child: ElevatedButton(
          onPressed:() {
            Navigator.of(context).push( MaterialPageRoute(
                builder: (_) {
                  return MapInput(
                      onMapTapped: (loc) {},
                      currentLocation: LatLng(place.latitude!, place.longitude!));
                },
                fullscreenDialog: true));

          },
          child: Text("View on Map"),
        ),
      ),
    );
  }

}