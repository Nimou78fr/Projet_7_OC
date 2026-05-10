@isTest
private class TransporteurServiceTest {

   
    private static void createData() {

        
        Account accPart = TestDataFactory.createAccount(
            'Client Particulier',
            'Particulier'
        );

        Account accPro = TestDataFactory.createAccount(
            'Client Pro',
            'Professionnel'
        );

        insert new List<Account>{accPart, accPro};

        // Transporteurs
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

            // Particulier
            TestDataFactory.createTarif(
                tPart.Id,
                'France',
                10,
                5
            ),
            TestDataFactory.createTarif(
                tPart.Id,
                'France',
                15,
                2
            ),

            // Professionnel
            TestDataFactory.createTarif(
                tPro.Id,
                'France',
                12,
                1
            ),
            TestDataFactory.createTarif(
                tPro.Id,
                'France',
                18,
                4
            )
        };

        insert tarifs;

        // Commandes
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

        createData();

        Order o = [SELECT Id FROM Order WHERE Name = 'Order Part' LIMIT 1];

        Test.startTest();
        TransporteurPrix__c result =
            TransporteurService.getBestTransporteurMoinsCher('France', o.Id);
        Test.stopTest();

        System.assertNotEquals(null, result);
        System.assertEquals(10, result.Tarifs__c);
    }

    
    @isTest
    static void testBestDelai_Pro() {

        createData();

        Order o = [SELECT Id FROM Order WHERE Name = 'Order Pro' LIMIT 1];

        Test.startTest();
        TransporteurPrix__c result =
            TransporteurService.getBestTransporteurPlusRapide('France', o.Id);
        Test.stopTest();

        System.assertNotEquals(null, result);
        System.assertEquals(1, result.D_lai_de_Livraison_jours__c);
    }

  
    @isTest
    static void testFiltreTypeClient() {

        createData();

        Order o = [SELECT Id FROM Order WHERE Name = 'Order Part' LIMIT 1];

        Test.startTest();
        List<TransporteurPrix__c> result =
            TransporteurService.getAllTransporteurs('France', o.Id);
        Test.stopTest();

        // Un particulier ne doit voir que ses transporteurs
        for(TransporteurPrix__c t : result) {
            System.assertEquals(
                'Particulier',
                t.Transporteur__r.Type_Client__c
            );
        }
    }

    
    @isTest
    static void testGetAllTransporteurs() {

        createData();

        Order o = [SELECT Id FROM Order WHERE Name = 'Order Pro' LIMIT 1];

        Test.startTest();
        List<TransporteurPrix__c> result =
            TransporteurService.getAllTransporteurs('France', o.Id);
        Test.stopTest();

        System.assert(result.size() > 0);
    }

    @isTest
    static void testUpdateOrderTransporteur() {

        createData();

        Order o = [SELECT Id FROM Order LIMIT 1];

        Test.startTest();
        TransporteurController.updateOrderTransporteur(
            o.Id,
            'Transporteur Part'
        );
        Test.stopTest();

        Order updated = [SELECT Transporteur__c FROM Order WHERE Id = :o.Id];

        System.assertEquals('Transporteur Part', updated.Transporteur__c);
    }
}