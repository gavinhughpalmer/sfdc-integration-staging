/**
 * Created by admin-1019 on 11/11/2018.
 */

public class StagingValidator {

    private final SchemaFacade schema = SchemaFacade.getInstance();

    public Boolean isNotValidHeader(Staging_Header__c stagingHeader) {
        return schema.isNotValidSObject(stagingHeaderToValidate.Salesforce_Object__c);
    }

    public Boolean isNotValidField(Staging_Field__c stagingFieldToValidate) {
        final String stagedObjectName = stagingFieldToValidate.Salesforce_Object__c;
        final String stagedFieldName = stagingFieldToValidate.Salesforce_Field_Name__c;
        return schema.isNotValidField(stagedObjectName, stagedFieldName) ||
            isNotCorrectFieldType(stagedObjectName, stagedFieldName);
    }

    private Boolean isNotCorrectFieldType(String stagedObjectName, String stagedFieldName) {
        DisplayType fieldType = schema.getFieldDescribe(stagedObjectName, stagedFieldName).getType();
        return false;
    }
}