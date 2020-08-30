import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';


class ImageView extends StatefulWidget {
  final String imgUrl;


  ImageView( {@required this.imgUrl});
  @override
  _ImageViewState createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  var imgPath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Hero(
            tag: widget.imgUrl,
            child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Image.network(widget.imgUrl,fit: BoxFit.cover,)),
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.bottomCenter,

            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children:<Widget>[
                GestureDetector(
                  onTap: (){
                    _save();
                  },
                  child: Container(
                      width: MediaQuery.of(context).size.width/2,
                      decoration: BoxDecoration(gradient: LinearGradient(
                        colors: [
                          Color(0x36FFFFFF),
                          Color(0x0FFFFFFF)
                        ]
                      ),

                        border: Border.all(color: Colors.white70,width: 1),
                        borderRadius: BorderRadius.circular(30)
                      ),
                        child:
                        Column(
                          children: <Widget>[
                              Container(

                                child:Column(children: <Widget>[
                                  Text("Set Wallpaper",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color:Colors.white),),
                                  Text("Image will be saved in Gallery",style: TextStyle(fontSize: 8,color:Colors.white),)
                                ],) ,
                              ),

                    ],

                  ),

              ),
                ),
            ],
            ),

          ),
          Text("Cancel", style: TextStyle(color: Colors.white),textAlign: TextAlign.end,),
          SizedBox(height: 50)
        ],
      ),
    );
  }
  _save() async {
    await _askPermission();
    var response = await Dio().get(widget.imgUrl,
        options: Options(responseType: ResponseType.bytes));
    final result =
    await ImageGallerySaver.saveImage(Uint8List.fromList(response.data));
    print(result);
    Navigator.pop(context);
  }

  _askPermission() async {
    if (Platform.isIOS) {
      /*Map<PermissionGroup, PermissionStatus> permissions =
          */await PermissionHandler()
          .requestPermissions([PermissionGroup.photos]);
    } else {
      /* PermissionStatus permission = */await PermissionHandler()
          .checkPermissionStatus(PermissionGroup.storage);
    }
  }
}


