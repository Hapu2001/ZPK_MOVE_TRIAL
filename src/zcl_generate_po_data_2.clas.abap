CLASS zcl_generate_po_data_2 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_generate_po_data_2 IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    " 1. Xóa dữ liệu cũ trong 2 bảng (tránh xung đột khóa chính)
    DELETE FROM zpoitem_2.
    DELETE FROM zpurchaseorder_2.

    " Lấy timestamp hiện tại đúng chuẩn ABAP
    DATA lv_timestamp TYPE timestampl.
    GET TIME STAMP FIELD lv_timestamp.

    " 2. Chuẩn bị dữ liệu cho Bảng Header: zpurchaseorder_2 (5 records)
    DATA lt_headers TYPE TABLE OF zpurchaseorder_2.

    lt_headers = VALUE #(
      ( client          = sy-mandt
        po_id           = '1000000001'
        vendor_id       = 'VEND000001'
        purch_org       = '1000'
        currency_code   = 'USD'
        total_amount    = '15000.00'
        status          = 'O' " Open
        po_date         = '20261001'
        delivery_date   = '20261028'
        discount_pct    = '5.00'
        created_by      = sy-uname
        last_changed_at = lv_timestamp )

      ( client          = sy-mandt
        po_id           = '1000000002'
        vendor_id       = 'VEND000002'
        purch_org       = '2000'
        currency_code   = 'EUR'
        total_amount    = '8500.00'
        status          = 'A' " Approved
        po_date         = '20261005'
        delivery_date   = '20261115'
        " discount_pct để trống (NULL) để test COALESCE
        created_by      = sy-uname
        last_changed_at = lv_timestamp )

      ( client          = sy-mandt
        po_id           = '1000000003'
        vendor_id       = 'VEND000001'
        purch_org       = '1000'
        currency_code   = 'USD'
        total_amount    = '4500.00'
        status          = 'B' " Blocked
        po_date         = '20261010'
        delivery_date   = '20261020' " Quá hạn (Overdue)
        discount_pct    = '2.50'
        created_by      = sy-uname
        last_changed_at = lv_timestamp )

      ( client          = sy-mandt
        po_id           = '1000000004'
        vendor_id       = 'VEND000003'
        purch_org       = '3000'
        currency_code   = 'VND'
        total_amount    = '120000.00'
        status          = 'X' " Cancelled
        po_date         = '20261012'
        delivery_date   = '20261025'
        discount_pct    = '10.00'
        created_by      = sy-uname
        last_changed_at = lv_timestamp )

      ( client          = sy-mandt
        po_id           = '1000000005'
        vendor_id       = 'VEND000002'
        purch_org       = '2000'
        currency_code   = 'EUR'
        total_amount    = '25000.00'
        status          = 'O' " Open
        po_date         = '20261015'
        delivery_date   = '20261201'
        " discount_pct để trống (NULL)
        created_by      = sy-uname
        last_changed_at = lv_timestamp )
    ).

    " 3. Chuẩn bị dữ liệu cho Bảng Item: zpoitem_2 (8 records)
    DATA lt_items TYPE TABLE OF zpoitem_2.

    lt_items = VALUE #(
      " Items cho PO 1
      ( client          = sy-mandt
        po_id           = '1000000001'
        item_id         = '00010'
        material_id     = 'MAT_RAW_01'
        quantity        = '150.000' " > 100 để test % Discount
        unit_of_measure = 'PC'
        currency_code   = 'USD'
        unit_price      = '50.00'
        net_value       = '7500.00'
        delivery_date   = '20261028'
        last_changed_at = lv_timestamp )

      ( client          = sy-mandt
        po_id           = '1000000001'
        item_id         = '00020'
        material_id     = 'MAT_RAW_02'
        quantity        = '50.000'
        unit_of_measure = 'PC'
        currency_code   = 'USD'
        unit_price      = '150.00'
        net_value       = '7500.00'
        delivery_date   = '20261028'
        last_changed_at = lv_timestamp )

      " Items cho PO 2
      ( client          = sy-mandt
        po_id           = '1000000002'
        item_id         = '00010'
        material_id     = 'MAT_PKG_01'
        quantity        = '800.000'
        unit_of_measure = 'KG'
        currency_code   = 'EUR'
        unit_price      = '10.00'
        net_value       = '8000.00'
        delivery_date   = '20261115'
        last_changed_at = lv_timestamp )

      ( client          = sy-mandt
        po_id           = '1000000002'
        item_id         = '00020'
        material_id     = 'MAT_PKG_02'
        quantity        = '10.000'
        unit_of_measure = 'BOX'
        currency_code   = 'EUR'
        unit_price      = '50.00'
        net_value       = '500.00' " < 1000 để test 'Low'
        delivery_date   = '20261115'
        last_changed_at = lv_timestamp )

      " Items cho PO 3
      ( client          = sy-mandt
        po_id           = '1000000003'
        item_id         = '00010'
        material_id     = 'MAT_RAW_01'
        quantity        = '90.000'
        unit_of_measure = 'PC'
        currency_code   = 'USD'
        unit_price      = '50.00'
        net_value       = '4500.00'
        delivery_date   = '20261020'
        last_changed_at = lv_timestamp )

      " Items cho PO 4
      ( client          = sy-mandt
        po_id           = '1000000004'
        item_id         = '00010'
        material_id     = 'MAT_SRV_01'
        quantity        = '1.000'
        unit_of_measure = 'AU'
        currency_code   = 'VND'
        unit_price      = '120000.00'
        net_value       = '120000.00' " > 10000 để test 'High'
        delivery_date   = '20261025'
        last_changed_at = lv_timestamp )

      " Items cho PO 5
      ( client          = sy-mandt
        po_id           = '1000000005'
        item_id         = '00010'
        material_id     = 'MAT_RAW_03'
        quantity        = '200.000'
        unit_of_measure = 'PC'
        currency_code   = 'EUR'
        unit_price      = '100.00'
        net_value       = '20000.00'
        delivery_date   = '20261201'
        last_changed_at = lv_timestamp )

      ( client          = sy-mandt
        po_id           = '1000000005'
        item_id         = '00020'
        material_id     = 'MAT_RAW_04'
        quantity        = '50.000'
        unit_of_measure = 'PC'
        currency_code   = 'EUR'
        unit_price      = '100.00'
        net_value       = '5000.00' " Trong khoảng 1000 - 10000 để test 'Medium'
        delivery_date   = '20261201'
        last_changed_at = lv_timestamp )
    ).

    " 4. Thực thi chèn dữ liệu vào 2 bảng
    INSERT zpurchaseorder_2 FROM TABLE @lt_headers.
    INSERT zpoitem_2 FROM TABLE @lt_items.

    " 5. Xuất thông báo kết quả ra ABAP Console
    IF sy-subrc = 0.
      out->write( 'Đã khởi tạo thành công dữ liệu mẫu cho cả 2 bảng Header và Items!' ).
      out->write( |Số dòng PO Headers: { lines( lt_headers ) }| ).
      out->write( |Số dòng PO Items: { lines( lt_items ) }| ).
    ELSE.
      out->write( 'Có lỗi khi insert dữ liệu vào database.' ).
    ENDIF.

  ENDMETHOD.
ENDCLASS.
