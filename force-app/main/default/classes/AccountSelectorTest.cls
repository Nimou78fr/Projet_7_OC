@isTest
private class AccountSelectorTest {

    @isTest
    static void testGetAccountById() {
        Account acc = new Account(Name = 'Test Account');
        insert acc;

        Account result = AccountSelector.getAccountById(acc.Id);

        System.assertNotEquals(null, result);
        System.assertEquals(acc.Id, result.Id);
    }

    @isTest
    static void testGetAccountById_Null() {
        Account result = AccountSelector.getAccountById(null);
        System.assertEquals(null, result);
    }
}