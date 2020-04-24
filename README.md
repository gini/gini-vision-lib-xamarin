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

### Known Issues

* QRCode scanning is not working. It requires Google's Play Services Vision, which we weren't able to get to work with our bindings library.

iOS
---

Work in progress.