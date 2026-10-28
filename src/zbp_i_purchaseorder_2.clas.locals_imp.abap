*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
CLASS lhc_PurchaseOrder DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

   METHODS rejectPurchaseOrder FOR MODIFY
      IMPORTING keys FOR ACTION PurchaseOrder~rejectPurchaseOrder RESULT result.

ENDCLASS.

CLASS lhc_PurchaseOrder IMPLEMENTATION.

  METHOD rejectPurchaseOrder.
    " 1. Đọc thông tin Purchase Order từ keys
    READ ENTITIES OF ZI_PURCHASEORDER_2 IN LOCAL MODE
      ENTITY PurchaseOrder
        FIELDS ( Status ) WITH CORRESPONDING #( keys )
      RESULT DATA(lt_purchase_orders).

    " 2. Cập nhật trạng thái thành 'REJECTED'
    MODIFY ENTITIES OF ZI_PURCHASEORDER_2 IN LOCAL MODE
      ENTITY PurchaseOrder
        UPDATE FIELDS ( Status )
        WITH VALUE #( FOR ls_po IN lt_purchase_orders
                      ( %tky   = ls_po-%tky
                        Status = 'REJECTED' ) ).

    " 3. Trả về kết quả cho UI
    READ ENTITIES OF ZI_PURCHASEORDER_2 IN LOCAL MODE
      ENTITY PurchaseOrder
        ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_updated_pos).

    result = VALUE #( FOR ls_up IN lt_updated_pos
                      ( %tky   = ls_up-%tky
                        %param = ls_up ) ).
  ENDMETHOD.

ENDCLASS.
