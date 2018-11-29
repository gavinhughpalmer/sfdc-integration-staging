/**
 * Created by admin-1019 on 10/11/2018.
 */

trigger StagingHeaderBeforeInsert on Staging_Header__c (before insert) {
    TriggerHandler.performAllActions(
        new List<Triggerable>{
            new StagingHeaderValidator()
        },
        Trigger.new,
        Trigger.oldMap
    );
}