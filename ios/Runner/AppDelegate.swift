import Flutter
import UIKit
import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

  GMSServices.provideAPIKey("AIzaSyDdsNLP8JGRWBkvNNtNjENOcbUcDAbkL8Q")

    let controller = FlutterViewController()
    self.window?.rootViewController = controller
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
