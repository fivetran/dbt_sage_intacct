with gl_detail as (
    select * 
    from {{ var('gl_detail') }} 
),

gl_account as (
    select * 
    from {{ var('gl_account')}} 
),

enhanced_general_ledger as (

    select 

    gld.record_no,
    gld.account_no,
    gld.account_title,
    gld.amount,
    gld.batch_date,
    gld.batch_no,
    gld.batch_title,
    gld.batch_key,
    gld.book_id,
    gld.credit_amount,
    gld.debit_amount,
    gld.department_id,
    gld.department_title
    gld.description,
    gld.docnumber,
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
    case
        when gla.category in ('Inventory','Fixed Assets','Other Current Assets','Cash and Cash Equivalents','Intercompany Receivable','Accounts Receivable','Deposits and Prepayments','Goodwill','Intangible Assets','Short-Term Investments','Inventory','Accumulated Depreciation','Other Assets','Unrealized Currency Gain/Loss','Patents','Investment in Subsidiary','Escrows and Reserves','Long Term Investments') then 'Asset'
        when gla.category in ('Partners Equity','Retained Earnings') then 'Equity'
        when gla.category in ('Other Operating Expense','Cost of Sales Revenue', 'Professional Services Expense','Cost of Services Revenue','Payroll Expense','Travel Expense','Cost of Goods Sold','Other Expenses','Compensation Expense','Federal Tax','Dividend Paid') then 'Expense'
        when gla.category in ('Accounts Payable','Other Current Liabilities','Payroll Taxes','Accrued Liabilities','Note Payable - Current','Deferred Taxes Liabilities - Long Term','Note Payable - Long Term','Other Liabilities') then 'Liability'
        when gla.category in ('Revenue - Sales','Dividend Income','Deferred Revenue - Current','Revenue - Other','Other Income','Revenue - Services','Revenue - Products') then 'Revenue'
    end as classification 


    from gl_detail
    left join gl_account
    on gl_detail.account_no = gl_account.account_no 
)

select * 
from enhanced_general_ledger
