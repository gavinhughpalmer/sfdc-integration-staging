/**
 * Created by admin-1019 on 10/11/2018.
 */

public class StagingFieldValidator implements Triggerable {

    private final StagingValidator validator = new StagingValidator();

    public void register(SObjectTriggerWrapper wrappedSObject) {
        Staging_Field__c stagingField = (Staging_Field__c) wrappedSObject.getSObject();
        if (validator.isNotValidField(stagingField)) {
            stagingField.addError('The field "' + stagingField.Salesforce_Object__c + '" does not exist for the object "' + stagingField.Salesforce_Field_Name__c + '"');
        }
    }

    public void performAction() {
        // do nothing as validation has occurred already
    }
}