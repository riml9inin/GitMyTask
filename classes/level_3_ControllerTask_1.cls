public with sharing class level_3_ControllerTask_1 {
    public Id contactID { get; set; }

    public Contact getContactInfoForAccount() {
        Contact contact = [
                SELECT Account.Name, Account.Phone, Account.Type, Account.AccountNumber, Account.BillingStreet, Account.BillingCity, Account.BillingState
                FROM Contact
                WHERE id =: contactID
        ];
        return contact;
    }
}