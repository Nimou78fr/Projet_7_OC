trigger OrderTrigger on Order (before update) {
    for (Order o : Trigger.new) {
        Order old = Trigger.oldMap.get(o.Id);
        if (old.Status != 'Activated' && o.Status == 'Activated') {
            
            Integer nb = [SELECT COUNT() FROM OrderItem WHERE OrderId = :o.Id];
            Account acc = [SELECT Type_Client__c FROM Account WHERE Id = :o.AccountId];

            if (acc.Type_Client__c == 'Particulier' && nb < 3) {
                o.addError('Minimum 3 produits requis');
            }
            if (acc.Type_Client__c == 'Professionnel' && nb < 5) {
                o.addError('Minimum 5 produits requis');
            }
        }
    }
}
