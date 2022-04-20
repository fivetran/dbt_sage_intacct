with general_ledger_balances as (
    select *
    from {{ ref('int_sage_intacct__general_ledger_balances') }}
), 

general_ledger_by_period as (
    select 
        period_first_day,
        period_last_day,
        date_year, 
        account_no,
        account_title,
        account_type,
        book_id,
        category,
        classification,
        currency,
        entry_state

        {% if var('sage_account_pass_through_columns') %} 
        , 
        {{ var('sage_account_pass_through_columns') | join (", ")}}

        {% endif %}
        ,
        round(cast(period_net_amount as {{ dbt_utils.type_numeric() }}),2) as period_net_amount,
        round(cast(period_beg_amount as {{ dbt_utils.type_numeric() }}),2) as period_beg_amount,
        round(cast(period_ending_amount as {{ dbt_utils.type_numeric() }}),2) as period_ending_amount
    from general_ledger_balances
),

general_ledger_by_period_retained_earnings_tmp as (
    select
        period_first_day,
        period_last_day,
        date_year


        {% if var('sage_account_pass_through_columns') %} 
        , 
        {{ var('sage_account_pass_through_columns') | join (", null as")}}

        {% endif %}
        ,
        
        'Adj. Net Income' as account_no,
        'Retained Earnings' as account_title,
        'balancesheet' as account_type,
        'ACCRUAL' as book_id,
        'Retained Earnings' as category,
        'Equity' as classification,
        'currency' as currency,
        'P' as entry_state,
        sum(period_net_amount) as period_net_amount,
        sum(period_beg_amount) as period_beg_amount,
        sum(period_ending_amount) as period_ending_amount
    from general_ledger_by_period
    where account_type = 'incomestatement'
    {{ dbt_utils.group_by(3 + var('sage_account_pass_through_columns')|length) }}
),

general_ledger_by_period_retained_earnings as (
    select
        period_first_day,
        period_last_day,
        date_year, 
        'Adj. Net Income' as account_no,
        'Retained Earnings' as account_title,
        'balancesheet' as account_type,
        'ACCRUAL' as book_id,
        'Retained Earnings' as category,
        'Equity' as classification,
        'currency' as currency,
        'P' as entry_state

        {% if var('sage_account_pass_through_columns') %} 
        , 
        {{ var('sage_account_pass_through_columns') | join (", null as")}}

        {% endif %}
        ,
        null as period_net_amount,
        null as period_beg_amount,
        sum(period_net_amount) over (
            order by period_first_day
        ) as period_ending_amount
    from general_ledger_by_period_retained_earnings_tmp
    order by period_first_day
),

final as (
    select *
    from general_ledger_by_period
    union all
    select *
    from general_ledger_by_period_retained_earnings
)

select * 
from final 
