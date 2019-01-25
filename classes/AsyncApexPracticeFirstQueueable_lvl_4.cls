/**
 * Created by User on 18.12.2018.
 */

public with sharing class AsyncApexPracticeFirstQueueable_lvl_4 implements Queueable {
    public void execute(QueueableContext context) {
        List<Contact> contacts = new List<Contact>();
        for (Integer i = 0; i < 200; i++) {
            contacts.add(new Contact(FirstName = 'FirstJob'));
        }
        System.enqueueJob(new AsyncApexPracticeSecondQueueable_lvl_4(contacts));
    }
}