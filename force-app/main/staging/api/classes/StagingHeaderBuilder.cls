/**
 * Created by admin-1019 on 09/11/2018.
 */

public class StagingHeaderBuilder {
    private final Staging_Header__c stagingHeaderToBuild = new Staging_Header__c();

    public void setChangedDatetime(Datetime changeDatetime) {
        stagingHeaderToBuild.Change_Datetime__c = changeDatetime;
    }

    public void setSalesforceObject(String salesforceObject) {
        stagingHeaderToBuild.Salesforce_Object__c = salesforceObject;
    }

    public void setSourceIdentifier(String sourceIdentifier) {
        stagingHeaderToBuild.Source_Unique_Id__c = sourceIdentifier;
    }

    public Staging_Header__c build() {
        validateStagingRecord();
        stagingHeaderToBuild.Unique_Id__c = getUniqueId();
        return stagingHeaderToBuild;
    }

    private void validateStagingRecord() {
        if (isNotValid()) {
//                throw new StagingException
        }
    }

    public Boolean isNotValid() {
        return String.isBlank(stagingHeaderToBuild.Salesforce_Object__c) ||
            stagingHeaderToBuild.Change_Datetime__c == null ||
            String.isBlank(stagingHeaderToBuild.Source_Unique_Id__c);
    }

    private String getUniqueId() {
        return stagingHeaderToBuild.Salesforce_Object__c + stagingHeaderToBuild.Change_Datetime__c + stagingHeaderToBuild.Source_Unique_Id__c;
    }
}