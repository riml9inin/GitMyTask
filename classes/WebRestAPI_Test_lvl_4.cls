/**
 * Created by User on 16.01.2019.
 */
@isTest
public with sharing class WebRestAPI_Test_lvl_4 {

    @testSetup
    static void setup() {
        createTestRecord();
        createCustomSettingRecord();
    }

    @isTest
    public static void testGetGuests() {
        List<String> keyGuest = new List<String>{
                null, 'notInv', 'Bill'
        };
        Test.startTest();
        for (Integer i = 0; i < keyGuest.size(); i++) {
            RestRequest request = new RestRequest();
            request.requestUri =
                    'https://yourInstance.salesforce.com/services/apexrest/test/';
            request.httpMethod = 'GET';
            request.params.put('key', keyGuest[i]);
            RestContext.request = request;

            if (request.params.get('key') == null) {
                system.assertEquals([SELECT COUNT() FROM Guest__c WHERE Is_Invited__c = :true],
                        (WebRestAPI_lvl_4.getGuests()).size());
            } else if (request.params.get('key') == 'notInv') {
                system.assertEquals([SELECT COUNT() FROM Guest__c WHERE Is_Invited__c = :false],
                        (WebRestAPI_lvl_4.getGuests()).size());
            } else {
                String name = request.params.get('key');
                system.assertEquals([SELECT COUNT() FROM Guest__c WHERE Contact__r.LastName = :name],
                        (WebRestAPI_lvl_4.getGuests()).size());
            }
        }
        Test.stopTest();
    }

    @isTest
    public static void testPutListName() {
        List<String> strings = new List<String>{
                'Bill', 'NewSecondContact', 'NewFirstContact', 'NewFirstContact'
        };

        String password = WebRestAPI_lvl_4.postCreatePassword(PartyTime__c.getAll().get('Jake').Password__c);
        List<Guest__c> guests = new List<Guest__c>(WebRestAPI_lvl_4.putListName(strings, password));

        system.assertEquals([SELECT COUNT() FROM Guest__c WHERE Id IN :guests], guests.size());
    }

    @isTest
    public static void testPatchChecked() {
        List<String> strings = new List<String>{
                'Bill', 'NewSecondContact', 'NewFirstContact', 'NewFirstContact'
        };

        String countPatchList = WebRestAPI_lvl_4.patchChecked(strings,
                WebRestAPI_lvl_4.postCreatePassword(
                        PartyTime__c.getAll().get('Jake').Password__c));

        Integer afterPatch = [
                SELECT COUNT()
                FROM Guest__c
                WHERE Contact__r.LastName
                        IN :strings
        ];
        system.assertEquals(String.valueOf(afterPatch), countPatchList);
    }

    @isTest
    public static void testDeleteGuest() {
        String getPassword = WebRestAPI_lvl_4.postCreatePassword(PartyTime__c.getAll().get('Jake').Password__c);
        Guest__c guest = [SELECT Id FROM Guest__c LIMIT 1];
        RestRequest request = new RestRequest();
        request.requestUri =
                'https://yourInstance.salesforce.com/services/apexrest/test/' + guest.Id;
        request.httpMethod = 'Delete';

        request.params.put('key', getPassword);
        RestContext.request = request;
        WebRestAPI_lvl_4.deleteGuest();
        Test.startTest();
        system.assert([SELECT COUNT() FROM Guest__c WHERE Id = :guest.Id] == 0);
        Test.stopTest();
    }

    @isTest
    public static void testPostCreatePassword() {
        Test.startTest();
        String result = WebRestAPI_lvl_4.postCreatePassword('JakeWinner');
        String resultPassword = PartyTime__c.getAll().get('Bimo').Password__c;
        system.assertEquals(resultPassword, result);
        Test.stopTest();
    }

    private static void createTestRecord() {
        List<Guest__c> guests = new List<Guest__c>();
        List<Contact> contacts = new List<Contact>();
        for (Integer i = 0; i < 3; i++) {
            Contact contact = new Contact(LastName = 'Bill', FirstName = 'Record: ' + i);
            contacts.add(contact);
        }
        insert contacts;

        for (Integer i = 0; i < contacts.size(); i++) {
            if (i == (contacts.size() - 1)) {
                Guest__c guest = new Guest__c(Is_Invited__c = true, Contact__c = contacts[i].Id);
                guests.add(guest);
            } else {
                Guest__c guest = new Guest__c(Is_Invited__c = false, Contact__c = contacts[i].Id);
                guests.add(guest);
            }
        }
        insert guests;
    }

    private static void createCustomSettingRecord() {
        List<PartyTime__c> partyTimes = new List<PartyTime__c>{
                new PartyTime__c(Name = 'Phill', Password__c = 'PhillWinner'),
                new PartyTime__c(Name = 'Jake', Password__c = 'JakeWinner'),
                new PartyTime__c(Name = 'Bimo')
        };
        insert partyTimes;
    }
}