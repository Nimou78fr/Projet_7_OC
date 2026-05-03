@isTest
private class TransporteurServiceTest {

   
    private static void createData() {

        
        Account accPart = new Account(
            Name = 'Client Particulier',
            Type_Client__c = 'Particulier'
        );

        Account accPro = new Account(
            Name = 'Client Pro',
            Type_Client__c = 'Professionnel'
        );

        insert new List<Account>{accPart, accPro};

        // Transporteurs
        Transporteur__c tPart = new Transporteur__c(
            Name = 'Transporteur Part',
            Type_Client__c = 'Particulier'
        );

        Transporteur__c tPro = new Transporteur__c(
            Name = 'Transporteur Pro',
            Type_Client__c = 'Professionnel'
        );

        insert new List<Transporteur__c>{tPart, tPro};

      
        List<TransporteurPrix__c> tarifs = new List<TransporteurPrix__c>{

            // Particulier
            new TransporteurPrix__c(
                Transporteur__c = tPart.Id,
                Pays__c = 'France',
                Tarifs__c = 10,
                D_lai_de_Livraison_jours__c = 5
            ),
            new TransporteurPrix__c(
                Transporteur__c = tPart.Id,
                Pays__c = 'France',
                Tarifs__c = 15,
                D_lai_de_Livraison_jours__c = 2
            ),

            // Professionnel
            new TransporteurPrix__c(
                Transporteur__c = tPro.Id,
                Pays__c = 'France',
                Tarifs__c = 12,
                D_lai_de_Livraison_jours__c = 1
            ),
            new TransporteurPrix__c(
                Transporteur__c = tPro.Id,
                Pays__c = 'France',
                Tarifs__c = 18,
                D_lai_de_Livraison_jours__c = 4
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