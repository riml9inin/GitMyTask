/**
 * Created by User on 18.12.2018.
 */

public with sharing class apexBatchAsyncApexPracticeBatch_lvl_4 implements Database.Batchable<sObject> {
    public Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator('SELECT Title FROM Contact WHERE LastName = \'SecondJob\' AND FirstName = \'FirstJob\'');
//        return Database.getQueryLocator([SELECT Title FROM Contact WHERE LastName =: 'SecondJob' AND FirstName =: 'FirstJob']);
    }

    public void execute(Database.BatchableContext BC, List<Contact> contacts) {
        for (Contact contact : contacts) {
            contact.Title = 'Async Apex';
        }
        update contacts;

    }

    public void finish(Database.BatchableContext BC) {}
}