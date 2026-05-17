@isTest
private class TransporteurServiceTest {
    @TestSetup
    static void createData() {

        Account accPart = TestDataFactory.createAccount(
            'Client Particulier',
            'Particulier'
        );

        Account accPro = TestDataFactory.createAccount(
            'Client Pro',
            'Professionnel'
        );

        insert new List<Account>{accPart, accPro};

        Transporteur__c tPart = TestDataFactory.createTransporteur(
            'Transporteur Part',
            'Particulier'
        );

        Transporteur__c tPro = TestDataFactory.createTransporteur(
            'Transporteur Pro',
            'Professionnel'
        );

        insert new List<Transporteur__c>{tPart, tPro};

        List<TransporteurPrix__c> tarifs = new List<TransporteurPrix__c>{

            TestDataFactory.createTarif(tPart.Id, 'France', 10, 5),
            TestDataFactory.createTarif(tPart.Id, 'France', 15, 2),

            TestDataFactory.createTarif(tPro.Id, 'France', 12, 1),
            TestDataFactory.createTarif(tPro.Id, 'France', 18, 4)
        };

        insert tarifs;

        Order oPart = new Order(
            Name = 'Order Part',
            AccountId = accPart.Id,
            Status = 'Draft',
            EffectiveDate = Date.today(),
            Pays_Livraison__c = 'France'
        );

        Order oPro = new Order(
            Name = 'Order Pro',
            AccountId = accPro.Id,
            Status = 'Draft',
            EffectiveDate = Date.today(),
            Pays_Livraison__c = 'France'
        );

        insert new List<Order>{oPart, oPro};
    }

    @isTest
    static void testBestPrix_Particulier() {

        //createData();

        Order o = [SELECT Id FROM Order WHERE Name = 'Order Part' LIMIT 1];

        Test.startTest();
        TransporteurPrix__c result =
            TransporteurController.getBestTransporteurMoinsCher('France', o.Id);
        Test.stopTest();

        System.assertNotEquals(null, result);
    }

    @isTest
    static void testBestDelai_Pro() {

        //createData();

        Order o = [SELECT Id FROM Order WHERE Name = 'Order Pro' LIMIT 1];

        Test.startTest();
        TransporteurPrix__c result =
            TransporteurController.getBestTransporteurPlusRapide('France', o.Id);
        Test.stopTest();

        System.assertNotEquals(null, result);
    }

    @isTest
    static void testFiltreTypeClient() {

        //createData();

        Order o = [SELECT Id FROM Order WHERE Name = 'Order Part' LIMIT 1];

        Test.startTest();
        List<TransporteurPrix__c> result =
            TransporteurController.getAllTransporteurs('France', o.Id);
        Test.stopTest();

        for (TransporteurPrix__c t : result) {
            System.assertEquals(
                'Particulier',
                t.Transporteur__r.Type_Client__c
            );
        }
    }

    @isTest
    static void testGetAllTransporteurs() {

       // createData();

        Order o = [SELECT Id FROM Order WHERE Name = 'Order Pro' LIMIT 1];

        Test.startTest();
        Transporteur__c result =
            TransporteurController.getTransporteur('France', o.Id);
        Test.stopTest();

        System.assert(result==null);
    }

    @isTest
    static void testUpdateOrderTransporteur() {
        //createData();
        Order o = [SELECT Id FROM Order LIMIT 1];
        TransporteurPrix__c tp = [
            SELECT Id, Pays__c, Tarifs__c, Transporteur__c, D_lai_de_Livraison_jours__c
            FROM TransporteurPrix__c
            LIMIT 1
        ];
        Test.startTest();
        TransporteurController.updateOrderTransporteur(o.Id,tp);
        Livraison__c liv = [
            SELECT Order__c, Transporteur__c
            FROM Livraison__c
            WHERE Order__c = :o.Id
            LIMIT 1
        ];
        TransporteurController.updateOrderTransporteur(o.Id,tp);
        Test.stopTest();
        System.assertEquals(o.Id, liv.Order__c);
        System.assertEquals(tp.Transporteur__c, liv.Transporteur__c);
    }
}