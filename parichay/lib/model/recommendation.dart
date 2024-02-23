// ignore: import_of_legacy_library_into_null_safe
import 'dart:io';

import 'package:firebase_ml_model_downloader/firebase_ml_model_downloader.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class ModelDownloader {
  Interpreter? _interpreter;
  Future<void> downloadModel() async {
    try {
      FirebaseCustomModel model =
          await FirebaseModelDownloader.instance.getModel(
              'recommendation_places',
              FirebaseModelDownloadType.localModelUpdateInBackground,
              FirebaseModelDownloadConditions(
                iosAllowsCellularAccess:
                    true, // Customize network preferences as needed
                iosAllowsBackgroundDownloading: true,
                androidChargingRequired: false,
                androidWifiRequired: false,
                androidDeviceIdleRequired: false,
              ));

      // Check if customModel is not null before using it
      if (model != null) {
        // Download complete. You can use the local path of the model file.
        final localModelPath = model.file.path;
        print("Model downloaded successfully: $localModelPath ");

        // Instantiate a TensorFlow Lite interpreter:
        _interpreter = await Interpreter.fromAsset(localModelPath);

        // Use the interpreter for your recommendations logic:
        // ...
      } else {
        print("Model download returned null.");
      }
    } catch (error) {
      // Handle errors during model download
      print("Error downloading model: $error");
    }
  }

  Future<List<String>> runModelInference(List<double> inputData) async {
    if (_interpreter == null) {
      throw Exception("Model is not loaded. Call downloadModel() first.");
    }

    final outputData = List<double>.filled(10, 0);

    // Run inference with the input data:
    _interpreter!.run(inputData, outputData);

    // Convert the double values in the output list to strings
    List<String> stringOutput =
        outputData.map((value) => value.toString()).toList();

    return stringOutput;
  }

  void closeInterpreter() {
    _interpreter?.close();
  }
}
