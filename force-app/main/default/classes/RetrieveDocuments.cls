global with sharing class RetrieveDocuments {

    public class RetrieveDocumentsFlowInput{
        @AuraEnabled @InvocableVariable public String recordId;
    }

    public class RetrieveDocumentsFlowOutput{
        @AuraEnabled @InvocableVariable public Integer nbDocuments;
        @AuraEnabled @InvocableVariable public Integer totalSize;
    }



    @InvocableMethod(label='Calculate the current space used by documents/attachments related to a given record')
    public static List<RetrieveDocumentsFlowOutput> getDocumentSize(List<RetrieveDocumentsFlowInput> inParams)
    {
        System.debug('Flow Invoked');
        String recordId = inParams[0].recordId;
        System.debug('Record Id = ' + recordId);
        
        List<RetrieveDocumentsFlowOutput> result = new List<RetrieveDocumentsFlowOutput>();
        List<String> ContentDocumentIds = new List<String>();
        List<ContentDocumentLink> resultSoql = [select Id, ContentDocumentId from ContentDocumentLink where LinkedEntityId = :recordId];
        for (ContentDocumentLink ct : resultSoql)
        {
            System.debug('Treating Id=' + ct.Id + ' / ContentDocumentId=' + ct.ContentDocumentId);
            ContentDocumentIds.add(ct.ContentDocumentId);
        }

        // now calculate        
        List<AggregateResult> resultSize= [select sum(contentsize) totalSize, count(Id) nbDocuments from ContentVersion WHERE (ContentDocumentId in :ContentDocumentIds) AND IsLatest = true];
        System.debug(resultSize);
        for (AggregateResult ar: resultSize)
        {
            RetrieveDocumentsFlowOutput out = new RetrieveDocumentsFlowOutput();
            out.nbDocuments = Integer.valueOf(ar.get('nbDocuments'));
            out.totalSize = Integer.valueOf(ar.get('totalSize'));
            result.add(out);
        }
        return result;

    }
}