@isTest
public class TestDataFactory {

    public static Account createAccount() {
        Account acc = new Account(Name='Test Account');
        insert acc;
        return acc;
    }
}