import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'search.dart';
import 'package:http/http.dart' as http;
import 'likes.dart';


class AppColors {
  static const Color primaryColor = Color(0xFF1A2025);
  static const Color searchColor = Color(0xFF1E262C);
  static const Color buttonColor = Color(0xFF636AF6);
  static const Color smoke = Color(0xFF1E262C);
}



class DescriptionPage extends StatefulWidget {
  final int gameId;



  const DescriptionPage({Key? key, required this.gameId}) : super(key: key);

  @override
  _DescriptionPageState createState() => _DescriptionPageState();
}

class _DescriptionPageState extends State<DescriptionPage> {
  bool _liked = false;
  bool _whishlist = false;
  bool _showDescription = true;
  String _gameName = '';
  String _lightBackground = '';


  Future<String> fetchDescription(int gameId) async {
    final response = await http.get(Uri.parse('https://store.steampowered.com/api/appdetails?appids=$gameId'));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final description = json['$gameId']['data']['short_description'];
      final gameData = json["$gameId"]["data"];
      final lightBackground = gameData["background_raw"];
      final gameDetailsResponse = await http.get(Uri.parse(
          'https://store.steampowered.com/api/appdetails?appids=$gameId&cc=us&l=fr'));
      if (gameDetailsResponse.statusCode == 200) {
        final gameDetailsJson = jsonDecode(gameDetailsResponse.body);
        final gameName = gameDetailsJson['$gameId']['data']['name'];
        setState(() {
          _gameName = gameName;
          _lightBackground = lightBackground;
        });
      }
      return description;
    }
    else {
      // Si la requête a échoué, on affiche une erreur
      throw Exception('Failed to load game description');
    }
  }


  String _description = '';

  @override
  void initState() {
    super.initState();
    fetchDescription(widget.gameId).then((description) {
      setState(() {
        _description = description;
      });
    });
  }

  void _onLikeButtonPressed() {
    setState(() {
      _liked = !_liked;
    });

    if (_liked) {
      // Navigate to likes page and pass the game name as an argument
      Navigator.pop(context, _gameName);
    } else {
      // Handle the case when the user unlikes the game
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Détail du jeu',
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.primaryColor,
        actions: [
          IconButton(
            icon: _liked
                ? SvgPicture.asset('assets/vector_drawables/like_full.svg')
                : SvgPicture.asset('assets/vector_drawables/like.svg'),
            onPressed: _onLikeButtonPressed,
          ),
          SizedBox(width: 16),
          IconButton(
            icon: _whishlist
                ? SvgPicture.asset(
                'assets/vector_drawables/whishlist_full.svg')
                : SvgPicture.asset('assets/vector_drawables/whishlist.svg'),
            onPressed: () {
              setState(() {
                _whishlist = !_whishlist;
              });
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          Stack(
            children: [
              Container(
                child: Image.asset(
                  'assets/images/handgun.png',
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 270, right: 20, left: 20),
                alignment: Alignment.bottomCenter,
                child: ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    AppColors.smoke.withOpacity(0.8),
                    BlendMode.darken,
                  ),
                  child: Image.asset(
                    'assets/images/handgun.png',
                    fit: BoxFit.cover,
                    width: MediaQuery.of(context).size.width,
                  ),
                ),
              ),
              Positioned(
                bottom: 7,
                left: 20,
                child: Image.asset(
                  'assets/images/battlefield.png',
                  width: 110,
                  height: 110,
                ),
              ),
              Positioned(
                bottom: 70,
                left: 130,
                child: Wrap(
                  children: [
                    Text(
                      _gameName.split(' ').take(3).join(' '), // limit to 3 words
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              Positioned(
                bottom: 45,
                left: 130,
                child: Text(
    "Nom de l'éditeur",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        Container(
        margin: EdgeInsets.all(16),
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
            children: [
              Expanded(
                child: ElevatedButton(
                onPressed: () {
                setState(() {
                _showDescription = true;
                });
                },
                  style: ButtonStyle(
                  backgroundColor: _showDescription
                  ? MaterialStateProperty.all<Color>(
                  AppColors.buttonColor)
                      : MaterialStateProperty.all<Color>(
                  Colors.transparent),
                  side: MaterialStateProperty.all<BorderSide>(
                  BorderSide(
                  color: AppColors.buttonColor,
                  width: 1,
                  ),
                  ),
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                  EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  ),
                  ),
                  child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Text('DESCRIPTION'),
                    ),
                    ),
                    ),
                Expanded(
                  child: ElevatedButton(
                  onPressed: () {
                  setState(() {
                  _showDescription = false;
                  });
                  },
                  style: ButtonStyle(
                  backgroundColor: _showDescription
                  ? MaterialStateProperty.all<Color>(
                  Colors.transparent)
                      : MaterialStateProperty.all<Color>(
                  AppColors.buttonColor),
                  side: MaterialStateProperty.all<BorderSide>(
                    BorderSide(
                    color: AppColors.buttonColor,
                    width: 2,
                    ),
                  ),
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                  EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  ),
                  ),
                    child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child: Text('AVIS'),
                  ),
                  ),
                  ),
                  ],
                  ),
            if (_showDescription)
              Container(
                margin: EdgeInsets.only(top: 15.0),
                child: Text(
                  _description,
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              )
            else
              SizedBox(
                height: 240, // Remplacez cette valeur par la hauteur souhaitée
                child: ListView.builder(
                  itemCount: 7,
                  itemBuilder: (context, index) => Container(
                    color: AppColors.searchColor,
                    margin: EdgeInsets.only(top: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 28, top: 16, right: 16),
                              child: Row(
                                children: [
                                  Text(
                                    "Nom d'utilisateur",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                  SizedBox(width: 80),
                                  ...List.generate(5, (index) => Icon(Icons.star, color: Colors.orange, size: 16,)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Container(
                          margin: EdgeInsets.only(right: 35.0, bottom: 16.0, left: 28.0),
                          child: Text(
                            'Bacon ipsum dolor amet rump doner brisket corned beef tri-tip. Burgdoggen t-bone leberkas, tri-tip bacon beef',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        // Ajoutez ici votre code pour afficher les avis
                      ],
                    ),
                  ),
                ),
              ),





          ],
                  ),


        ),







    ],
      ),







    );
  }
}
