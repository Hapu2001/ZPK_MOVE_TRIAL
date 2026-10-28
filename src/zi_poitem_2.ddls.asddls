@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Basic View for PO Item'
@Metadata.allowExtensions: true
define view entity ZI_POITEM_2
  as select from zpoitem_2
  association to parent ZI_PURCHASEORDER_2 as _Header 
    on $projection.PoId = _Header.PoId
{
  key po_id           as PoId,
  key item_id         as ItemId,
      material_id     as MaterialId,
      quantity        as Quantity,
      unit_of_measure as UnitOfMeasure,
      currency_code   as CurrencyCode,
      
      cast( unit_price as abap.dec(15,2) ) as UnitPrice,
      cast( net_value as abap.dec(15,2) )   as NetValue,
      
      delivery_date   as DeliveryDate,
      plant           as Plant,

      case 
        when net_value < 1000 then 'Low'
        when net_value < 10000 then 'Medium'
        else 'High'
      end as ItemValueCategory,

      case 
        when quantity > cast( 100 as abap.quan(13,3) )
        then cast( unit_price as abap.dec(15,2) ) * cast( 5 as abap.dec(5,2) ) / cast( 100 as abap.dec(5,2) )
        else cast( 0 as abap.dec(15,2) )
      end as DiscountAmount,

      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at as LastChangedAt,
      
      _Header
}
