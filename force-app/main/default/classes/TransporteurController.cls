public with sharing class TransporteurController {

    @AuraEnabled(cacheable=true)
    public static Transporteur__c getTransporteur(String pays, String critere){
        return TransporteurService.getBestTransporteur(pays, critere);
    }
     @AuraEnabled(cacheable=true)
    public static TransporteurPrix__c getBestTransporteurMoinsCher(String pays,String orderId){
        return TransporteurService.getBestTransporteurMoinsCher(pays,orderId);
    }
     @AuraEnabled(cacheable=true)
    public static TransporteurPrix__c getBestTransporteurPlusRapide(String pays,String orderId){
        return TransporteurService.getBestTransporteurPlusRapide(pays,orderId);
    }
    @AuraEnabled(cacheable=true)
    public static list<TransporteurPrix__c> getAllTransporteurs(String pays,String orderId){
        return TransporteurService.getAllTransporteurs(pays,orderId);
    }
    @AuraEnabled
public static void updateOrderTransporteur(String orderId, TransporteurPrix__c transporteurPrix){
    /*Order o = new Order(
        Id = orderId,
        Transporteur__c = transporteurPrix.Transporteur__r.Name
    );
    update o;*/
    list<Livraison__c> lvr=[Select id from Livraison__c where Order__c = :orderId limit 1];
    Livraison__c tmpLvr;
    if(lvr.size() > 0){
        tmpLvr = lvr[0];
        tmpLvr.Order__c=orderId;
        tmpLvr.Pays__c=transporteurPrix.Pays__c;
        tmpLvr.Statut__c='En cours';
        tmpLvr.Tarifs__c=transporteurPrix.Tarifs__c;
        tmpLvr.Transporteur__c=transporteurPrix.Transporteur__c;
        tmpLvr.D_lai_de_Livraison_jours__c=transporteurPrix.D_lai_de_Livraison_jours__c;
        update tmpLvr;
    }else{
        tmpLvr=new Livraison__c();
        tmpLvr.Order__c=orderId;
        tmpLvr.Pays__c=transporteurPrix.Pays__c;
        tmpLvr.Statut__c='En cours';
        tmpLvr.Tarifs__c=transporteurPrix.Tarifs__c;
        tmpLvr.Transporteur__c=transporteurPrix.Transporteur__c;
        tmpLvr.D_lai_de_Livraison_jours__c=transporteurPrix.D_lai_de_Livraison_jours__c;
        insert tmpLvr;
    }


}
}