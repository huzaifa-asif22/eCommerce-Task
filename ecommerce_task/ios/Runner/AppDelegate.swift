import UIKit
import Flutter

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let deviceInfoChannel = FlutterMethodChannel(name: "device_info",
                                                binaryMessenger: controller.binaryMessenger)
    deviceInfoChannel.setMethodCallHandler({
      (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      // This method is invoked on the UI thread.
      guard call.method == "getDeviceInfo" else {
        result(FlutterMethodNotImplemented)
        return
      }
      self.getDeviceInfo(result: result)
    })

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func getDeviceInfo(result: FlutterResult) {
    let device = UIDevice.current
    let deviceInfo: [String: String] = [
      "Device Model": device.model,
      "Device Name": device.name,
      "System Name": device.systemName,
      "System Version": device.systemVersion,
      "Identifier": device.identifierForVendor?.uuidString ?? "Unknown"
    ]
    result(deviceInfo)
  }
}