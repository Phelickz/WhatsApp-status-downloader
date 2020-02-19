import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share/share.dart';
import 'package:status_downloader/screens/videos.dart';

import 'images.dart';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  int _storagePermissionCheck;
  Future<int> _storagePermissionChecker;

  Future<int> checkStoragePermission() async {
    // bool result = await SimplePermissions.checkPermission(Permission.ReadExternalStorage);
    PermissionStatus result = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.storage);
    print("Checking Storage Permission " + result.toString());
    setState(() {
      _storagePermissionCheck = 1;
    });
    if (result.toString() == 'PermissionStatus.denied') {
      return 0;
    } else if (result.toString() == 'PermissionStatus.granted') {
      return 1;
    } else {
      return 0;
    }
  }

  Future<int> requestStoragePermission() async {
    // PermissionStatus result = await SimplePermissions.requestPermission(Permission.ReadExternalStorage);
    Map<PermissionGroup, PermissionStatus> result =
        await PermissionHandler().requestPermissions([PermissionGroup.storage]);
    if (result.toString() == 'PermissionStatus.denied') {
      return 1;
    } else if (result.toString() == 'PermissionStatus.granted') {
      return 2;
    } else {
      return 1;
    }
  }

  @override
  void initState() {
    super.initState();
    _storagePermissionChecker = (() async {
      int storagePermissionCheckInt;
      int finalPermission;

      print("Initial Values of $_storagePermissionCheck");
      if (_storagePermissionCheck == null || _storagePermissionCheck == 0) {
        _storagePermissionCheck = await checkStoragePermission();
      } else {
        _storagePermissionCheck = 1;
      }
      if (_storagePermissionCheck == 1) {
        storagePermissionCheckInt = 1;
      } else {
        storagePermissionCheckInt = 0;
      }

      if (storagePermissionCheckInt == 1) {
        finalPermission = 1;
      } else {
        finalPermission = 0;
      }

      return finalPermission;
    })();
  }
  
  
  TabController _tabController;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      
       child: FutureBuilder(
          future: _storagePermissionChecker,
          builder: (context, status){
            if (status.connectionState == ConnectionState.done){
              if (status.hasData){
                if(status.data==1){
                  return Scaffold(
                    drawer: Drawer(),
                    appBar: AppBar(
                        bottom: TabBar(
                          controller:_tabController,
                          tabs: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(bottom: 5),
                              child: Text('Images',
                              style: TextStyle(
                                fontSize: 18
                              ),),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 5),
                              child: Text('Videos',
                              style: TextStyle(
                                fontSize: 18
                              ),),
                            )
                          ],
                        ),
                        backgroundColor: Colors.teal,
                        // leading: Icon(Icons.menu),
                        title: Text('Status saver'),
                        actions: <Widget>[
                          IconButton(
                            onPressed: (){
                                Share.share(
                    'check out my wa status downloader https://github.com/mastersam07/wa_status_saver',
                    subject: 'Look what I made!');
              },
                            icon: Icon(Icons.share),
                          ),
                          IconButton(
                            icon: Icon(Icons.help),
                            onPressed: (){},
                          )
                        ],
                    ),
                    body: Dashboard(),
                  );
                } else {
                  return Scaffold(
                    body: Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                        colors: [
                          Colors.lightBlue[100],
                          Colors.lightBlue[200],
                          Colors.lightBlue[300],
                          Colors.lightBlue[200],
                          Colors.lightBlue[100],
                        ],
                      )),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Text(
                                "Storage Permission Required",
                                style: TextStyle(fontSize: 20.0),
                              ),
                            ),
                            FlatButton(
                              padding: EdgeInsets.all(15.0),
                              child: Text(
                                "Allow Storage Permission",
                                style: TextStyle(fontSize: 20.0),
                              ),
                              color: Colors.indigo,
                              textColor: Colors.white,
                              onPressed: () {
                                setState(() {
                                  _storagePermissionChecker =
                                      requestStoragePermission();
                                });
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                }
              } else {
                return Scaffold(
                   body: Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      colors: [
                        Colors.lightBlue[100],
                        Colors.lightBlue[200],
                        Colors.lightBlue[300],
                        Colors.lightBlue[200],
                        Colors.lightBlue[100],
                      ],
                    )),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(
                              "Something went wrong.. Please uninstall and Install Again.",
                              style: TextStyle(fontSize: 20.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
            } else {
              return Scaffold(
                body: Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              );
            }
          }
          
          ),
    );
  }
}



class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: TabBarView(
        children: <Widget>[
          ImageScreen(),
          VideoScreen(),
        ],
      ),
    );
  }
}