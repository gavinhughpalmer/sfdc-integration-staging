/**
 * Created by admin-1019 on 09/11/2018.
 */

public class StagingFieldBuilder {

    private final Staging_Field__c stagingFieldToBuild = new Staging_Field__c();
    private static final Map<DisplayType, SObjectField> displayTypesToTargetFields = new Map<DisplayType, SObjectField>{
        DisplayType.ANYTYPE => Staging_Field__c.String_Value__c,
        DisplayType.BASE64 => Staging_Field__c.String_Value__c,
        DisplayType.BOOLEAN => Staging_Field__c.Boolean_Value__c,
        DisplayType.COMPLEXVALUE => Staging_Field__c.String_Value__c,
        DisplayType.CURRENCY => Staging_Field__c.Number_Value__c,
        DisplayType.DATE => Staging_Field__c.Datetime_Value__c,
        DisplayType.DATETIME => Staging_Field__c.Datetime_Value__c,
        DisplayType.DOUBLE => Staging_Field__c.Number_Value__c,
        DisplayType.EMAIL => Staging_Field__c.String_Value__c,
        DisplayType.ENCRYPTEDSTRING => Staging_Field__c.String_Value__c,
        DisplayType.ID => Staging_Field__c.String_Value__c,
        DisplayType.INTEGER => Staging_Field__c.Number_Value__c,
        DisplayType.JSON => Staging_Field__c.String_Value__c,
        DisplayType.LONG => Staging_Field__c.Number_Value__c,
        DisplayType.MULTIPICKLIST => Staging_Field__c.String_Value__c,
        DisplayType.PERCENT => Staging_Field__c.Number_Value__c,
        DisplayType.PHONE => Staging_Field__c.String_Value__c,
        DisplayType.PICKLIST => Staging_Field__c.String_Value__c,
        DisplayType.REFERENCE => Staging_Field__c.String_Value__c,
        DisplayType.STRING => Staging_Field__c.String_Value__c,
        DisplayType.TEXTAREA => Staging_Field__c.String_Value__c,
        DisplayType.TIME => Staging_Field__c.Time_Value__c,
        DisplayType.URL => Staging_Field__c.String_Value__c
    };

    public void setParent(Staging_Header__c parentHeader) {
        stagingFieldToBuild.Staging_Header__c = parentHeader.Id;
        stagingFieldToBuild.Staging_Header__r = parentHeader;
    }

    private String getSObjectName() {
        return stagingFieldToBuild.Staging_Header__r.Salesforce_Object__c
    }

    public void setField(String fieldName, Object fieldValue) {
        DisplayType targetFieldType = SchemaFacade.getInstance().getFieldDescribe(getSObjectName(), fieldName).getType();
        stagingFieldToBuild.put(displayTypesToTargetFields.get(targetFieldType), fieldValue);
    }

    public Staging_Field__c build() {
        validateStagingField();
        stagingFieldToBuild.Unique_Id__c = getUniqueId();
        return stagingFieldToBuild;
    }

    private void validateStagingField() {
        if (isNotValid()) {
//                throw new StagingException
        }
    }

    private Boolean isNotValid() {
        return String.isBlank(stagingFieldToBuild.Staging_Header__r.Unique_Id__c) ||
            String.isBlank(stagingFieldToBuild.Salesforce_Field_Name__c);
    }

    private String getUniqueId() {
        return stagingFieldToBuild.Staging_Header__r.Unique_Id__c + stagingFieldToBuild.Salesforce_Field_Name__c;
    }
}