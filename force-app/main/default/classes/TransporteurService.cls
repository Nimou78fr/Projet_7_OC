public with sharing class TransporteurService {

    public static Transporteur__c getBestTransporteur(String pays, String critere){

        /*List<Transporteur__c> transporteurs = [
            SELECT Name, Prix__c, Delai__c
            FROM Transporteur__c
            WHERE Pays__c = :pays
        ];

        Transporteur__c best;

        for(Transporteur__c t : transporteurs){

            if(best == null){
                best = t;
            } else {

                if(critere == 'Prix' && t.Prix__c < best.Prix__c){
                    best = t;
                }

                if(critere == 'Delai' && t.Delai__c < best.Delai__c){
                    best = t;
                }
            }
        }*/

        return null;
    }
    public static list<TransporteurPrix__c> getAllTransporteurs(String pays,String orderId){
        Order acc=[Select id,Account.Type_Client__c from Order where Id=:orderId limit 1];
        return [SELECT Name, Tarifs__c, Pays__c,D_lai_de_Livraison_jours__c,Transporteur__r.Name,Transporteur__r.Type_Client__c FROM TransporteurPrix__c WHERE Pays__c = :pays AND Transporteur__r.Type_Client__c INCLUDES(:acc.Account.Type_Client__c) ORDER BY Tarifs__c,D_lai_de_Livraison_jours__c Desc];
    }
    public static TransporteurPrix__c getBestTransporteurMoinsCher(String pays,String orderId){
        Order acc=[Select id,Account.Type_Client__c from Order where Id=:orderId limit 1];
        return [SELECT Name, Tarifs__c, Pays__c,D_lai_de_Livraison_jours__c,Transporteur__r.Name,Transporteur__r.Type_Client__c FROM TransporteurPrix__c WHERE Pays__c = :pays AND Transporteur__r.Type_Client__c INCLUDES(:acc.Account.Type_Client__c) ORDER BY Tarifs__c ASC LIMIT 1];
    }
    public static TransporteurPrix__c getBestTransporteurPlusRapide(String pays,String orderId){
        Order acc=[Select id,Account.Type_Client__c from Order where Id=:orderId limit 1];
        return [SELECT Name, Tarifs__c, Pays__c,D_lai_de_Livraison_jours__c,Transporteur__r.Name,Transporteur__r.Type_Client__c FROM TransporteurPrix__c WHERE Pays__c = :pays AND Transporteur__r.Type_Client__c INCLUDES(:acc.Account.Type_Client__c) ORDER BY D_lai_de_Livraison_jours__c ASC LIMIT 1];
    }
}