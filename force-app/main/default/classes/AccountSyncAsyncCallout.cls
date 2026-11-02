public with sharing class AccountSyncAsyncCallout
    implements Queueable, Database.AllowsCallouts {

    private static final String NAMED_CREDENTIAL = 'orgA';

    private Set<Id> accountIds;

    public AccountSyncAsyncCallout(Set<Id> accountIds) {
        this.accountIds = accountIds;
    }

    public void execute(QueueableContext context) {

        List<Account> accounts = [
            SELECT Id,
                   Name,
                   Phone,
                   Website,
                   Sync__c,
                   Sync_Source__c,
                   External_Id__c
            FROM Account
            WHERE Id IN :accountIds
        ];

        Http http = new Http();

        for (Account acc : accounts) {

            Map<String, Object> payload = new Map<String, Object>{
                'Name'           => acc.Name,
                'Phone'          => acc.Phone,
                'Website'        => acc.Website,
                'Sync__c'        => true,
                'Sync_Source__c' => 'A',
                'External_Id__c' => String.valueOf(acc.Id)
            };

            System.debug(
                'Account sync payload: ' +
                JSON.serialize(payload)
            );

            HttpRequest req = new HttpRequest();

            req.setEndpoint(
                'callout:' +
                NAMED_CREDENTIAL +
                '/services/data/v66.0/sobjects/Account/'
            );

            req.setMethod('POST');

            req.setHeader(
                'Content-Type',
                'application/json'
            );

            req.setBody(
                JSON.serialize(payload)
            );

            req.setTimeout(30000);

            try {

                HttpResponse res = http.send(req);

                System.debug(
                    'Account sync response for ' +
                    acc.Id +
                    ': ' +
                    res.getStatusCode() +
                    ' ' +
                    res.getBody()
                );

                if (res.getStatusCode() == 201) {

                    Map<String, Object> result =
                        (Map<String, Object>)
                        JSON.deserializeUntyped(
                            res.getBody()
                        );

                    String targetAccountId =
                        (String) result.get('id');

                    System.debug(
                        'Account ' +
                        acc.Id +
                        ' created in target org. Target Id: ' +
                        targetAccountId
                    );

                } else {

                    System.debug(
                        'Account sync failed for ' +
                        acc.Id +
                        ': ' +
                        res.getStatusCode() +
                        ' ' +
                        res.getBody()
                    );
                }

            } catch (Exception e) {

                System.debug(
                    'Account sync exception for ' +
                    acc.Id +
                    ': ' +
                    e.getMessage()
                );
            }
        }
    }
}