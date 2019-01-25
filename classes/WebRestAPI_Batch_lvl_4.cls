/**
 * Created by User on 16.01.2019.
 */

global with sharing class WebRestAPI_Batch_lvl_4 implements Database.Batchable<sObject> {
    public Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator('SELECT Name, Password__c FROM PartyTime__c');
    }

    public void execute(Database.BatchableContext BC, List<PartyTime__c> partyTimes) {
        for(PartyTime__c partyTime : partyTimes) {
            if(partyTime.Name == 'Bimo') {
                partyTime.Password__c = null;
            }
        }
        update partyTimes;
    }

    public void finish(Database.BatchableContext BC) {}
}