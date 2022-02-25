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

	ap_bill.



    from ap_bill
    -- left join gl_detail
    --     on ap_bill.record_id = gl_detail.record_id
    left join ap_bill_item 
        on ap_bill.record_no = ap_bill_item.record_key
),

ar_invoice_enhanced as (

    select 


    from ar_invoice 
    left join ar_invoice_item
    on ar_invoice.record_no = ar_invoice_item.recordkey

),

ap_ar_enhanced as (

    select * 
    from ap_bill_enhanced
    union 
    select * 
    from ar_invoice_enhanced

)

select * from ap_ar_enhanced




/*
AP/AR:
- how much owed to each vendor
- amount of time since invoice was created /  collect recievables
- any past due (1 0 , days past due, days bw created/paid)


Else:
- whether it's a bill or invoice 
- how many items per bill or invoice


additional tables:
- ap advance: currency, docnumber, documentnumber, financialaccount, 
- ap advance item: departmentid, departmentkey, departmentname, exchange rate, line_no, lineitem, 
- ap bill: due_in_days, 




*/ 
