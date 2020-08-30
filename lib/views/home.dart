import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wallpaper_app/data/data.dart';
import 'package:wallpaper_app/models/categories_model.dart';
import 'package:wallpaper_app/models/wallpaper_model.dart';
import 'package:wallpaper_app/views/category.dart';
import 'package:wallpaper_app/views/search.dart';
import 'package:wallpaper_app/widgets/widget.dart';
import 'package:http/http.dart' as http;

import 'imageview.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int noOfImageToLoad = 50;
  getTrendingWallPapers()async{


    var response=await http.get("https://api.pexels.com/v1/curated?per_page=$noOfImageToLoad&page=1",headers: {
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
  TextEditingController  searchController = TextEditingController();
  @override
  void initState(){
    getTrendingWallPapers();
    categories=getCategories();
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
            children:
              <Widget>[

                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFE0F7FA),
                    borderRadius: BorderRadius.circular(30)
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  margin: EdgeInsets.symmetric(horizontal: 24),
                  child: Row(children: <Widget>[
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
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) => Search(
                                searchQuery: searchController.text
                            )
                        )
                        );
                      },
                        child: Container(
                            child: Icon(Icons.search)
                        )
                    )
                  ],
                  ),

                ),
                SizedBox(height: 16,),
                Container(
                  height: 80,
                  child: ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      itemBuilder: (context,index){
                        return CategoryTile(
                          title: categories[index].categoriesName,
                          imgUrl: categories[index].imgUrl,
                        );
                      }),
                ),

                wallPaperList(wallpapers: wallpapers, context:context),

              ]

          ),
        ),
      ),
    );
  }
}
class CategoryTile extends StatelessWidget {
  final String imgUrl,title;
  CategoryTile({@required this.imgUrl,@required this.title});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => Category(categoryName: title.toLowerCase(),)
        ));
      },
      child: Container(
        margin: EdgeInsets.only(right: 5),
        child: Stack(
          children: <Widget>[ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Image.network(imgUrl, height: 50,width: 100,fit: BoxFit.cover,),
          ),
          Container(
            decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius:BorderRadius.circular(8) ),

            height: 50,width: 100,
            alignment: Alignment.bottomCenter,
            child: Text(title, style: TextStyle(color: Colors.white),),
          )
          ],
        ),
      ),
    );
  }
}


