-- prep for balance sheet

with general_ledger as (
    select *
    from {{ref('sage_intacct__general_ledger')}}
),

gl_accounting_periods as (
    select *
    from {{ref('int_sage_intacct__general_ledger_date_spine')}}
),

gl_period_balances as (
select 
account_no,
account_title,
category,
classification,
financial_statement_helper,
date_trunc(entry_date,month) as date_month,
date_trunc(entry_date,year) as date_year,
sum(amount) as period_amount

from general_ledger
group by 1,2,3,4,5,6,7
),

gl_cumulative_balances as (
    select 
    *,
    case when financial_statement_helper = 'balance_sheet'
        then sum(period_amount) over (partition by account_no order by date_month, account_no rows unbounded preceding)
        else 0 
        end as cumulative_amount
    from gl_period_balances
),

gl_beginning_balance as (
    select 
    *,
    case when financial_statement_helper = 'balance_sheet'
        then (cumulative_amount - period_amount)
        else 0 
        end as period_beg_amount,
    period_amount as period_net_amount, 
    cumulative_amount as period_ending_amount

    from gl_cumulative_balances
),

gl_patch as (
    select 
        coalesce(gl_beginning_balance.account_no, gl_accounting_periods.account_no) as account_no,
        coalesce(gl_beginning_balance.account_title, gl_accounting_periods.account_title) as account_title,
        coalesce(gl_beginning_balance.category, gl_accounting_periods.category) as category,
        coalesce(gl_beginning_balance.classification, gl_accounting_periods.classification) as classification,
        coalesce(gl_beginning_balance.financial_statement_helper, gl_accounting_periods.financial_statement_helper) as financial_statement_helper,
        coalesce(gl_beginning_balance.date_year, gl_accounting_periods.date_year) as date_year,
        gl_accounting_periods.period_first_day,
        gl_accounting_periods.period_last_day,
        gl_accounting_periods.period_index,
        gl_beginning_balance.period_net_amount,
        gl_beginning_balance.period_beg_amount,
        gl_beginning_balance.period_ending_amount,
        case when gl_beginning_balance.period_beg_amount is null and period_index = 1
            then 0
            else gl_beginning_balance.period_beg_amount
                end as period_beg_amount_starter,
        case when gl_beginning_balance.period_ending_amount is null and period_index = 1
            then 0
            else gl_beginning_balance.period_ending_amount
                end as period_ending_amount_starter
    from gl_accounting_periods

    left join gl_beginning_balance
        on gl_beginning_balance.account_no = gl_accounting_periods.account_no
            and gl_beginning_balance.date_month = gl_accounting_periods.period_first_day
            and gl_beginning_balance.date_year = gl_accounting_periods.date_year
),

gl_value_partion as (
    select
        *,
        sum(case when period_ending_amount_starter is null 
            then 0 
            else 1 
                end) over (order by account_no, period_last_day rows unbounded preceding) as gl_partition
    from gl_patch

),

final as (
    select
        account_no,
        account_title,
        category,
        classification,
        financial_statement_helper,
        date_year, -- why not date_month?
        period_first_day,
        period_last_day,
        coalesce(period_net_amount,0) as period_net_amount,
        coalesce(period_beg_amount_starter,
            first_value(period_ending_amount_starter) over (partition by gl_partition order by period_last_day rows unbounded preceding)) as period_beg_amount,
        coalesce(period_ending_amount_starter,
            first_value(period_ending_amount_starter) over (partition by gl_partition order by period_last_day rows unbounded preceding)) as period_ending_amount
    from gl_value_partion
)

select 
*
from final