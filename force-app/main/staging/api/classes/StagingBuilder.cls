/**
 * Created by admin-1019 on 09/11/2018.
 */

global class StagingBuilder {

    private Datetime changedDatetime = Datetime.now();
    private String salesforceObject;
    private String sourceIdentifier;
    private Map<String, Object> fieldValues = new Map<String, Object>();
    private StagingHeaderBuilder header = new StagingHeaderBuilder();
    private Staging_Header__c headerRecord = new Staging_Header__c();
    private List<Staging_Field__c> fields = new List<Staging_Field__c>();

    global void setTargetObject(String salesforceObject) {
        this.salesforceObject = salesforceObject;
    }

    global void setSourceId(String sourceId) {
        this.sourceIdentifier = sourceId;
    }

    global void setField(String fieldName, Object fieldValue) {
        fieldValues.put(fieldName, fieldValue);
    }

    global void setStagingSObject(SObject sObjectToStage) {
        setTargetObject(String.valueOf(sObjectToStage.getSObjectType()));
        Map<String, Object> sObjectFieldValues = sObjectToStage.getPopulatedFieldsAsMap();
        fieldValues.putAll(sObjectFieldValues);
    }

    public Staging_Header__c getHeader() {
        if (header == null || header.isNotValid()) {
            header = new StagingHeaderBuilder();
            buildHeader();
        }
        return headerRecord;
    }

    private void buildHeader() {
        header.setChangedDatetime(changedDatetime);
        header.setSourceIdentifier(sourceIdentifier);
        header.setSalesforceObject(salesforceObject);
        headerRecord = header.build();
    }

    public List<Staging_Field__c> getFields() {
        if (fields == null || fields.isEmpty()) {
            fields = new List<Staging_Field__c>();
            buildFields();
        }
        return fields;
    }

    private void buildFields() {
        for (String fieldName : fieldValues.keySet()) {
            StagingFieldBuilder stagingField = new StagingFieldBuilder();
            stagingField.setField(fieldName, fieldValues.get(fieldName));
            stagingField.setParent(getHeader());
            fields.add(stagingField.build());
        }
    }
}