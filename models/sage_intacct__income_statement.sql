with general_ledger_by_period as (
    select *
    from {{ref('sage_intacct__general_ledger_by_period')}}
    where account_type = 'incomestatement'

), 

final as (
    select
        period_first_day as date,
        account_no,
        account_title,
        category,
        classification,
        period_net_amount as amount
    from general_ledger_by_period
)

select *
from final