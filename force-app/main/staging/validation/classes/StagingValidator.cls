/**
 * Created by admin-1019 on 11/11/2018.
 */

public class StagingValidator {

    private final SchemaFacade schema = SchemaFacade.getInstance();

    public Boolean isNotValidHeader(Staging_Header__c stagingHeaderToValidate) {
        return schema.isNotValidSObject(stagingHeaderToValidate.Salesforce_Object__c);
    }

    public Boolean isNotValidField(Staging_Field__c stagingFieldToValidate) {
        final String stagedObjectName = stagingFieldToValidate.Salesforce_Object__c;
        final String stagedFieldName = stagingFieldToValidate.Salesforce_Field_Name__c;
        return schema.isNotValidField(stagedObjectName, stagedFieldName) ||
            isNotCorrectFieldType(stagingFieldToValidate);
    }

    private Boolean isNotCorrectFieldType(Staging_Field__c stagingFieldToValidate) {
        final String stagedObjectName = stagingFieldToValidate.Salesforce_Object__c;
        final String stagedFieldName = stagingFieldToValidate.Salesforce_Field_Name__c;
        DisplayType fieldType = schema.getFieldDescribe(stagedObjectName, stagedFieldName).getType();
        Parsable parser = new DisplayTypeParser(fieldType);
        // TODO see if there is a better way to validate the field type
//        try {
//            parser.parse(stagingFieldToValidate.Input_Field_Value__c);
//        } catch (Exception ex) {
//            return false;
//        }
        return true;
    }
}