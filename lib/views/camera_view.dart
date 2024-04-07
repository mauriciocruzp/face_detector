import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:face_detector/controllers/scan_controller.dart';

class CameraView extends StatelessWidget {
  const CameraView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            "Face detector",
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20.0),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey,
                  width: 1.0,
                ),
              ),
            ),
          ),
        ),
      ),
      body: GetBuilder<ScanController>(
        init: ScanController(),
        builder: (controller) {
          return Stack(
            children: [
              controller.isCameraInitialized.value
                  ? Align(
                      alignment: Alignment.topCenter,
                      child: ClipRRect(
                        child: SizedOverflowBox(
                          size:
                              Size(screenWidth, screenHeight), // aspect is 1:1
                          alignment: Alignment.topCenter,
                          child: CameraPreview(controller.cameraController),
                        ),
                      ),
                    )
                  : Container(
                      width: MediaQuery.of(context).size.width,
                      height: 682,
                      color: Colors.black,
                    ),
              controller.label == "mauricio"
                  ? Center(
                      child: Container(
                        color: Colors.transparent,
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Text(
                                "Persona detectada: ${controller.label.capitalizeFirst}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            controller.weatherRequested
                                ? Center(
                                    child: Text(
                                      "Temperatura: ${controller.weatherRequested ? controller.weather : const CircularProgressIndicator()} °C",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  )
                                : const CircularProgressIndicator(),
                          ],
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ],
          );
        },
      ),
      floatingActionButton: Container(
        width: 100.0,
        height: 100.0,
        margin: const EdgeInsets.only(bottom: 70.0),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                width: 90.0,
                height: 90.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2.0),
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: 70.0,
                height: 70.0,
                child: GetBuilder<ScanController>(
                  init: ScanController(),
                  builder: (controller) {
                    return FloatingActionButton(
                      onPressed: () {
                        if (controller.isCameraInitialized.value) {
                          controller.stopCamera();
                          controller.label = "";
                        } else {
                          controller.initCamera();
                        }
                      },
                      backgroundColor: Colors.white,
                      shape: const CircleBorder(),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
