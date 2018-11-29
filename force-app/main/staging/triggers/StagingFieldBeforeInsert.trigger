/**
 * Created by admin-1019 on 10/11/2018.
 */

trigger StagingFieldBeforeInsert on Staging_Field__c (before insert) {
    TriggerHandler.performAllActions(
        new List<Triggerable>{
            new StagingFieldValidator()
        },
        Trigger.new,
        Trigger.oldMap
    );
}