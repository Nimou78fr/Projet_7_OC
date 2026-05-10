@isTest
public class OrderServiceTest {

    @isTest
    static void testMinimumProductsParticulier() {

        Account acc = TestDataFactory.createAccount(
            'Client Test',
            'Particulier'
        );
        insert acc;

        Id standardPricebookId = Test.getStandardPricebookId();

        Product2 prod = TestDataFactory.createProduct(
            'Produit Test',
            true
        );
        insert prod;

        PricebookEntry pbe = TestDataFactory.createPricebookEntry(
            standardPricebookId,
            prod.Id,
            100,
            true
        );
        insert pbe;

        Order ord = TestDataFactory.createOrder(
            acc.Id,
            'Draft',
            Date.today(),
            standardPricebookId
        );
        insert ord;

        OrderItem oi1 = TestDataFactory.createOrderItem(
            ord.Id,
            pbe.Id,
            1,
            100
        );

        OrderItem oi2 = TestDataFactory.createOrderItem(
            ord.Id,
            pbe.Id,
            1,
            100
        );

        insert new List<OrderItem>{oi1, oi2};

        ord.Status = 'Validée';

       Test.startTest();

try {
    update ord;
    System.assert(false, 'Une erreur devait être levée');
} catch (DmlException e) {
    System.assert(
        e.getMessage().contains('minimum'), // adapte au message réel
        'Le message d’erreur attendu n’est pas correct : ' + e.getMessage()
    );
}

Test.stopTest();
    }
}