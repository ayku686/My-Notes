//Here we write our loading screen
import 'dart:async';

import 'package:first_app/helpers/loading/loading_screen_controller.dart';
import 'package:flutter/material.dart';

class LoadingScreen{
  //Singleton
  factory LoadingScreen() => _shared;//When someone calls the factory constructor from outside it calls
  // _shared from below which in turn calls the Loading._sharedInstance() below it. So basically it's 3 layered
  static final LoadingScreen _shared = LoadingScreen._sharedInstance();
  LoadingScreen._sharedInstance();

  LoadingScreenController? controller;

  void show({
    required BuildContext context,
    required String text,
}){
    if(controller?.update(text) ?? false){
      return;
    }else{
      controller = showOverlay(
          context: context,
          text: text
      );
    }
  }
  void hide(){
    controller?.close();
    controller = null;
  }
  LoadingScreenController showOverlay({
    required BuildContext context,
    required String text
}){
    final _text = StreamController<String>();
    _text.add(text);
    final state = Overlay.of(context);
    final renderbox = context.findRenderObject() as RenderBox;
    final size = renderbox.size;
    final overlay = OverlayEntry(
        builder: (context){
          return Material(
            color: Colors.black.withAlpha(150),
            child: Center(
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: size.width * 0.8,//This indicates that our dialog can take a maximum of 80% of the screen
                  maxHeight: size.height * 0.8,
                  minWidth: size.width * 0.5,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:[
                        const SizedBox(height: 10),
                        const CircularProgressIndicator(),
                        const SizedBox(height: 20),
                        StreamBuilder(
                            stream: _text.stream,
                            builder:(context,snapshot){
                              if(snapshot.hasData){
                                return Text(
                                  snapshot.data as String,
                                  textAlign: TextAlign.center,
                                );
                              }
                              else{
                                return Container();
                              }
                            })
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
    state?.insert(overlay);
    return LoadingScreenController(close: (){
      _text.close();
      overlay.remove();
      return true;
    }, update: (text){
      _text.add(text);
      return true;
    }
    );
  }
}