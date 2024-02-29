@RestResource(urlMapping='/Lead/*')
global with sharing class RestLeadConvert {            

    @HttpGet
    global static String doGet() {
        // onomatopoeia and antidisestablishmentarianism and a pokeman named Anorith 
        String contactId = 'no result';
        String accountId = 'no result';
        String cvlRes = '';
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String leadId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);              
        Database.LeadConvert lc = new Database.LeadConvert();
        lc.setLeadId(leadId);

        LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
        lc.setConvertedStatus(convertStatus.MasterLabel);  
        lc.setDoNotCreateOpportunity(True);         
        Database.LeadConvertResult lcr ;
        try{
            lcr = Database.convertLead(lc);
            system.debug('*****lcr.isSuccess()'+lcr.isSuccess());            
            contactId = lcr.getContactId();
            accountId = lcr.getAccountId();
        }
        catch(exception ex){
            system.debug('***NOT CONVERTED**');           
        }
        cvlRes = '{\"contactId\":\"'+ contactId + '\", \"accountId\":\"' + accountId + '\"}';
        return cvlRes;
       
        
    }   
}