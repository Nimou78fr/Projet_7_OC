public with sharing class AccountSelector {

    public static Account getAccountById(Id accountId) {

        if (accountId == null) {
            return null;
        }

        List<Account> accounts = [
            SELECT Id, Name, Type, Industry, BillingCity, BillingCountry, Phone, Website
            FROM Account
            WHERE Id = :accountId
            LIMIT 1
        ];

        return accounts.isEmpty() ? null : accounts[0];
    }
}