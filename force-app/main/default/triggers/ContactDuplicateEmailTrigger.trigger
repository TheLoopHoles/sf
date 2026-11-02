trigger ContactDuplicateEmailTrigger on Contact (before insert, before update) {
    if(Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)){
        ContactDuplicateHandler.preventDuplicateEmail(Trigger.new);
    }
}