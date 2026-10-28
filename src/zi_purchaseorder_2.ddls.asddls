@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Basic View for PO Header'
@Metadata.allowExtensions: true
define root view entity ZI_PURCHASEORDER_2
  as select from zpurchaseorder_2 as PO
  composition [0..*] of ZI_POITEM_2 as _Items
{
  key po_id         as PoId,
      vendor_id     as VendorId,
      purch_org     as PurchOrg,
      currency_code as CurrencyCode,
      total_amount  as TotalAmount,
      status        as Status,
      po_date       as PoDate,
      delivery_date as DeliveryDate,
      discount_pct  as DiscountPct,

      // Đã sửa chính xác thành dấu nhân (*)
      cast( total_amount as abap.dec(15,2) ) 
      * cast( 10 as abap.dec(5,2) ) 
      / cast( 100 as abap.dec(5,2) ) as TaxAmount,

      cast( total_amount as abap.dec(15,2) ) + ( cast( total_amount as abap.dec(15,2) ) * cast( 10 as abap.dec(5,2) ) / cast( 100 as abap.dec(5,2) ) ) as TotalWithTax,
      coalesce( discount_pct, cast( 0 as abap.dec(5,2) ) ) as EffectiveDiscount,
      concat_with_space( purch_org, vendor_id, 1 ) as VendorDisplay,

      case status
        when 'O' then 'Open'
        when 'A' then 'Approved'
        when 'X' then 'Cancelled'
        when 'B' then 'Blocked'
        else 'Unknown'
      end as StatusText,

      dats_days_between( $session.system_date, delivery_date ) as DaysToDelivery,

      case 
        when dats_days_between( $session.system_date, delivery_date ) < 0 then 'Overdue'
        when dats_days_between( $session.system_date, delivery_date ) between 0 and 7 then 'Urgent'
        when dats_days_between( $session.system_date, delivery_date ) between 8 and 30 then 'Normal'
        else 'Low'
      end as UrgencyFlag,
      
      _Items
}
