trigger PracticeTrigger on Contact (after insert, before update) {
    //--------------------------    Trigger №1    -------------------------------------//

    if(Trigger.isAfter && Trigger.isInsert) {
        PracticeTriggerHandler.handleAfterInsert(Trigger.new);
    }

    //--------------------------    Trigger №2    -------------------------------------//
    if(Trigger.isBefore && Trigger.isUpdate) {
        PracticeTriggerHandler.handleAfterUpdate(Trigger.new);
    }
}