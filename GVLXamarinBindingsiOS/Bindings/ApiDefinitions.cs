using System;
using Foundation;
using ObjCRuntime;
using UIKit;

namespace Binding
{
	// @interface AnalysisResultProxy : NSObject
	[BaseType (typeof(NSObject))]
	[DisableDefaultCtor]
	interface AnalysisResultProxy
	{
		// @property (readonly, copy, nonatomic) NSArray<UIImage *> * _Nonnull images;
		[Export ("images", ArgumentSemantic.Copy)]
		UIImage[] Images { get; }

		// @property (readonly, nonatomic, strong) ExtractionProxies * _Nonnull extractions;
		[Export ("extractions", ArgumentSemantic.Strong)]
		ExtractionProxies Extractions { get; }

		// -(instancetype _Nonnull)initWithExtractions:(ExtractionProxies * _Nonnull)extractions images:(NSArray<UIImage *> * _Nonnull)images __attribute__((objc_designated_initializer));
		[Export ("initWithExtractions:images:")]
		[DesignatedInitializer]
		IntPtr Constructor (ExtractionProxies extractions, UIImage[] images);
	}

	// @interface ExtractionProxies : NSObject
	[BaseType (typeof(NSObject))]
	[DisableDefaultCtor]
	interface ExtractionProxies
	{
		// @property (readonly, copy, nonatomic) NSArray<ExtractionProxy *> * _Nonnull extractions;
		[Export ("extractions", ArgumentSemantic.Copy)]
		ExtractionProxy[] Extractions { get; }
	}

	// @interface ExtractionProxy : NSObject
	[BaseType (typeof(NSObject))]
	[DisableDefaultCtor]
	interface ExtractionProxy
	{
		// @property (readonly, nonatomic, strong) BoxProxy * _Nullable box;
		[NullAllowed, Export ("box", ArgumentSemantic.Strong)]
		BoxProxy Box { get; }

		// @property (readonly, copy, nonatomic) NSString * _Nullable candidates;
		[NullAllowed, Export ("candidates")]
		string Candidates { get; }

		// @property (readonly, copy, nonatomic) NSString * _Nonnull entity;
		[Export ("entity")]
		string Entity { get; }

		// @property (copy, nonatomic) NSString * _Nonnull value;
		[Export ("value")]
		string Value { get; set; }

		// @property (copy, nonatomic) NSString * _Nullable name;
		[NullAllowed, Export ("name")]
		string Name { get; set; }

		// -(instancetype _Nonnull)initWithBox:(BoxProxy * _Nullable)box candidates:(NSString * _Nullable)candidates entity:(NSString * _Nonnull)entity value:(NSString * _Nonnull)value name:(NSString * _Nullable)name __attribute__((objc_designated_initializer));
		[Export ("initWithBox:candidates:entity:value:name:")]
		[DesignatedInitializer]
		IntPtr Constructor ([NullAllowed] BoxProxy box, [NullAllowed] string candidates, string entity, string value, [NullAllowed] string name);
	}

	// @interface GVLProxy_Swift_254 (ExtractionProxy)
	[Category]
	[BaseType (typeof(ExtractionProxy))]
	interface ExtractionProxy_GVLProxy_Swift_254
	{
	}

	// @interface BoxProxy : NSObject
	[BaseType (typeof(NSObject))]
	[DisableDefaultCtor]
	interface BoxProxy
	{
		// @property (readonly, nonatomic) double height;
		[Export ("height")]
		double Height { get; }

		// @property (readonly, nonatomic) double left;
		[Export ("left")]
		double Left { get; }

		// @property (readonly, nonatomic) NSInteger page;
		[Export ("page")]
		nint Page { get; }

		// @property (readonly, nonatomic) double top;
		[Export ("top")]
		double Top { get; }

		// @property (readonly, nonatomic) double width;
		[Export ("width")]
		double Width { get; }

		// -(instancetype _Nonnull)initWithHeight:(double)height left:(double)left page:(NSInteger)page top:(double)top width:(double)width __attribute__((objc_designated_initializer));
		[Export ("initWithHeight:left:page:top:width:")]
		[DesignatedInitializer]
		IntPtr Constructor (double height, double left, nint page, double top, double width);
	}

	// @interface GVLProxy : NSObject
	[BaseType (typeof(NSObject))]
	[DisableDefaultCtor]
	interface GVLProxy
	{
		// @property (readonly, nonatomic, strong) UIViewController * _Nonnull viewController;
		[Export ("viewController", ArgumentSemantic.Strong)]
		UIViewController ViewController { get; }

		// -(instancetype _Nonnull)initWithDomain:(NSString * _Nonnull)domain id:(NSString * _Nonnull)id secret:(NSString * _Nonnull)secret configuration:(GiniConfigurationProxy * _Nullable)configuration delegate:(id<GVLProxyDelegate> _Nonnull)delegate __attribute__((objc_designated_initializer));
		[Export ("initWithDomain:id:secret:configuration:delegate:")]
		[DesignatedInitializer]
		IntPtr Constructor (string domain, string id, string secret, [NullAllowed] GiniConfigurationProxy configuration, GVLProxyDelegate @delegate);
	}

	// @protocol GVLProxyDelegate
	[Protocol, Model (AutoGeneratedName = true)]
	interface GVLProxyDelegate
	{
		// @required -(void)giniVisionAnalysisDidFinishWithResult:(AnalysisResultProxy * _Nonnull)result sendFeedbackBlock:(void (^ _Nonnull)(ExtractionProxies * _Nonnull))sendFeedbackBlock;
		[Abstract]
		[Export ("giniVisionAnalysisDidFinishWithResult:sendFeedbackBlock:")]
		void GiniVisionAnalysisDidFinishWithResult (AnalysisResultProxy result, Action<ExtractionProxies> sendFeedbackBlock);

		// @required -(void)giniVisionAnalysisDidFinishWithoutResults:(BOOL)showingNoResultsScreen;
		[Abstract]
		[Export ("giniVisionAnalysisDidFinishWithoutResults:")]
		void GiniVisionAnalysisDidFinishWithoutResults (bool showingNoResultsScreen);

		// @required -(void)giniVisionDidCancelAnalysis;
		[Abstract]
		[Export ("giniVisionDidCancelAnalysis")]
		void GiniVisionDidCancelAnalysis ();
	}

	// @interface GiniConfigurationProxy : NSObject
	[BaseType (typeof(NSObject))]
	interface GiniConfigurationProxy
	{
		// @property (nonatomic) BOOL debugModeOn;
		[Export ("debugModeOn")]
		bool DebugModeOn { get; set; }

		// @property (nonatomic) enum GiniVisionImportFileTypesProxy fileImportSupportedTypes;
		[Export ("fileImportSupportedTypes", ArgumentSemantic.Assign)]
		GiniVisionImportFileTypesProxy FileImportSupportedTypes { get; set; }

		// @property (nonatomic) BOOL flashToggleEnabled;
		[Export ("flashToggleEnabled")]
		bool FlashToggleEnabled { get; set; }

		// @property (nonatomic) BOOL openWithEnabled;
		[Export ("openWithEnabled")]
		bool OpenWithEnabled { get; set; }

		// @property (nonatomic) BOOL qrCodeScanningEnabled;
		[Export ("qrCodeScanningEnabled")]
		bool QrCodeScanningEnabled { get; set; }

		// @property (nonatomic) BOOL multipageEnabled;
		[Export ("multipageEnabled")]
		bool MultipageEnabled { get; set; }

		// @property (nonatomic, strong) UIColor * _Nullable navigationBarItemTintColor;
		[NullAllowed, Export ("navigationBarItemTintColor", ArgumentSemantic.Strong)]
		UIColor NavigationBarItemTintColor { get; set; }

		// @property (nonatomic, strong) UIColor * _Nullable navigationBarTintColor;
		[NullAllowed, Export ("navigationBarTintColor", ArgumentSemantic.Strong)]
		UIColor NavigationBarTintColor { get; set; }

		// @property (nonatomic, strong) UIColor * _Nullable navigationBarTitleColor;
		[NullAllowed, Export ("navigationBarTitleColor", ArgumentSemantic.Strong)]
		UIColor NavigationBarTitleColor { get; set; }

		// @property (nonatomic, strong) UIFont * _Nullable navigationBarItemFont;
		[NullAllowed, Export ("navigationBarItemFont", ArgumentSemantic.Strong)]
		UIFont NavigationBarItemFont { get; set; }

		// @property (nonatomic, strong) UIFont * _Nullable navigationBarTitleFont;
		[NullAllowed, Export ("navigationBarTitleFont", ArgumentSemantic.Strong)]
		UIFont NavigationBarTitleFont { get; set; }
	}

	// @interface GVLProxy_Swift_313 (GiniConfigurationProxy)
	[Category]
	[BaseType (typeof(GiniConfigurationProxy))]
	interface GiniConfigurationProxy_GVLProxy_Swift_313
	{
	}

	// @interface GiniSDKProxy : NSObject
	[BaseType (typeof(NSObject))]
	[DisableDefaultCtor]
	interface GiniSDKProxy
	{
		// -(instancetype _Nonnull)initWithId:(NSString * _Nonnull)id secret:(NSString * _Nonnull)secret domain:(NSString * _Nonnull)domain __attribute__((objc_designated_initializer));
		[Export ("initWithId:secret:domain:")]
		[DesignatedInitializer]
		IntPtr Constructor (string id, string secret, string domain);

		// -(void)removeStoredCredentials;
		[Export ("removeStoredCredentials")]
		void RemoveStoredCredentials ();
	}
}
