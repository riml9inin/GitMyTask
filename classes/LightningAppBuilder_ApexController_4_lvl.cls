/**
 * Created by User on 21.01.2019.
 */

global with sharing class LightningAppBuilder_ApexController_4_lvl {
    @AuraEnabled
    global static String getListContacts(String idAccount) {
        List<Contact> contacts = [
                SELECT Id, Name, AccountId
                FROM Contact
                WHERE AccountId = :idAccount
        ];

        return JSON.serialize(contacts);
    }
}