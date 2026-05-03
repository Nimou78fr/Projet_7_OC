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
public static void updateOrderTransporteur(String orderId, String transporteurName){
    Order o = new Order(
        Id = orderId,
        Transporteur__c = transporteurName
    );
    update o;
}
}