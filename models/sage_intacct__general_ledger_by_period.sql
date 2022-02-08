with general_ledger_balances as (
    select *
    from {{ref('int_sage_intacct__general_ledger_balances')}}
),

retained_earnings as (
    select *
    from {{ref('int_sage_intacct__retained_earnings')}}
),

final as (
    select *
    from general_ledger_balances

    union all 

    select *
    from retained_earnings
)

select *
from final