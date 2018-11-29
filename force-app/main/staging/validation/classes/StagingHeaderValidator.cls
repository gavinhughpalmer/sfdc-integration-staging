/**
 * Created by admin-1019 on 10/11/2018.
 */

public class StagingHeaderValidator implements Triggerable {

    private final StagingValidator validator = new StagingValidator();

    public void register(SObjectTriggerWrapper wrappedSObject) {
        Staging_Header__c stagingHeader = (Staging_Header__c) wrappedSObject.getSObject();
        if (validator.isNotValidHeader(stagingHeader)) {
            stagingHeader.addError('Object "' + stagingHeader.Salesforce_Object__c + '" does not exist in the salesforce schema');
        }
    }

    public void performAction() {
        // do nothing as validation has occurred already
    }
}