import 'dart:typed_data';
import 'dart:math'; // for Point<int>
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // for WriteBuffer
import 'package:camera/camera.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:ui' as ui;




class ARTryOnScreen extends StatefulWidget {
  const ARTryOnScreen({super.key});

  @override
  State<ARTryOnScreen> createState() => _ARTryOnScreenState();
}

class _ARTryOnScreenState extends State<ARTryOnScreen> {
  late CameraController _cameraController;
  bool _isDetecting = false;
  List<Face> _faces = [];

  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableContours: true,
      enableLandmarks: true,
    ),
  );

  String _selectedFilter = 'lipstick';

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final camera = cameras.firstWhere(
          (cam) => cam.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );

    _cameraController = CameraController(
      camera,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    await _cameraController.initialize();
    await _cameraController.startImageStream(_processImage);
    setState(() {});
  }

  Future<void> _processImage(CameraImage image) async {
    if (_isDetecting) return;
    _isDetecting = true;

    try {
      final bytes = image.planes.fold<Uint8List>(
        Uint8List(0),
            (prev, plane) => Uint8List.fromList([...prev, ...plane.bytes]),
      );

      final inputImage = InputImage.fromBytes(
        bytes: bytes,
        metadata: InputImageMetadata(
          size: Size(image.width.toDouble(), image.height.toDouble()),
          rotation: InputImageRotation.rotation0deg,
          format: InputImageFormat.nv21,
          bytesPerRow: image.planes.first.bytesPerRow,
        ),
      );

      final faces = await _faceDetector.processImage(inputImage);
      setState(() {
        _faces = faces;
      });
    } catch (e) {
      debugPrint('Face detection error: $e');
    } finally {
      _isDetecting = false;
    }
  }

  @override
  void dispose() {
    if (!kIsWeb) {
      _cameraController.dispose();
      _faceDetector.close();
    }
    super.dispose();
  }

  Widget _buildFilterPainter() {
    return CustomPaint(
      painter: FaceFilterPainter(_faces, _selectedFilter),
    );
  }

  Widget _buildFilterCarousel() {
    final filters = ['lipstick', 'eyeliner', 'blush'];
    return Positioned(
      bottom: 30,
      left: 0,
      right: 0,
      child: SizedBox(
        height: 90,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: filters.length,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemBuilder: (_, index) {
            final filter = filters[index];
            final isSelected = _selectedFilter == filter;
            return GestureDetector(
              onTap: () => setState(() => _selectedFilter = filter),
              child: Container(
                width: 90,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.pink : Colors.black54,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white),
                ),
                alignment: Alignment.center,
                child: Text(
                  filter.toUpperCase(),
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Text(
            'AR Try-On is only supported on Mobile (Android/iOS).',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    if (!_cameraController.value.isInitialized) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          CameraPreview(_cameraController),
          _buildFilterPainter(),
          _buildFilterCarousel(),
        ],
      ),
    );
  }
}

class FaceFilterPainter extends CustomPainter {
  final List<Face> faces;
  final String filter;

  FaceFilterPainter(this.faces, this.filter);

  Offset _convert(Point<int> point) => Offset(point.x.toDouble(), point.y.toDouble());

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (final face in faces) {
      final landmarks = face.landmarks;

      if (filter == 'lipstick') {
        final left = landmarks[FaceLandmarkType.leftMouth]?.position;
        final right = landmarks[FaceLandmarkType.rightMouth]?.position;
        final bottom = landmarks[FaceLandmarkType.bottomMouth]?.position;
        if (left != null && right != null && bottom != null) {
          paint.color = Colors.redAccent.withOpacity(0.5);
          final lipRect = Rect.fromPoints(_convert(left), _convert(right)).inflate(10);
          canvas.drawOval(lipRect, paint);
        }
      }

      if (filter == 'eyeliner') {
        final leftEye = landmarks[FaceLandmarkType.leftEye]?.position;
        final rightEye = landmarks[FaceLandmarkType.rightEye]?.position;
        paint.color = Colors.deepPurple.withOpacity(0.5);
        if (leftEye != null) canvas.drawCircle(_convert(leftEye), 8, paint);
        if (rightEye != null) canvas.drawCircle(_convert(rightEye), 8, paint);
      }

      if (filter == 'blush') {
        final leftCheek = landmarks[FaceLandmarkType.leftCheek]?.position;
        final rightCheek = landmarks[FaceLandmarkType.rightCheek]?.position;
        paint.color = Colors.pinkAccent.withOpacity(0.4);
        if (leftCheek != null) canvas.drawCircle(_convert(leftCheek), 20, paint);
        if (rightCheek != null) canvas.drawCircle(_convert(rightCheek), 20, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant FaceFilterPainter oldDelegate) {
    return oldDelegate.faces != faces || oldDelegate.filter != filter;
  }
}
