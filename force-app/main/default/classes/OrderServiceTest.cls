@isTest
public class OrderServiceTest {

    @isTest
    static void testMinimumProductsParticulier() {

        Account acc = new Account(
            Name = 'Client Test',
            Type_Client__c = 'Particulier'
        );
        insert acc;

        Id standardPricebookId = Test.getStandardPricebookId();

        Product2 prod = new Product2(
            Name = 'Produit Test',
            IsActive = true
        );
        insert prod;

        PricebookEntry pbe = new PricebookEntry(
            Pricebook2Id = standardPricebookId,
            Product2Id = prod.Id,
            UnitPrice = 100,
            IsActive = true
        );
        insert pbe;

        Order ord = new Order(
            AccountId = acc.Id,
            Status = 'Draft',
            EffectiveDate = Date.today(),
            Pricebook2Id = standardPricebookId
        );
        insert ord;

        OrderItem oi1 = new OrderItem(
            OrderId = ord.Id,
            PricebookEntryId = pbe.Id,
            Quantity = 1,
            UnitPrice = 100
        );

        OrderItem oi2 = new OrderItem(
            OrderId = ord.Id,
            PricebookEntryId = pbe.Id,
            Quantity = 1,
            UnitPrice = 100
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