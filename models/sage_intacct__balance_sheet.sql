with general_ledger as (
    select *
    from {{ ref('sage_intacct__general_ledger') }}
)

select 
    entry_date,
    account_no,
    DATETIME_TRUNC(entry_date, month) as entry_month,
    DATETIME_TRUNC(entry_date, year) as entry_year,
    batch_key, -- ?? is this the offsetting id?
    classification,
    category,
    sum(credit_amount) as creditamount,
    sum(debit_amount) as debitamount,
    sum(amount) as amount

    from general_ledger

    group by entry_date, account_no, batch_key, classification, category
    order by DATETIME_TRUNC(entry_date, month)
