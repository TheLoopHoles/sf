trigger AccountTrigger on Account (after insert) {

    Set<Id> accountIds = new Set<Id>();

    for (Account acc : Trigger.new) {
        accountIds.add(acc.Id);
    }

    if (!accountIds.isEmpty()) {
        System.enqueueJob(
            new AccountSyncAsyncCallout(accountIds)
        );
    }
}