@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption View for PO Item'
@Metadata.allowExtensions: true
@VDM.viewType: #CONSUMPTION

define view entity ZC_POITEM_2
  as projection on ZI_POITEM_2
{
  key PoId,
  
      @UI.lineItem: [{ position: 10, label: 'Item No.' }]
      @UI.identification: [{ position: 10, label: 'Item No.' }]
  key ItemId,

      @UI.lineItem: [{ position: 20, label: 'Material ID' }]
      @UI.identification: [{ position: 20, label: 'Material ID' }]
      MaterialId,

      @UI.lineItem: [{ position: 30, label: 'Quantity' }]
      @UI.identification: [{ position: 30, label: 'Quantity' }]
      Quantity,

      @UI.lineItem: [{ position: 40, label: 'Unit' }]
      @UI.identification: [{ position: 40, label: 'Unit' }]
      UnitOfMeasure,

      @UI.lineItem: [{ position: 50, label: 'Currency' }]
      @UI.identification: [{ position: 50, label: 'Currency' }]
      CurrencyCode,

      @UI.lineItem: [{ position: 60, label: 'Unit Price' }]
      @UI.identification: [{ position: 60, label: 'Unit Price' }]
      UnitPrice,

      @UI.lineItem: [{ position: 70, label: 'Net Value' }]
      @UI.identification: [{ position: 70, label: 'Net Value' }]
      NetValue,

      @UI.lineItem: [{ position: 80, label: 'Delivery Date' }]
      @UI.identification: [{ position: 80, label: 'Delivery Date' }]
      DeliveryDate,

      @UI.lineItem: [{ position: 90, label: 'Plant' }]
      @UI.identification: [{ position: 90, label: 'Plant' }]
      Plant,

      ItemValueCategory,
      DiscountAmount,

      _Header : redirected to parent ZC_PURCHASEORDER_2
}
