package cordova.plugin.MfNiWrapperPlugin

import ae.network.nicardmanagementsdk.api.interfaces.SuccessErrorCancelResponse
import ae.network.nicardmanagementsdk.api.models.input.NICardAttributes
import ae.network.nicardmanagementsdk.api.models.input.NIConnectionProperties
import ae.network.nicardmanagementsdk.api.models.input.NIDisplayAttributes
import ae.network.nicardmanagementsdk.api.models.input.NIInput
import ae.network.nicardmanagementsdk.api.models.input.NIPinFormType
import ae.network.nicardmanagementsdk.presentation.ui.set_pin.SetPinFragment
import ae.network.nicardmanagementsdk.presentation.ui.set_pin.SetPinFragmentFromActivity
import android.app.Dialog
import android.os.Bundle
import android.util.Log
import android.view.LayoutInflater
import android.widget.Button
import androidx.appcompat.app.AlertDialog
import androidx.appcompat.app.AppCompatActivity
import androidx.fragment.app.DialogFragment
import com.moneyfellows.mobileapp.stage.R
import cordova.plugin.MfNiWrapperPlugin.MfNiWrapperPlugin.Companion.TAG


class MfNiWrapperActivity : AppCompatActivity(), SetPinFragment.OnFragmentInteractionListener {

   private val niInput: NIInput =  NIInput(
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
   private val pinLength: NIPinFormType = NIPinFormType.FOUR_DIGITS

  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    setContentView(R.layout.activity_mf_ni_wrapper)
    val openDialogButton: Button = findViewById(R.id.openDialogButton)

    openDialogButton.setOnClickListener {
//        val dialogFragment = MyDialogFragment()
//        dialogFragment.show(supportFragmentManager, "myDialogTag")

      // todo: there is an issue showing this dialog here.
      val dialog = SetPinFragmentFromActivity.newInstance(niInput, pinLength)
      Log.d(TAG, supportFragmentManager.toString())
      dialog.show(supportFragmentManager, SetPinFragmentFromActivity.TAG)
    }
  }

  override fun onResume() {
    super.onResume()
    Log.d(TAG, "onResume called")
  }



  override fun onSetPinFragmentCompletion(response: SuccessErrorCancelResponse) {
    response.isSuccess?.let {
      Log.d(TAG, "SetPinFragmentFromActivity ${it.message}")
    }

    response.isError?.let {
      Log.d(TAG, "SetPinFragmentFromActivity ${it.errorMessage}")
    }
  }
}

// Your Dialog Fragment class
class MyDialogFragment : DialogFragment() {
  override fun onCreateDialog(savedInstanceState: Bundle?): Dialog {
    val builder = AlertDialog.Builder(requireContext())
    val inflater = LayoutInflater.from(requireContext())
    val view = inflater.inflate(R.layout.my_dialog_fragment, null)
    builder.setView(view)
    return builder.create()
  }
}
