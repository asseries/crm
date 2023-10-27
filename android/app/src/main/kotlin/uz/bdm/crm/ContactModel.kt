package uz.bdm.crm

import java.io.Serializable

data class ContactModel(
    var id: Int?,
    var name:String?,
    var number:String?,
    var favorite:Boolean?,
    var photoUri:ByteArray?,
):Serializable

