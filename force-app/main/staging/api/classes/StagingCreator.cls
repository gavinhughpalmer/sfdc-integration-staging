/**
 * Created by admin-1019 on 09/11/2018.
 */
@RestResource(UrlMapping='/staging')
global class StagingCreator {
    @HttpPost
    global static StagingResponse insertStaging(StagingBuilder stagingDetail) {
        StagingResponse response = new StagingResponse();
        Staging_Header__c stagingHeader = stagingDetail.getHeader();
        stagingHeader.Status__c = 'Import In Progress';
        try {
            upsert stagingHeader Unique_Id__c;

            upsert stagingDetail.getFields() Unique_Id__c;

            stagingHeader.Status__c = 'Import Completed';
            upsert stagingHeader Unique_Id__c;
        } catch (DmlException exceptionToHandle) {
            response.addError(exceptionToHandle.getMessage());
            return response;
        }
        response.setHeaderId(stagingHeader.Id);
        return response;
    }
}