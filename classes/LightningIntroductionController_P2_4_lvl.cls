/**
 * Created by User on 03.01.2019.
 */

public with sharing class LightningIntroductionController_P2_4_lvl {
    @AuraEnabled
    public static String getJsonContact() {
        List<Contact> contacts = [
                SELECT Id, Name, Phone, Department, DoNotCall, Birthdate
                FROM Contact
        ];
        return JSON.serialize(contacts);
    }

//    @AuraEnabled
//    public static String getSearchParam(String param) {
//        List<Contact> contacts;
//        if(param != '') {
//            String str = '%' + param + '%';
//            contacts = [
//                    SELECT Id, Name, Phone, Department, DoNotCall, Birthdate
//                    FROM Contact
//                    WHERE Name LIKE :str
//            ];
//        } else {
//            contacts = [
//                    SELECT Id, Name, Phone, Department, DoNotCall, Birthdate
//                    FROM Contact
//            ];
//        }
//        return JSON.serialize(contacts);
//    }

    @AuraEnabled
    public static String getSearchParam(String param) {
        List<Contact> contacts = [
                SELECT Id, Name, Phone, Department, DoNotCall, Birthdate
                FROM Contact
                WHERE Id =: param
        ];
        if(!contacts.isEmpty()){
            return JSON.serialize(contacts);
        } else {
            return 'false';
        }
    }
}