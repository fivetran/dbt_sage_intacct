with gl_account as (

    select *
    from {{ref('stg_sage_intacct__gl_account')}}

), final as (

    select

    account_no,
    account_type,
    category,
    closing_account_title,
    case
        when category in {{ var('sage_intacct_category_asset') }} then 'Asset'
        when category in {{ var('sage_intacct_category_equity') }} then 'Equity'
        when category in {{ var('sage_intacct_category_expense') }} then 'Expense'
        when category in {{ var('sage_intacct_category_liability') }} then 'Liability'
        when category in {{ var('sage_intacct_category_revenue') }} then 'Revenue'
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