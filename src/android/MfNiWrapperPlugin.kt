package cordova.plugin.MfNiWrapperPlugin

import ae.network.nicardmanagementsdk.api.models.input.NICardAttributes
import ae.network.nicardmanagementsdk.api.models.input.NIConnectionProperties
import ae.network.nicardmanagementsdk.api.models.input.NIDisplayAttributes
import ae.network.nicardmanagementsdk.api.models.input.NIInput
import ae.network.nicardmanagementsdk.api.models.input.NIPinFormType
import ae.network.nicardmanagementsdk.presentation.ui.set_pin.SetPinFragmentFromActivity
import android.content.Intent
import androidx.fragment.app.FragmentManager
import org.apache.cordova.CallbackContext
import org.apache.cordova.CordovaPlugin
import org.json.JSONArray
import java.util.concurrent.ExecutorService
import java.util.concurrent.Executors

class MfNiWrapperPlugin : CordovaPlugin() {

  private var callbackContext: CallbackContext? = null
  private var niInput: NIInput? = null
  private val threadPool: ExecutorService = Executors.newCachedThreadPool()

  override fun execute(
    action: String,
    args: JSONArray,
    callbackContext: CallbackContext
  ): Boolean {
    when (action) {
      "initializeSDK" -> {
        cordova.activity.runOnUiThread {
          threadPool.execute {
            initializeSDK(callbackContext)
          }
        }
        return true
      }
//      "setPinForm" -> {
//        cordova.activity.runOnUiThread{
//          threadPool.execute{
//            openSetPinForm(callbackContext)
//          }
//        }
//        return true
//      }
      "setPinForm" -> {
        cordova.activity.runOnUiThread{
          threadPool.execute{
            startMfNiWrapper(callbackContext)
          }
        }
        return true
      }
      else -> return false
    }
  }

  private fun startMfNiWrapper(callbackContext: CallbackContext) {
    val intent = Intent("cordova.plugin.MfNiWrapperPlugin.MfNiWrapperActivity")
    cordova.startActivityForResult(this, intent, 1)
  }

  private fun initializeSDK(callbackContext: CallbackContext) {
    this.callbackContext = callbackContext
    this.niInput = NIInput(
      bankCode = "MF3",
      cardIdentifierId = "FB1ABA5C-B58D-15BC-E054-00144FFA433E",
      cardIdentifierType = "cardGUID",
      connectionProperties = NIConnectionProperties(
        "https://api-uat.egy.network.global/sdk/v2",
        "eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICItNzBNYURtTkxYYW1OR294SGFLWjliM0V3TmdvQ1JOOW5HenlSSFZJN3ZjIn0.eyJleHAiOjE3MDcyMTA3MTksImlhdCI6MTcwNzIwODkxOSwianRpIjoiNjVjN2ZiYTItY2U1Zi00YjNhLTk1MWMtNTkxMjFiODQ4M2EzIiwiaXNzIjoiaHR0cHM6Ly9pZGVudGl0eS1ub25wcm9kLm5ldHdvcmsuZ2xvYmFsL2F1dGgvcmVhbG1zL05JLU5vblByb2QiLCJzdWIiOiI3M2Q5NDNhZi1mNjhjLTRjZTItOTM3OS02MjdjOTkzNDFhNzAiLCJ0eXAiOiJCZWFyZXIiLCJhenAiOiJjYmJiZmM2My01YzRmLTQ2ODgtOWFlNS03N2Y2YzExZDFkMjcxMDgzMTYiLCJzY29wZSI6InByb2ZpbGUgZW1haWwiLCJlbWFpbF92ZXJpZmllZCI6ZmFsc2UsImNsaWVudElkIjoiY2JiYmZjNjMtNWM0Zi00Njg4LTlhZTUtNzdmNmMxMWQxZDI3MTA4MzE2Iiwib3JnX2lkIjoiTUYzIiwicHJlZmVycmVkX3VzZXJuYW1lIjoic2VydmljZS1hY2NvdW50LWNiYmJmYzYzLTVjNGYtNDY4OC05YWU1LTc3ZjZjMTFkMWQyNzEwODMxNiJ9.gueWOrc2pdDzAV-ZmbPib2SlPHf84O-SLl8JjnyOGkKFQ-B2_4atMTXFlzGM1wAyLa2C53tdtsOS9SxZh2U1obqGXbT6s1JgJ2Hsid04V2-OJddv09RMSb55SBMoTRD9mjppeoI_zeMlI0Huavw_W4fWVr7dg-gijUgbCSWfrd-dN3VaF971uba8VyA4fN5GJtLp_khQAjsNtvAeUWUW0tMI4O7sXwWp2jcp6RNHr95wWOY_86W-X_KD55K7zLcS6JO730pT4R_uWRmp74HmdSm5JNeI50NaRU7DuvGfsXIrQJO9UjLYRfTII_JaNCXuT5OXz8fECby_SY_We6jAfg"
      ),
      displayAttributes = NIDisplayAttributes(
        cardAttributes = NICardAttributes(
          shouldHide = true,
        )
      )
    )

    cordova.activity.runOnUiThread {
      callbackContext.success("SDK initialized successfully")
    }
  }

//  private fun openSetPinForm(callbackContext: CallbackContext) {
//    cordova.activity.runOnUiThread {
////      val cardViewController = CardViewController(cordova.activity, callbackContext)
////      val niInput = niInput// ... (fill your NIInput data)
//      val pinLength = NIPinFormType.FOUR_DIGITS
//      try {
//        niInput?.let { SetPinFragmentFromActivity.newInstance(it, pinLength) }
//          ?.show(cordova.activity.supportFragmentManager, SetPinFragmentFromActivity.TAG)
//      } catch (e: Exception) {
//        println(e.message)
//        callbackContext.error("Error displaying SetPinFragment: ${e.message}")
//      }
//    }
//  }
  companion object {
    val niInput: NIInput? = NIInput(
      bankCode = "MF3",
      cardIdentifierId = "FB1ABA5C-B58D-15BC-E054-00144FFA433E",
      cardIdentifierType = "cardGUID",
      connectionProperties = NIConnectionProperties(
        "https://api-uat.egy.network.global/sdk/v2",
        "eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICItNzBNYURtTkxYYW1OR294SGFLWjliM0V3TmdvQ1JOOW5HenlSSFZJN3ZjIn0.eyJleHAiOjE3MDcyMTA3MTksImlhdCI6MTcwNzIwODkxOSwianRpIjoiNjVjN2ZiYTItY2U1Zi00YjNhLTk1MWMtNTkxMjFiODQ4M2EzIiwiaXNzIjoiaHR0cHM6Ly9pZGVudGl0eS1ub25wcm9kLm5ldHdvcmsuZ2xvYmFsL2F1dGgvcmVhbG1zL05JLU5vblByb2QiLCJzdWIiOiI3M2Q5NDNhZi1mNjhjLTRjZTItOTM3OS02MjdjOTkzNDFhNzAiLCJ0eXAiOiJCZWFyZXIiLCJhenAiOiJjYmJiZmM2My01YzRmLTQ2ODgtOWFlNS03N2Y2YzExZDFkMjcxMDgzMTYiLCJzY29wZSI6InByb2ZpbGUgZW1haWwiLCJlbWFpbF92ZXJpZmllZCI6ZmFsc2UsImNsaWVudElkIjoiY2JiYmZjNjMtNWM0Zi00Njg4LTlhZTUtNzdmNmMxMWQxZDI3MTA4MzE2Iiwib3JnX2lkIjoiTUYzIiwicHJlZmVycmVkX3VzZXJuYW1lIjoic2VydmljZS1hY2NvdW50LWNiYmJmYzYzLTVjNGYtNDY4OC05YWU1LTc3ZjZjMTFkMWQyNzEwODMxNiJ9.gueWOrc2pdDzAV-ZmbPib2SlPHf84O-SLl8JjnyOGkKFQ-B2_4atMTXFlzGM1wAyLa2C53tdtsOS9SxZh2U1obqGXbT6s1JgJ2Hsid04V2-OJddv09RMSb55SBMoTRD9mjppeoI_zeMlI0Huavw_W4fWVr7dg-gijUgbCSWfrd-dN3VaF971uba8VyA4fN5GJtLp_khQAjsNtvAeUWUW0tMI4O7sXwWp2jcp6RNHr95wWOY_86W-X_KD55K7zLcS6JO730pT4R_uWRmp74HmdSm5JNeI50NaRU7DuvGfsXIrQJO9UjLYRfTII_JaNCXuT5OXz8fECby_SY_We6jAfg"
      ),
      displayAttributes = NIDisplayAttributes(
        cardAttributes = NICardAttributes(
          shouldHide = true,
        )
      )
    )
    val callbackContext: CallbackContext? = null
    const val TAG = "MfNiWrapperPlugin"
  }

}


//class CardViewController(activity: AppCompatActivity, callbackContext: CallbackContext) : AppCompatActivity(), SetPinFragment.OnFragmentInteractionListener {
//  private var callbackContext: CallbackContext = callbackContext
//  private lateinit var niInput: NIInput
//  private val TAG = "CardViewController"
//  private var host : AppCompatActivity = activity
//
//  override fun onResume() {
//    super.onResume()
//    print(supportFragmentManager)
//    showSetPinForm(callbackContext, niInput, host.supportFragmentManager)
//  }
//
//  private fun showSetPinForm(callbackContext: CallbackContext, niInput: NIInput?, fragmentManager: FragmentManager) {
//    if (niInput == null) {
//      callbackContext.error("NIInput is null")
//      return
//    }
//    this.callbackContext = callbackContext
//    this.niInput = niInput
//    val pinLength: NIPinFormType = NIPinFormType.FOUR_DIGITS
//      try {
//        val dialog = SetPinFragmentFromActivity.newInstance(this.niInput, pinLength)
//        Log.d(TAG, "Using FragmentManager: $fragmentManager");
//        dialog.show(fragmentManager, SetPinFragmentFromActivity.TAG)
//      } catch (e: Exception) {
//        println(e.message)
//        callbackContext.error("Error displaying SetPinFragment: ${e.message}")
//      }
//  }
//
//
//  override fun onSetPinFragmentCompletion(response: SuccessErrorCancelResponse) {
//    response.isSuccess?.let {
//      // Handle success
//      callbackContext.success("Set Pin Form completed successfully: ${it.message}")
//    }
//    response.isError?.let {
//      // Handle error
//      callbackContext.error("Set Pin Form encountered an error: ${it.error} ${it.errorMessage}")
//    }
//    response.isCancelled?.let {
//      // Handle error
//      callbackContext.error("Set Pin Form encountered an error: ${it.cancelMessage}")
//    }
//  }
//}
