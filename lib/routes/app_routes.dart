import 'package:get/get.dart';
import 'package:cocoa_sense/screen/splash_screen.dart';
import 'package:cocoa_sense/screen/welcome_screen.dart';
import 'package:cocoa_sense/screen/main_screen.dart';
import 'package:cocoa_sense/screen/home_screen.dart';
import 'package:cocoa_sense/screen/map_screen.dart';
import 'package:cocoa_sense/screen/camera_scan_screen.dart';
import 'package:cocoa_sense/screen/monitoring_screen.dart';
import 'package:cocoa_sense/screen/photo_result_screen.dart';
import 'package:cocoa_sense/screen/ai_detection_loading_screen.dart';
import 'package:cocoa_sense/screen/ai_result_screen.dart';
import 'package:cocoa_sense/screen/detection_history_screen.dart';
import 'package:cocoa_sense/screen/detection_detail_screen.dart';
import 'package:cocoa_sense/screen/login_screen.dart';

class AppRoutes {
  static const splash = '/';
  static const welcome = '/welcome';
  static const login = '/login';
  static const main = '/main';
  static const home = '/home';
  static const map = '/map';
  static const camera = '/camera';
  static const monitoring = '/monitoring';
  static const photoResult = '/photo-result';
  static const aiLoading = '/ai-loading';
  static const aiResult = '/ai-result';
  static const history = '/history';
  static const detectionDetail = '/detection-detail';
}

class AppPages {
  static final routes = [
    GetPage(name: AppRoutes.splash, page: () => const SplashScreen()),
    GetPage(name: AppRoutes.welcome, page: () => const WelcomeScreen()),
    GetPage(name: AppRoutes.login, page: () => LoginScreen()),
    GetPage(name: AppRoutes.main, page: () => const MainScreen()),
    GetPage(name: AppRoutes.home, page: () => const HomeScreen()),
    GetPage(name: AppRoutes.map, page: () => const MapScreen()),
    GetPage(name: AppRoutes.camera, page: () => const CameraScanScreen()),
    GetPage(name: AppRoutes.monitoring, page: () => const MonitoringScreen()),
    GetPage(name: AppRoutes.photoResult, page: () => const PhotoResultScreen()),
    GetPage(
      name: AppRoutes.aiLoading,
      page: () => const AIDetectionLoadingScreen(),
    ),
    GetPage(name: AppRoutes.aiResult, page: () => const AIResultScreen()),
    GetPage(
      name: AppRoutes.history,
      page: () => const DetectionHistoryScreen(),
    ),
    GetPage(
      name: AppRoutes.detectionDetail,
      page: () => const DetectionDetailScreen(),
    ),
  ];
}
