@isTest
private class AccountSelectorTest {

    @isTest
    static void testGetAccountById() {

        Account acc =TestDataFactory.createAccount('Test Account','Professionnel');
        insert acc;

        Test.startTest();
        Account result = AccountSelector.getAccountById(acc.Id);
        Test.stopTest();

        System.assertNotEquals(null, result);
        System.assertEquals(acc.Id, result.Id);
    }

    @isTest
    static void testGetAccountById_WithNullInput() {

        Test.startTest();
        Account result = AccountSelector.getAccountById(null);
        Test.stopTest();

        System.assertEquals(null, result);
    }
    @isTest
static void testGetAccountById_NotFound() {

    // Id valide mais qui ne correspond à aucun Account
    Id fakeId = Id.valueOf('001000000000000AAA');

    Test.startTest();
    Account result = AccountSelector.getAccountById(fakeId);
    Test.stopTest();

    System.assertEquals(null, result);
}
}