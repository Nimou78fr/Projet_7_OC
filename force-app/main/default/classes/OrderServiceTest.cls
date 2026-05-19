@isTest
public class OrderServiceTest {

    @isTest
    static void testMinimumProductsParticulier() {

        // Création Account particulier
        Account acc = new Account(
            Name = 'Client Particulier',
            Type_Client__c = 'Particulier'
        );
        insert acc;

        
        Id standardPricebookId = Test.getStandardPricebookId();

        // Produit
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

        // Commande
        Order ord = new Order(
            AccountId = acc.Id,
            Status = 'Draft',
            EffectiveDate = Date.today(),
            Pays_Livraison__c = 'France',
            Pricebook2Id = standardPricebookId
        );
        insert ord;

        
        List<OrderItem> items = new List<OrderItem>();

        for(Integer i = 0; i < 2; i++) {

            items.add(new OrderItem(
                OrderId = ord.Id,
                PricebookEntryId = pbe.Id,
                Quantity = 1,
                UnitPrice = 100
            ));
        }

        insert items;

        
        ord = [
            SELECT Id, Status, nbr_produit__c
            FROM Order
            WHERE Id = :ord.Id
        ];

        Test.startTest();

        ord.Status = 'Activated';

        try {

            update ord;

            System.assert(false,
                'Une exception devait être levée');

        } catch (DmlException e) {

            System.assert(
                e.getMessage().contains(
                    'Minimum 3 produits requis'
                )
            );
        }

        Test.stopTest();
    }

    @isTest
    static void testMinimumProductsProfessionnel() {

        // Création Account professionnel
        Account acc = new Account(
            Name = 'Client Professionnel',
            Type_Client__c = 'Professionnel'
        );
        insert acc;

        
        Id standardPricebookId = Test.getStandardPricebookId();

        // Produit
        Product2 prod = new Product2(
            Name = 'Produit Pro',
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

        // Commande
        Order ord = new Order(
            AccountId = acc.Id,
            Status = 'Draft',
            EffectiveDate = Date.today(),
            Pays_Livraison__c = 'France',
            Pricebook2Id = standardPricebookId
        );
        insert ord;

       
        List<OrderItem> items = new List<OrderItem>();

        for(Integer i = 0; i < 4; i++) {

            items.add(new OrderItem(
                OrderId = ord.Id,
                PricebookEntryId = pbe.Id,
                Quantity = 1,
                UnitPrice = 100
            ));
        }

        insert items;

        
        ord = [
            SELECT Id, Status, nbr_produit__c
            FROM Order
            WHERE Id = :ord.Id
        ];

        Test.startTest();

        ord.Status = 'Activated';

        try {

            update ord;

            System.assert(false,
                'Une exception devait être levée');

        } catch (DmlException e) {

            System.assert(
                e.getMessage().contains(
                    'Minimum 5 produits requis'
                )
            );
        }

        Test.stopTest();
    }
}