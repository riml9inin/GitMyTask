/**
 * Created by User on 21.01.2019.
 */

global with sharing class LightningAppBuilder_CmpAction_4_lvl {
    @AuraEnabled
    global static String getContactsAndAccountInfo(String contactStr) {
        System.debug(contactStr);
        Contact contact = [
                SELECT Id, AccountId, Name
                FROM Contact
                WHERE id = :contactStr
        ];
        String IdAccount = contact.AccountId;
        List<Contact> contacts = [
                SELECT Id, AccountId, Name
                FROM Contact
                WHERE AccountId = :IdAccount
        ];
        System.debug(contacts);
        return JSON.serialize(contacts);
    }
}