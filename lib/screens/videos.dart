import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'viewvideos.dart';

final Directory _videoDir =
  new Directory('/storage/emulated/0/WhatsApp/Media/.Statuses');


class VideoScreen extends StatefulWidget {
  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  @override
  void initState(){
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    if (!Directory('${_videoDir.path}').existsSync()) {
      return Container(
        padding: EdgeInsets.only(bottom: 60.0),
        child: Center(child: Text(
          "Install WhatsApp\nYour Friend's Status Will Show Here",
          style: TextStyle(fontSize: 18.0),
        ),),
      );
    } else{
      var videoList = _videoDir.listSync().map((item) => item.path).where((item)=>item.endsWith(".mp4")).toList(growable: false);
      if (videoList.length > 0){
        return Container(
          padding: EdgeInsets.only(bottom: 60.0),
          child: StaggeredGridView.countBuilder(
            itemCount: videoList.length,
            crossAxisCount: 4, 
            itemBuilder: (context, index) {
              String vidPath = videoList[index];
              return Material(
                elevation: 8.0,
                borderRadius: BorderRadius.all(Radius.circular(8)),
                child: InkWell(
                  onTap: (){
                    Navigator.push(
                      context, MaterialPageRoute(builder: 
                      (context)=> new ViewVideos(vidPath)));
                  },
                  child: Hero(
                    tag: vidPath,
                    child: Image.file(
                      File(vidPath),
                      fit: BoxFit.cover,
                    ),
                  )
                )
              );
            }, 
            staggeredTileBuilder: (i) => 
              StaggeredTile.count(2, i.isEven ? 2 : 3),
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,),
        );
      }else{
        return Scaffold(
          body: Center(
            child: Container(
              padding: EdgeInsets.only(bottom: 60.0),
              child: Text(
                'No Video Found!', style: TextStyle(
                  fontSize: 18.0
                ),
              )
            ),
          )
        );
      }
    }
  }
}