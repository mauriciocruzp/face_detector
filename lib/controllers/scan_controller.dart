import 'dart:convert';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

class ScanController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    initTFLite();
  }

  @override
  void onClose() {
    super.onClose();
    cameraController.dispose();
  }

  late CameraController cameraController;
  late List<CameraDescription> cameras;

  late CameraImage cameraImage;

  var isCameraInitialized = false.obs;
  var cameraCount = 0;

  var x, y, w, h = 0.0;
  var label = "";

  var weatherRequested = false;
  var weather = "";

  initCamera() async {
    if (await Permission.camera.request().isGranted) {
      cameras = await availableCameras();

      cameraController = CameraController(cameras[1], ResolutionPreset.max);

      await cameraController.initialize().then((value) {

        cameraController.startImageStream((image) {
          cameraCount++;
          if (cameraCount % 10 == 0) {
            cameraCount = 0;
            objectDetector(image);
          }
          update();
        });
      });

      isCameraInitialized(true);
      update();
    } else {
      if (kDebugMode) {
        print("Permission not granted");
      }
    }
  }

  initTFLite() async {
    await Tflite.loadModel(
      model: "assets/model.tflite",
      labels: "assets/labels.txt",
      isAsset: true,
      numThreads: 4,
      useGpuDelegate: false,
    );
  }

  stopCamera() {
    cameraController.stopImageStream();
    isCameraInitialized(false);
    label = "";
    update();
  }

  objectDetector(CameraImage image) async {
    var detector = await Tflite.runModelOnFrame(
      bytesList: image.planes.map((e) {
        return e.bytes;
      }).toList(),
      asynch: true,
      imageHeight: image.height,
      imageWidth: image.width,
      imageMean: 127.5,
      imageStd: 127.5,
      numResults: 2,
      rotation: 90,
      threshold: 0.9,
    );

    if (kDebugMode) {
      print(detector);
    }

    if (detector != null ) {

      var ourDetectedObject = detector.first;
      if (ourDetectedObject["confidence"] * 100 > 10) {
        label = ourDetectedObject["label"];
        if(label == "mauricio" && !weatherRequested) {
          weatherRequested = true;
          fetchWeather().then((value) {
            weather = value['current']['temperature_2m'].toString();
            update();
          });
        }
      }
    }
  }
}

Future<Map<String, dynamic>> fetchWeather() async {
  final response = await http.get(Uri.parse(
      'https://api.open-meteo.com/v1/forecast?latitude=16.7597300&longitude=-93.1130800&current=temperature_2m,wind_speed_10m&hourly=temperature_2m,relative_humidity_2m,wind_speed_10m'));
  if (response.statusCode == 200) {
    if (kDebugMode) {
      print(json.decode(response.body)['latitude']);
    }
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load weather data');
  }
}