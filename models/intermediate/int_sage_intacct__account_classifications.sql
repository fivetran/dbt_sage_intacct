with gl_account as (
    select *
    from {{ref('stg_sage_intacct__gl_account')}}
),

select

account_no,
account_type,
category,
    case
        when gla.category in ('Inventory','Fixed Assets','Other Current Assets','Cash and Cash Equivalents','Intercompany Receivable','Accounts Receivable','Deposits and Prepayments','Goodwill','Intangible Assets','Short-Term Investments','Inventory','Accumulated Depreciation','Other Assets','Unrealized Currency Gain/Loss','Patents','Investment in Subsidiary','Escrows and Reserves','Long Term Investments') then 'Asset'
        when gla.category in ('Partners Equity','Retained Earnings') then 'Equity'
        when gla.category in ('Other Operating Expense','Cost of Sales Revenue', 'Professional Services Expense','Cost of Services Revenue','Payroll Expense','Travel Expense','Cost of Goods Sold','Other Expenses','Compensation Expense','Federal Tax','Dividend Paid') then 'Expense'
        when gla.category in ('Accounts Payable','Other Current Liabilities','Payroll Taxes','Accrued Liabilities','Note Payable - Current','Deferred Taxes Liabilities - Long Term','Note Payable - Long Term','Other Liabilities') then 'Liability'
        when gla.category in ('Revenue - Sales','Dividend Income','Deferred Revenue - Current','Revenue - Other','Other Income','Revenue - Services','Revenue - Products') then 'Revenue'
    end as classification 

from gl_account