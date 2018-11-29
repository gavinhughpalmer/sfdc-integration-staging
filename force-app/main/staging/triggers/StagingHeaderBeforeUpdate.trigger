/**
 * Created by admin-1019 on 07/11/2018.
 */

trigger StagingHeaderBeforeUpdate on Staging_Header__c (before update) {
    TriggerHandler.performAllActions(
        new List<Triggerable>{
            new StagingHeaderValidator()
        },
        Trigger.new,
        Trigger.oldMap
    );
}