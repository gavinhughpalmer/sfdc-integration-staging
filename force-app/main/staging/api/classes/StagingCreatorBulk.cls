/**
 * Created by admin-1019 on 09/11/2018.
 */
@RestResource(UrlMapping='/bulkstaging')
global class StagingCreatorBulk {


    /*
    Example callout
{
    "stagingDetails": [
        {
            "changedDatetime": "2011-01-10T00:00:00.000Z",
            "sourceIdentifier": "UUID1",
            "salesforceObject": "value for string2",
            "fieldValues": {
                "firstName": "Gavin",
                "lastName": "Palmer",
                "age": 25
            }
        },
        {
            "changedDatetime": "2012-01-10T00:00:00.000Z",
            "sourceIdentifier": "UUID12",
            "salesforceObject": "value for string2",
            "fieldValues": {
                "firstName": "Fred",
                "lastName": "Flintof",
                "age": 29
            }
        }
    ]
}
     */


    @HttpPost
    global static List<StagingResponse> insertStaging() {
        String jsonBody = RestContext.request.requestBody.toString();
        List<StagingBuilder> stagingDetails = (List<StagingBuilder>) JSON.deserialize(jsonBody, List<StagingBuilder>.class);
        Map<String, StagingResponse> responsesByStagingId = new Map<String, StagingResponse>();
        List<Staging_Header__c> orderedHeaders = new List<Staging_Header__c>();
        Map<String, List<Staging_Field__c>> stagingFieldsByHeaderId = new Map<String, List<Staging_Field__c>>();
        for (StagingBuilder stagingDetail : stagingDetails) {
            Staging_Header__c header = stagingDetail.getHeader();
            header.Status__c = 'Import In Progress';
            orderedHeaders.add(header);
            List<Staging_Field__c> stagingFields = stagingDetail.getFields();
            stagingFieldsByHeaderId.put(header.Unique_Id__c, stagingFields);
        }
        List<Database.UpsertResult> stagingHeaderUpsertResults = Database.upsert(
            orderedHeaders,
            Staging_Header__c.Unique_Id__c,
            false
        );
        Map<String, Staging_Header__c> stagingHeaderMap = new Map<String, Staging_Header__c>();
        for (Integer i = 0; i < stagingHeaderUpsertResults.size(); i++) {
            Database.UpsertResult stagingResult = stagingHeaderUpsertResults[i];
            Staging_Header__c header = orderedHeaders[i];
            final String headerUniqueId = header.Unique_Id__c;
            StagingResponse response = new StagingResponse(header);
            if (!stagingResult.isSuccess()) {
                response.addErrors(stagingResult.getErrors());
                responsesByStagingId.put(headerUniqueId, response);
                stagingFieldsByHeaderId.remove(headerUniqueId);
            } else {
                stagingHeaderMap.put(headerUniqueId, header);
            }
        }
        List<Staging_Field__c> stagingFieldsToUpsert = new List<Staging_Field__c>();
        for (List<Staging_Field__c> fields : stagingFieldsByHeaderId.values()) {
            stagingFieldsToUpsert.addAll(fields);
        }
        List<Database.UpsertResult> stagingFieldUpsertResults = Database.upsert(
            stagingFieldsToUpsert,
            Staging_Field__c.Unique_Id__c,
            false
        );
        Map<Id, Staging_Header__c> stagingHeadersToUpdateById = new Map<Id, Staging_Header__c>();
        for (Integer i = 0; i < stagingFieldUpsertResults.size(); i++) {
            Database.UpsertResult fieldResult = stagingFieldUpsertResults[i];
            Staging_Field__c field = stagingFieldsToUpsert[i];
            final String stagingId = field.Staging_Header__r.Unique_Id__c;
            Staging_Header__c header = stagingHeaderMap.get(stagingId);
            if (!fieldResult.isSuccess()) {
                StagingResponse response = responsesByStagingId.get(stagingId);
                response.addErrors(fieldResult.getErrors());
                header.Status__c = 'Failed';
                stagingHeaderMap.remove(stagingId);
            } else {
                header.Status__c = 'Import Completed';
            }
            stagingHeadersToUpdateById.put(header.Id, header);
        }
        List<Staging_Header__c> stagingHeadersToUpdate = stagingHeadersToUpdateById.values();
        List<Database.SaveResult> completedResults = Database.update(stagingHeadersToUpdate, false);
        for (Integer i = 0; i < completedResults.size(); i++) {
            if (!completedResults[i].isSuccess()) {
                final String stagingId = stagingHeadersToUpdate[i].Unique_Id__c;
                StagingResponse response = responsesByStagingId.get(stagingId);
                response.addErrors(completedResults[i].getErrors());
            }
        }
        return responsesByStagingId.values();
    }
}