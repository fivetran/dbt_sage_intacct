with ap_bill as (
    select * 
    from {{ ref('stg_sage_intacct__ap_bill') }} 
),

ap_bill_item as (
    select * 
    from {{ ref('stg_sage_intacct__ap_bill_item') }} 
),

ar_invoice as (
    select * 
    from {{ ref('stg_sage_intacct__ar_invoice') }} 
),

ar_invoice_item as (
    select * 
    from {{ ref('stg_sage_intacct__ar_invoice_item') }} 
),

ap_bill_enhanced as (

    select

    ap_bill_item.bill_id,
    ap_bill_item.bill_item_id,
    cast(null as string) as invoice_id,
    cast(null as string) as invoice_item_id,
    ap_bill_item.account_title,
    ap_bill_item.amount,
    ap_bill_item.class_id,
    ap_bill_item.class_name,
    ap_bill_item.currency,
    ap_bill_item.customer_id,
    ap_bill_item.customer_name,
    ap_bill_item.department_id,
    ap_bill_item.department_name,
    ap_bill_item.entry_date,
    ap_bill_item.entry_description,
    ap_bill_item.item_id,
    ap_bill_item.item_name,
    ap_bill_item.line_no,
    ap_bill_item.line_item,
    ap_bill_item.location_id,
    ap_bill_item.location_name,
    ap_bill_item.offset_gl_account_no,
    ap_bill_item.offset_gl_account_title,
    ap_bill_item.total_item_paid,
    ap_bill_item.vendor_id,
    ap_bill_item.vendor_name,
    ap_bill_item.when_created,
    ap_bill_item.when_modified,
    ap_bill_item.project_name,
    ap_bill_item.project_id,
    cast(null as string) as warehouse_id,
    cast(null as string) as warehouse_name,
	ap_bill.due_in_days,
    ap_bill.total_due,
    ap_bill.total_entered,
    ap_bill.total_paid,
    count(*) over (partition by ap_bill_item.bill_id) as number_of_items

    from ap_bill_item
    -- left join gl_detail
    --     on ap_bill.record_id = gl_detail.record_id
    left join ap_bill
        on ap_bill_item.bill_id = ap_bill.bill_id
),

ar_invoice_enhanced as (

    select 
    cast(null as string) as bill_id,
    cast(null as string) as bill_item_id,
    ar_invoice_item.invoice_id,
    ar_invoice_item.invoice_item_id,
    ar_invoice_item.account_title,
    ar_invoice_item.amount,
    ar_invoice_item.class_id,
    ar_invoice_item.class_name,
    ar_invoice_item.currency,
    ar_invoice_item.customer_id,
    ar_invoice_item.customer_name,
    ar_invoice_item.department_id,
    ar_invoice_item.department_name,
    ar_invoice_item.entry_date,
    ar_invoice_item.entry_description,
    ar_invoice_item.item_id,
    ar_invoice_item.item_name,
    ar_invoice_item.line_no,
    ar_invoice_item.line_item,
    ar_invoice_item.location_id,
    ar_invoice_item.location_name,
    ar_invoice_item.offset_gl_account_no,
    ar_invoice_item.offset_gl_account_title,
    ar_invoice_item.total_item_paid,
    ar_invoice_item.vendor_id,
    ar_invoice_item.vendor_name,
    ar_invoice_item.when_created,
    ar_invoice_item.when_modified,
    cast(null as string) as project_name,
    cast(null as string) as project_id,
    ar_invoice_item.warehouse_id,
    ar_invoice_item.warehouse_name,
    ar_invoice.due_in_days,
    ar_invoice.total_due,
    ar_invoice.total_entered,
    ar_invoice.total_paid,
    count(*) over (partition by ar_invoice_item.invoice_id) as number_of_items

    from ar_invoice_item
    left join ar_invoice
        on ar_invoice_item.invoice_id = ar_invoice.invoice_id

),

ap_ar_enhanced as (

    select * 
    from ap_bill_enhanced
    union all
    select * 
    from ar_invoice_enhanced

)

select 

    *, 
    case 
        when bill_id is not null then 'bill' 
        when invoice_id is not null then 'invoice'
    end as document_type

from ap_ar_enhanced

