using System;
using System.Collections.Generic;
using Android.Content;
using Android.OS;
using Java.Interop;
using Net.Gini.Android.Vision;
using Net.Gini.Android.Vision.Camera;
using Net.Gini.Android.Vision.Network;
using Net.Gini.Android.Vision.Network.Model;
using Xamarin.Forms;

[assembly: Dependency(typeof(GVLXamarinFormsExample.Droid.GiniVisionLib))]
namespace GVLXamarinFormsExample.Droid
{
    public class GiniVisionLib: IGiniVisionLib
    {
        private readonly GiniVisionDefaultNetworkService giniNetworkService;
        private readonly GiniVisionDefaultNetworkApi giniNetworkApi;

        private Dictionary<string, GiniVisionSpecificExtraction> extractions;

        public GiniVisionLib()
        {
            // Create the default network service instance which talks to the Gini API to upload images and pdfs and downloads the extractions
            giniNetworkService = GiniVisionDefaultNetworkService.InvokeBuilder(Forms.Context)
                .SetClientCredentials("myClientId", "myClientSecret", "myEmailDomain")
                .Build();

            // Create the default network api instance which allows easy upload of extraction feedback
            giniNetworkApi = GiniVisionDefaultNetworkApi.InvokeBuilder()
                .WithGiniVisionDefaultNetworkService(giniNetworkService)
                .Build();

            // Clean up existing instance of the GiniVision singleton
            if (GiniVision.HasInstance)
            {
                GiniVision.Cleanup(Forms.Context);
            }

            // Create a GiniVision singleton instance to configure the Gini Vision Library

            GiniVision.NewInstance()
               .SetGiniVisionNetworkService(giniNetworkService)
               .SetGiniVisionNetworkApi(giniNetworkApi)
               .SetMultiPageEnabled(true)
               .SetQRCodeScanningEnabled(false) // Requires Google Play Services Vision and I couldn't get it to work...
               .SetFlashButtonEnabled(true)
               .SetDocumentImportEnabledFileTypes(DocumentImportEnabledFileTypes.PdfAndImages)
               .Build();
        }

        public void Start()
        {
           var activity = (MainActivity)Forms.Context;

            activity.ActivityResult += OnActivityResult;

            // CameraActivity is the entry point and needs to be launched for result
            // IMPORTANT: request camera permission before starting the CameraActivity
            var intent = new Intent(activity, typeof(CameraActivity));

            activity.StartActivityForResult(intent, 42);
        }

        private void OnActivityResult(int requestCode, Android.App.Result resultCode, Intent data)
        {
            Android.Util.Log.Debug("gvl", $"resultCode: {resultCode}");

            if (data != null)
            {
                // Retrieve the extractions from the result data
                Bundle extractionsBundle = data.GetBundleExtra(CameraActivity.ExtraOutExtractions);
                if (extractionsBundle != null)
                {
                    extractions = new Dictionary<string, GiniVisionSpecificExtraction>();

                    foreach (var key in extractionsBundle.KeySet())
                    {
                        GiniVisionSpecificExtraction extraction = (GiniVisionSpecificExtraction)extractionsBundle.GetParcelable(key);

                        extractions.Add(key, extraction);

                        Android.Util.Log.Debug("gvl", $"extraction: {extraction.Name} = {extraction.Value}");

                    }

                    // Send feedback after the user has seen and potentially modified the extractions
                    sendFeedback();
                }
            }

            var activity = (MainActivity)Forms.Context;

            activity.ActivityResult -= OnActivityResult;
        }

        private void sendFeedback()
        {
            // Assuming the users is shown the amountToPay and the iban extractions
            Dictionary<string, GiniVisionSpecificExtraction> userVisibleExtractions = new Dictionary<string, GiniVisionSpecificExtraction>();
            userVisibleExtractions.Add("amountToPay", extractions["amountToPay"]);
            userVisibleExtractions.Add("iban", extractions["iban"]);

            // The user found the amountToPay to be wrong and entered 41.99 Euro
            // We need to update the amountToPay extraction's value accordingly
            userVisibleExtractions["amountToPay"].Value = "41.99:EUR";

            // Now we can send feedback for the user-visible extractions
            // IMPORTANT: send feedback only for extractions the user has seen
            giniNetworkApi.SendFeedback(userVisibleExtractions, new SendFeedbackCallback());
        }

        private class SendFeedbackCallback : Java.Lang.Object, IGiniVisionNetworkCallback
        {
            public void Success(Java.Lang.Object p0)
            {
                Android.Util.Log.Debug("gvl", "Feedback sending succeeded");
            }

            public void Failure(Java.Lang.Object p0)
            {
                Error error = (Error)p0;
                Android.Util.Log.Debug("gvl", $"Feedback sending failed: {error}");
            }

            public void Cancelled()
            {
                Android.Util.Log.Debug("gvl", "Feedback sending cancelled");
            }
        }
    }
}
