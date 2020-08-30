import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:wallpaper_app/data/data.dart';
import 'package:wallpaper_app/models/wallpaper_model.dart';
import 'package:wallpaper_app/widgets/widget.dart';

class Search extends StatefulWidget {
  final String searchQuery;
  Search({this.searchQuery});
  @override
  _SearchState createState() => _SearchState();


}

class _SearchState extends State<Search> {
  TextEditingController  searchController = TextEditingController();
  int noOfImageToLoad = 50;
  List<WallpaperModel> wallpapers = new List();

  getSearchWallPaper(String searchQuery)async {
    var response = await http.get(
        "https://api.pexels.com/v1/search?query=$searchQuery&per_page=30&page=1",
        headers: {
          "Authorization": apiKey
        });
    Map<String, dynamic> jsonData = jsonDecode(response.body);
    jsonData["photos"].forEach((element) {
      //print(element);
      WallpaperModel wallpaperModel = new WallpaperModel();
      wallpaperModel = WallpaperModel.fromMap(element);
      wallpapers.add(wallpaperModel);
    });
    setState(() {

    });
    @override
    void initState() {
      getSearchWallPaper(widget.searchQuery);

      super.initState();
      searchController.text = widget.searchQuery;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: brandName(),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
            Container(
                    decoration: BoxDecoration(
                        color: Color(0xFFE0F7FA),
                      borderRadius: BorderRadius.circular(30)
                        ),
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  margin: EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: <Widget>[
                           Expanded(
                          child: TextField(
                            controller: searchController,
                            decoration: InputDecoration(
                                hintText: "search wallpaper",
                                border: InputBorder.none),
                          ),
                        ),
                        GestureDetector(
                              onTap: (){
                                      getSearchWallPaper(searchController.text);
                              },

                              )
                    ],
                    ),
                  ),
              SizedBox(height: 16,),
              wallPaperList(wallpapers: wallpapers, context:context),
    ]
    )
        ),
      )
    );
  }
}

