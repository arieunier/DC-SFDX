public with sharing class ServiceAttributeControler {

    @AuraEnabled(cacheable=True)
    public static List<public_serviceattribute__x> getServiceAttributes(String serviceId){
        return [ select id__c, 
            attributedescription__c, 
            attributelabel__c,
            attributename__c,
            attributeallowedvalues__c
            from  
            public_serviceattribute__x 
            where refservicedefinitionid__c = :serviceId ];
    }
}