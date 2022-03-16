with gl_account as (

    select *
    from {{ref('stg_sage_intacct__gl_account')}}

), final as (

    select

    account_no,
    account_type,
    category,
    closing_account_title,
    
    -- Do we also want to bring through the passthrough columns from the staging model here?
    
    -- Refer to my comment in the PR about possible idea for customizing this.
    case
        when category in {{ var('sage_intacct_category_assets') }} then 'Asset'
        when category in ('Partners Equity','Retained Earnings','Dividend Paid') then 'Equity'
        when category in ('Advertising and Promotion Expense','Other Operating Expense','Cost of Sales Revenue', 'Professional Services Expense','Cost of Services Revenue','Payroll Expense','Payroll Taxes','Travel Expense','Cost of Goods Sold','Other Expenses','Compensation Expense','Federal Tax','Depreciation Expense') then 'Expense'
        when category in ('Accounts Payable','Other Current Liabilities','Accrued Liabilities','Note Payable - Current','Deferred Taxes Liabilities - Long Term','Note Payable - Long Term','Other Liabilities','Deferred Revenue - Current') then 'Liability'
        when category in ('Revenue','Revenue - Sales','Dividend Income','Revenue - Other','Other Income','Revenue - Services','Revenue - Products') then 'Revenue'
        when (normal_balance = 'credit' and account_type = 'balancesheet' and category not in ('Partners Equity','Retained Earnings','Dividend Paid')) then 'Liability'
        when (normal_balance = 'debit' and account_type = 'balancesheet') then 'Asset'
        when (normal_balance = 'credit' and account_type = 'incomestatement') then 'Revenue'
        when (normal_balance = 'debit' and account_type = 'incomestatement') then 'Expense'
    end as classification 

    --The below script allows for pass through columns.
    {% if var('sage_account_pass_through_columns') %} 
    ,
    {{ var('sage_account_pass_through_columns') | join (", ")}}

    {% endif %}


    from gl_account
)

select *
from final