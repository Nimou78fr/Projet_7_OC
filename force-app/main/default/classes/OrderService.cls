public with sharing class OrderService {

    public static void validateOrders(List<Order> newOrders, Map<Id, Order> oldOrders) {

        List<Id> orderIds = new List<Id>();
        Map<Id, Order> newOrderMap = new Map<Id, Order>();

        for (Order o : newOrders) {
            newOrderMap.put(o.Id, o);

            Order old = oldOrders.get(o.Id);

            if (old != null && old.Status != 'Activated' && o.Status == 'Activated') {
                orderIds.add(o.Id);
            }
        }

        if (orderIds.isEmpty()) {
            return;
        }

        List<Order> ordersToCheck = [
            SELECT Id, Account.Type_Client__c, nbr_produit__c, Status
            FROM Order
            WHERE Id IN :orderIds
        ];

        for (Order o : ordersToCheck) {

            // Sécurité null
            Integer nbProduits = (o.nbr_produit__c == null) ? 0 : Integer.valueOf(o.nbr_produit__c);

            if (o.Account.Type_Client__c == 'Particulier' && nbProduits < 3) {
                newOrderMap.get(o.Id).addError('Minimum 3 produits requis pour un particulier');
            }

            if (o.Account.Type_Client__c == 'Professionnel' && nbProduits < 5) {
                newOrderMap.get(o.Id).addError('Minimum 5 produits requis pour un professionnel');
            }
        }
    }
}