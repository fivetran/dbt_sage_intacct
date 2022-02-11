with gl_detail as (
    select * 
    from {{ ref('stg_sage_intacct__gl_detail') }} 
),

gl_account as (
    select * 
    from {{ ref('int_sage_intacct__account_classifications') }} 
),

general_ledger as (

    select 

    gld.record_no,
    gld.account_no,
    gld.account_title,
    gld.amount,
    gld.book_id,
    gld.credit_amount,
    gld.debit_amount,
    gld.department_id,
    gld.department_title,
    gld.description,
    gld.doc_number,
    gld.entry_date,
    gld.entry_state,
    gld.entry_description,
    gld.line_no,
    gld.modified,
    gld.record_id,
    gld.record_type,
    gld.total_due,
    gld.total_entered,
    gld.total_paid,
    gld.tr_type,
    gld.trx_amount,
    gld.trx_creditamount,
    gld.trx_debitamount,
    gld.when_created,
    gld.when_due,
    gld.when_modified,
    gld.when_paid,
    gla.category,
    gla.classification,
    gla.account_type 

    from gl_detail gld
    left join gl_account gla
    on gld.account_no = gla.account_no 
)

select * from general_ledger
