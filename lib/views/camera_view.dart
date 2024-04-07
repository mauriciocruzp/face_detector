import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:face_detector/controllers/scan_controller.dart';

class CameraView extends StatelessWidget {
  const CameraView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            "Face detector",
            style: TextStyle(fontWeight: FontWeight.w500),
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
          return Column(
            children: [
              Expanded(
                child: controller.isCameraInitialized.value
                    ? Center(
                      child: ClipRRect(
                        child: SizedOverflowBox(
                          size: const Size(300, 300), // aspect is 1:1
                          alignment: Alignment.center,
                          child: CameraPreview(controller.cameraController),
                        ),
                      ),
                    )
                    : const Image(image: AssetImage('assets/face-id.png')),
              ),
              SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    controller.label == "mauricio"
                        ? Column(
                          children: [
                            SizedBox(
                                width: double.infinity,
                                child: Center(
                                  child: Text(
                                    "Persona detectada: ${controller.label}\n"
                                    "Profesion: estudiante\n"
                                    "Edad: 20 años\n"
                                    "Altura: 1.70 m\n",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            controller.weatherRequested ?
                            SizedBox(
                                width: double.infinity,
                                child: Center(
                                  child: Text(
                                    "La temperatura es ${ controller.weatherRequested ? controller.weather : const CircularProgressIndicator()} °C",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              )
                              : const CircularProgressIndicator(),
                          ],
                        )
                        : const SizedBox(
                            width: double.infinity,
                            child: Center(
                              child: Text(
                                "Persona no detectada",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (controller.isCameraInitialized.value) {
                      controller.stopCamera();
                      controller.label = "";
                    } else {
                      controller.initCamera();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: controller.isCameraInitialized.value
                        ? Colors.red
                        : Colors.blue,
                  ),
                  child: Text(controller.isCameraInitialized.value
                      ? 'Desactivar cámara'
                      : 'Empezar a detectar'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
