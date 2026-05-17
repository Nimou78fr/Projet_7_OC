@isTest
public class TestDataFactory {

    public static Account createAccount(String name, String typeClient) {
        return new Account(
            Name = name,
            Type_Client__c = typeClient
        );
    }

    public static Transporteur__c createTransporteur(String name, String typeClient) {
        return new Transporteur__c(
            Name = name,
            Type_Client__c = typeClient
        );
    }

    public static TransporteurPrix__c createTarif(
        Id transporteurId,
        String pays,
        Decimal tarif,
        Integer delai
    ) {
        return new TransporteurPrix__c(
            Transporteur__c = transporteurId,
            Pays__c = pays,
            Tarifs__c = tarif,
            D_lai_de_Livraison_jours__c = delai
        );
    }

    public static Order createOrder(
        Id accountId,
        String name,
        String pays
    ) {
        return new Order(
            Name = name,
            AccountId = accountId,
            Status = 'Draft',
            EffectiveDate = Date.today(),
            Pays_Livraison__c = pays
        );
    }
}