trigger OrderTrigger on Order (before update) {
    if (Trigger.isBefore && Trigger.isUpdate) {
        OrderService.validateOrders(Trigger.new, Trigger.oldMap);
    }
}