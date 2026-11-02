public class ContactDuplicateHandler {
    
    public static void preventDuplicateEmail(List<Contact> newContacts){
        
        Set<String> emailSet = new Set<String>();
        for(Contact c : newContacts){
            if(c.Email != null){
                emailSet.add(c.Email.toLowerCase());
            }
        }
        
        if(emailSet.isEmpty()) return;
        
        
        Map<String, Contact> existingEmailMap = new Map<String, Contact>();
        for(Contact existingCon : [SELECT Id, Email, AccountId, Account.Name 
                                   FROM Contact 
                                   WHERE Email IN :emailSet]){
            if(existingCon.Email != null){
                existingEmailMap.put(existingCon.Email.toLowerCase(), existingCon);
            }
        }
        
        
        for(Contact newCon : newContacts){
            if(newCon.Email != null && existingEmailMap.containsKey(newCon.Email.toLowerCase())){
                Contact dup = existingEmailMap.get(newCon.Email.toLowerCase());
                newCon.addError('Duplicate Email Error: Email ' + newCon.Email + ' already exists on Contact linked to Account: ' + dup.Account.Name);
            }
        }
    }
}