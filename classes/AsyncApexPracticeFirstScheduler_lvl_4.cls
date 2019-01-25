/**
 * Created by User on 18.12.2018.
 */

public with sharing class AsyncApexPracticeFirstScheduler_lvl_4 implements Schedulable {
    public void execute(SchedulableContext SC) {
        AsyncApexPracticeFirstQueueable_lvl_4 firstQueueable = new AsyncApexPracticeFirstQueueable_lvl_4();
        System.enqueueJob(firstQueueable);

        AsyncApexPracticeBatch_lvl_4 apexBatch = new AsyncApexPracticeBatch_lvl_4();
        System.scheduleBatch(apexBatch, 'batch work', 20);
    }
}