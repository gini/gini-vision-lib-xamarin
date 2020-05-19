Gini Vision Library Xamarin Examples and Bindings
=================================================

This repository contains projects to help you use the Android and iOS Gini Vision Libraries with Xamarin.

### Example Projects

The `GVLXamarinFormsExample` project shows how to use our bindings libraries in a Xamarin.Forms project.

Android
-------

To use the Android Gini Vision Library you need to add the DLLs created by the `GVLXamarinAndroid` and `GVLNetworkingXamarinAndroid` bindings libraries to your Xamarin project.

For using the Gini Vision Library please refer ot our [documentation](http://developer.gini.net/gini-vision-lib-android/html/index.html) and the `screenapiexample` or `componentapiexample` projects in our [repository](https://github.com/gini/gini-vision-lib-android). We also have a standalone example app [here](https://github.com/gini/gini-vision-lib-android-example).

### Bindings Libraries

The Gini Vision Library for Android consists of the main library and a default networking layer implementation. The main library is 
bound with the `GVLXamarinAndroid` bindings library and the networking layer implementation with the `GVLNetworkingXamarinAndroid` 
bindings library.

The networking bindings library requires additional bindings which are provided by `GiniAPISDKXamarinAndroid` and `TrustKitXamarin`.

### Troubleshooting

* `"No resource found that matches the given name"` errors: set the `AndroidUseAapt2` flag to `false` in your csproj configuration.
* When building `GVLXamarinAndroid` you encounter an error related to `OnProceedToAnalysisScreenHandler`: just delete the line the error points to in order to fix the duplicate definition.
* If you enable QR Code scanning and get `Failed resolution of: Lcom/google/android/gms/vision/barcode/BarcodeDetector$Builder;` or similar, then add the following NuGet packages to your Android platform project: `Xamarin.GooglePlayServices.Base`, `Xamarin.GooglePlayServices.Basement` and `Xamarin.GooglePlayServices.Vision`.

iOS
---

GVL for iOS is provided as a DLL file called `GiniVision.iOS.dll` located in `GVLXamarinFormsExample/GVLXamarinFormsExample.iOS`. It needs to be added to your project as a reference.

The API for the iOS integration is provided through a proxy library (`GVLProxy`) and it's a limited version of what's available natively. Please contact Gini if you need to access any functionality that isn't exposed. Only the `Screen API` is supported at this point.

### Example app
In order to run the example app on iOS, first supply your `domain`, `id`, and `secret` in the `GiniVisionLib` class. Then you can run the app and test the extraction. The extractions are written to the console.

The example app is meant to provide a sample code to show how the Gini Vision Library can be used. Please see the `GiniVisionLib.cs` in the `GVLXamarinFromaExample.iOS` project to get you started.

### Prerequisits
In order to use the Gini Vision Library please ensure your project supplies the following:

* Keychan capability should be enabled in Entitlements.plist
* Camera Usage Description provided in the Info.plist
* Photo Library Usage Description provided in the Info.plist (if you want to enable loading photographs from the user's Photo app)

The app will crash at various points of execution if the above are not provided.

### Usage

Instantiate the `GVLProxy` and present the view controller accessible from the `ViewController` property:

```
GVLProxy gvlProxy = new GVLProxy(domain, id, secret, gvlConfiguration, gvlDelegate);
UIKit.UIViewController gvlViewController = gvlProxy.ViewController;
```

The `GVLProxy` initialiser takes your credentials (`domain`, `id`, and `secret`), a `GVLConfigurationProxy` instance, and a `IGVLProxyDelegate` instance. 

The `GVLConfigurationProxy` allows you to configure different aspects of GVL such as whether you want to display a flash 
toggle button, or what tint should the navigation bar have. Please refer to the example app to see the currently available options
and to the native documentation for explanation of the options.

Implement the `IGVLProxyDelegate` protocol in order to receive callbacks from GVL with extraction results or to be informed about lack of thereof.

### Troubleshooting
* The app crashes at various points without an informative error message. Please make sure that you have enabled all capabilities and provided all usage strings in your `Info.plist` file. 
