/**
 * Created by admin-1019 on 09/11/2018.
 */

global class StagingResponse {
    private Boolean success = true;
    private String message;
    private final Id headerId;
    private final String sourceId;

    public StagingResponse(Staging_Header__c header) {
        headerId = header.Id;
        sourceId = header.Source_Unique_Id__c;
    }

    public void addError(String message) {
        setMessage(message);
        success = false;
    }

    public void addErrors(List<Database.Error> errors) {
        StringBuilder errorMessage = new StringBuilder();
        errorMessage.setSeparator('\n');
        for (Database.Error error : errors) {
            errorMessage.append(error.getMessage());
        }
        addError(errorMessage.toString());
    }

    public void setMessage(String message) {
        this.message = message;
    }
}