import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wallpaper_app/data/data.dart';
import 'package:wallpaper_app/models/categories_model.dart';
import 'package:wallpaper_app/models/wallpaper_model.dart';
import 'package:wallpaper_app/widgets/widget.dart';
class Category extends StatefulWidget {
  final String categoryName;
  Category({this.categoryName});
  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  int noOfImageToLoad = 50;
  getSearchWallPaper(String query)async{


    var response=await http.get("https://api.pexels.com/v1/search?query=$query&per_page=30&page=1",headers: {
      "Authorization":apiKey
    });
    Map<String, dynamic> jsonData = jsonDecode(response.body);
    jsonData["photos"].forEach((element){
      //print(element);
      WallpaperModel wallpaperModel =new WallpaperModel();
      wallpaperModel = WallpaperModel.fromMap(element);
      wallpapers.add(wallpaperModel);

    });
    setState(() {

    });
  }
  List<CategoriesModel> categories = new List();
  List<WallpaperModel> wallpapers = new List();

  @override
  void initState(){
    getSearchWallPaper(widget.categoryName);

    super.initState();
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
