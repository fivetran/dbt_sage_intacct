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

-- with gl_detail as (
--     select * 
--     from {{ ref('stg_sage_intacct__gl_detail') }} 
-- ),

-- gl_account as (
--     select * 
--     from {{ ref('int_sage_intacct__account_classifications') }} 
-- ),


ap_bill_enhanced as (

    select

    ap_bill_item.bill_id,
    ap_bill_item.bill_item_id,
    cast(null as string) as invoice_id,
    cast(null as string) as invoice_item_id,
    ap_bill_item.accounttitle,
    ap_bill_item.amount,
    ap_bill_item.classid,
    ap_bill_item.classname,
    ap_bill_item.currency,
    ap_bill_item.customerid,
    ap_bill_item.customername,
    ap_bill_item.departmentid,
    ap_bill_item.departmentname,
    ap_bill_item.entry_date,
    ap_bill_item.entrydescription,
    ap_bill_item.itemid,
    ap_bill_item.itemname,
    ap_bill_item.line_no,
    ap_bill_item.lineitem,
    ap_bill_item.locationid,
    ap_bill_item.locationname,
    ap_bill_item.offsetglaccountno,
    ap_bill_item.offsetglaccounttitle,
    ap_bill_item.totalpaid,
    ap_bill_item.vendorid,
    ap_bill_item.vendorname,
    ap_bill_item.whencreated,
    ap_bill_item.whenmodified,
    ap_bill_item.projectname,
    ap_bill_item.projectid,
    cast(null as string) as warehouseid,
    cast(null as string) as warehousename,
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
    ar_invoice_item.accounttitle,
    ar_invoice_item.amount,
    ar_invoice_item.classid,
    ar_invoice_item.classname,
    ar_invoice_item.currency,
    ar_invoice_item.customerid,
    ar_invoice_item.customername,
    ar_invoice_item.departmentid,
    ar_invoice_item.departmentname,
    ar_invoice_item.entry_date,
    ar_invoice_item.entrydescription,
    ar_invoice_item.itemid,
    ar_invoice_item.itemname,
    ar_invoice_item.line_no,
    ar_invoice_item.lineitem,
    ar_invoice_item.locationid,
    ar_invoice_item.locationname,
    ar_invoice_item.offsetglaccountno,
    ar_invoice_item.offsetglaccounttitle,
    ar_invoice_item.totalpaid,
    ar_invoice_item.vendorid,
    ar_invoice_item.vendorname,
    ar_invoice_item.whencreated,
    ar_invoice_item.whenmodified,
    cast(null as string) as projectname,
    cast(null as string) as projectid,
    ar_invoice_item.warehouseid,
    ar_invoice_item.warehousename,
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

