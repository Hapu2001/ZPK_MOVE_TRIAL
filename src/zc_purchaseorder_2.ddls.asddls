define root view entity ZC_PURCHASEORDER_2
  provider contract transactional_query
  as projection on ZI_PURCHASEORDER_2
{
      @UI.facet: [
        { id: 'POHeader', type: #IDENTIFICATION_REFERENCE, label: 'PO Information', position: 10 },
        { id: 'POItems', type: #LINEITEM_REFERENCE, label: 'Order Items', position: 20, targetElement: '_Items' }
      ]

      // Thêm nút bấm Action để test
      @UI.lineItem: [
        { position: 10, label: 'PO ID' },
      { type: #FOR_ACTION, dataAction: 'rejectPurchaseOrder', label: 'Reject Purchase Order', invocationGrouping: #ISOLATED }
      ]
      @UI.identification: [{ position: 10, label: 'PO ID' }]
      @Search.defaultSearchElement: true
  key PoId,

      @Search.defaultSearchElement: true
      @UI.lineItem: [{ position: 20, label: 'Vendor ID' }]
      @UI.identification: [{ position: 20, label: 'Vendor ID' }]
      VendorId,

      @UI.lineItem: [{ position: 30, label: 'Purch Org' }]
      @UI.identification: [{ position: 30, label: 'Purch Org' }]
      PurchOrg,

      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_CurrencyStdVH', element: 'Currency' }, useForValidation: true }]
      @UI.lineItem: [{ position: 40, label: 'Currency' }]
      @UI.identification: [{ position: 40, label: 'Currency' }]
      CurrencyCode,

      @UI.lineItem: [{ position: 50, label: 'Total Amount' }]
      @UI.identification: [{ position: 50, label: 'Total Amount' }]
      TotalAmount,

      @ObjectModel.text.element: ['StatusText']
      @UI.lineItem: [{ position: 60, label: 'Status' }]
      @UI.identification: [{ position: 60, label: 'Status' }]
      Status,

      @UI.lineItem: [{ position: 70, label: 'PO Date' }]
      @UI.identification: [{ position: 70, label: 'PO Date' }]
      PoDate,

      @UI.lineItem: [{ position: 80, label: 'Delivery Date' }]
      @UI.identification: [{ position: 80, label: 'Delivery Date' }]
      DeliveryDate,

      VendorDisplay,
      StatusText,
      UrgencyFlag,

      _Items : redirected to composition child ZC_POITEM_2
}
