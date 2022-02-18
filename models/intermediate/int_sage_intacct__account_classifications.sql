with gl_account as (
    select *
    from {{ref('stg_sage_intacct__gl_account')}}
)

select

account_no,
account_type,
category,
-- cf_fs_group_3 as classification,
closing_account_title,
    case
        when category in ('Inventory','Fixed Assets','Other Current Assets','Cash and Cash Equivalents','Intercompany Receivable','Accounts Receivable','Deposits and Prepayments','Goodwill','Intangible Assets','Short-Term Investments','Inventory','Accumulated Depreciation','Other Assets','Unrealized Currency Gain/Loss','Patents','Investment in Subsidiary','Escrows and Reserves','Long Term Investments') then 'Asset'
        when category in ('Partners Equity','Retained Earnings','Dividend Paid') then 'Equity'
        when category in ('Advertising and Promotion Expense','Other Operating Expense','Cost of Sales Revenue', 'Professional Services Expense','Cost of Services Revenue','Payroll Expense','Payroll Taxes','Travel Expense','Cost of Goods Sold','Other Expenses','Compensation Expense','Federal Tax','Depreciation Expense') then 'Expense'
        when category in ('Accounts Payable','Other Current Liabilities','Accrued Liabilities','Note Payable - Current','Deferred Taxes Liabilities - Long Term','Note Payable - Long Term','Other Liabilities','Deferred Revenue - Current') then 'Liability'
        when category in ('Revenue','Revenue - Sales','Dividend Income','Revenue - Other','Other Income','Revenue - Services','Revenue - Products') then 'Revenue'
    end as classification 

from gl_account