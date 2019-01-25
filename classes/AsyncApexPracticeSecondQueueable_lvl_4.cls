/**
 * Created by User on 18.12.2018.
 */

public with sharing class AsyncApexPracticeSecondQueueable_lvl_4 implements Queueable {
    private List<Contact> contacts;

    public AsyncApexPracticeSecondQueueable_lvl_4(List<Contact> contacts){
        this.contacts = contacts;
    }

    public void execute(QueueableContext context) {
        for (Contact contact : contacts){
            contact.LastName = 'SecondJob';
        }
        insert contacts;
    }
}