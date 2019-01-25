/**
 * Created by User on 02.01.2019.
 */

public with sharing class LightningIntroductionController_P1_4_lvl {
    @AuraEnabled
    public static List<Account> getAccounts(){
        List<Account> accounts = [
                SELECT Id, Name, NumberOfEmployees, BillingState
                FROM Account
        ];
        return accounts;
    }
}