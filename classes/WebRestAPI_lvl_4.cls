/**
 * Created by User on 14.01.2019.
 */
@RestResource(urlMapping='/test/*')
global with sharing class WebRestAPI_lvl_4 {
    @HttpGet
    global static List<Guest__c> getGuests() {
        List<Guest__c> guests = new List<Guest__c>();
        RestRequest request = RestContext.request;
        String keyGuest = request.params.get('key');
        if (keyGuest == null) {
            guests = [
                    SELECT Id, Name, Contact__r.LastName, Is_Invited__c
                    FROM Guest__c
                    WHERE Is_Invited__c = :true
            ];
        } else if (keyGuest == 'notInv') {
            guests = [
                    SELECT Id, Name, Contact__r.LastName, Is_Invited__c
                    FROM Guest__c
                    WHERE Is_Invited__c = :false
            ];
        } else {
            guests = [
                    SELECT Id, Name, Contact__r.LastName, Is_Invited__c
                    FROM Guest__c
                    WHERE Contact__r.LastName = :keyGuest
            ];
        }
        return guests;
    }

    @HttpPut
    global static List<Guest__c> putListName(List<String> guestName, String password) {
        Set<String> setGuestName = new Set<String>(guestName);
        Set<Id> setGuestContactsId = new Set<Id>();
        Map<String, PartyTime__c> partyTimeMap = PartyTime__c.getAll();
        Map<String, Contact> mapListContacts = new Map<String, Contact>();
        Map<String, Guest__c> mapListGuests = new Map<String, Guest__c>();
        List<Contact> newListContacts = new List<Contact>();
        List<Guest__c> newGuests = new List<Guest__c>();
        List<Guest__c> returnCreateGuest = new List<Guest__c>();

        if (password == partyTimeMap.get('Bimo').Password__c) {
            List<Contact> contacts = [
                    SELECT Id, LastName
                    FROM Contact
                    WHERE LastName = :setGuestName
            ];

//            Map<String, Contact> mapListContacts = new Map<String, Contact>();
            for (Integer i = 0; i < contacts.size(); i++) {
                if (!mapListContacts.containsKey(contacts[i].LastName)) {
                    mapListContacts.put(contacts[i].LastName, contacts[i]);
                }
            }

//            List<Contact> newListContacts = new List<Contact>();
            for (String str : setGuestName) {
                if (!mapListContacts.containsKey(str)) {
                    Contact contact = new Contact(LastName = str);
                    newListContacts.add(contact);
                }
            }

            if (!newListContacts.isEmpty()) {
                returnCreateGuest.addAll(createNewGuest(newListContacts));
            }

            List<Guest__c> guests = [
                    SELECT Id, Name, Is_Invited__c, Contact__c, Contact__r.LastName, Contact__r.Id
                    FROM Guest__c
                    WHERE Contact__r.LastName IN : setGuestName
            ];

//            Map<String, Guest__c> mapListGuests = new Map<String, Guest__c>();
            for (Integer i = 0; i < guests.size(); i++) {
                if (!mapListGuests.containsKey(guests[i].Contact__r.LastName)) {
                    mapListGuests.put(guests[i].Contact__r.LastName, guests[i]);
                }
            }

//            List<Guest__c> newGuests = new List<Guest__c>();
            for (String nameLastName : setGuestName) {
                if (!mapListGuests.containsKey(nameLastName)) {
                    Guest__c guest = new Guest__c(Contact__c = mapListContacts.get(nameLastName).Id);
                    newGuests.add(guest);
                }
            }
            insert newGuests;
            returnCreateGuest.addAll(newGuests);
        }
        return returnCreateGuest;
    }

    @HttpPatch
    global static String patchChecked(List<String> guestName, String password) {
        Set<String> setGuestName = new Set<String>(guestName);
        Map<String, PartyTime__c> partyTimeMap = PartyTime__c.getAll();
        if (password == partyTimeMap.get('Bimo').Password__c) {
            List<Guest__c> guests = [
                    SELECT Id, Name, Is_Invited__c, Contact__r.Name, Contact__c
                    FROM Guest__c
                    WHERE Contact__r.LastName IN :setGuestName
            ];
            for (Guest__c guest : guests) {
//                if (setGuestName.contains(guest.Contact__r.Name)) {
                    guest.Is_Invited__c = true;
//                }
            }
            update guests;
            return String.valueOf(guests.size());
        } else {
          return 'fail';
        }
    }

    @HttpDelete
    global static String deleteGuest() {
        RestRequest request = RestContext.request;
        String keyGuest = request.params.get('key');
        Map<String, PartyTime__c> partyTimeMap = PartyTime__c.getAll();
        if (keyGuest == partyTimeMap.get('Bimo').Password__c) {
            String guestId = request.requestURI.substring(request.requestURI.lastIndexOf('/') + 1);
            Guest__c guest = [
                    SELECT Id, Name
                    FROM Guest__c
                    WHERE Id = :guestId
            ];
            delete guest;
            return 'guest deleted';
        } else {
            return 'fail id guest ar password';
        }
    }

    @HttpPost
    global static String postCreatePassword(String password) {
        Map<String, PartyTime__c> partyTimeMap = PartyTime__c.getAll();
        if (password == partyTimeMap.get('Jake').Password__c || password == partyTimeMap.get('Phill').Password__c) {
            List<Integer> integers = new List<Integer>();
            While (integers.size() < 10) {
                Integer numb = Integer.valueOf(Math.random() * 100);
                if (47 < numb && numb < 58 || 64 < numb && numb < 91 || 96 < numb && numb < 123) {
                    integers.add(numb);
                }
            }
            partyTimeMap.get('Bimo').Password__c = String.fromCharArray(integers);
            update partyTimeMap.get('Bimo');

            WebRestAPI_Batch_lvl_4 apexBatch = new WebRestAPI_Batch_lvl_4();
            System.scheduleBatch(apexBatch, 'Party Time Work = ' + String.fromCharArray(integers), 1);
            return String.fromCharArray(integers);
        } else {
            return 'Ooops!';
        }
    }

    /**Get List Contacts**/
    /**Create new List<Guest__c>**/
    private static List<Guest__c> createNewGuest(List<Contact> contacts) {
        insert contacts;
        List<Guest__c> guests = new List<Guest__c>();
        for (Contact contact : contacts) {
            Guest__c guest = new Guest__c(Contact__c = contact.Id);
            guests.add(guest);
        }
        insert guests;
        return guests;
    }
}

//{
//"guestName" : ["Bill", "NewContact", "Sanchez", "Bill"]
//}