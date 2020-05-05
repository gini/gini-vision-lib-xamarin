using System;
using System.Linq;
using Binding;
using Foundation;
using Xamarin.Forms;

[assembly: Dependency(typeof(GVLXamarinFormsExample.iOS.GiniVisionLib))]
namespace GVLXamarinFormsExample.iOS
{
    public class GVLDelegate : NSObject, IGVLProxyDelegate
    {

        public UIKit.UIViewController gvlViewController;

        public void GiniVisionAnalysisDidFinishWithoutResults(bool showingNoResultsScreen)
        {
            Console.WriteLine("GVL finished without results.");
        }

        public void GiniVisionAnalysisDidFinishWithResult(AnalysisResultProxy result)
        {
            Console.WriteLine("Extractions returned:");

            foreach (ExtractionProxy extraction in result.Extractions)
            {
                Console.WriteLine("Entity: " + extraction.Entity);
                Console.WriteLine("Name: " + extraction.Name);
                Console.WriteLine("Value: " + extraction.Value);
                Console.WriteLine("");
            }

            gvlViewController.DismissViewController(true, null);
        }

        public void GiniVisionDidCancelAnalysis()
        {
            Console.WriteLine("GVL cancelled");
        }
    }

    public class GiniVisionLib: IGiniVisionLib
    {

        private readonly GVLProxy gvlProxy;
        private readonly GVLDelegate gvlDelegate;

        public GiniVisionLib()
        {
            gvlDelegate = new GVLDelegate();
            gvlProxy = new GVLProxy("<domain>", "<id>", "<key>", gvlDelegate);
        }

        public void Start()
        {
            Console.WriteLine("Start");

            UIKit.UIViewController gvlViewController = gvlProxy.ViewController;
            gvlDelegate.gvlViewController = gvlViewController;

            GetTopViewController().ShowViewController(gvlViewController, null);
        }

        private UIKit.UIViewController GetTopViewController()
        {
            var window = UIKit.UIApplication.SharedApplication.KeyWindow;
            var vc = window.RootViewController;
            while (vc.PresentedViewController != null)
                vc = vc.PresentedViewController;

            if (vc is UIKit.UINavigationController navController)
                vc = navController.ViewControllers.Last();

            return vc;
        }
    }
}
