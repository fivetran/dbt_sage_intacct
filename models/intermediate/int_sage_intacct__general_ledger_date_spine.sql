with spine as (

    {% if execute and flags.WHICH in ('run', 'build') %}

    {% set first_date_query %}
        select 
            coalesce(
                min(cast(entry_date_at as date)), 
                cast({{ dbt.dateadd("month", -1, "current_date") }} as date)
                ) as min_date 
        from {{ ref('sage_intacct__general_ledger') }}
    {% endset %}

    {% set last_date_query %}
        select 
            coalesce(
                max(cast(entry_date_at as date)), 
                cast(current_date as date)
                ) as max_date 
        from {{ ref('sage_intacct__general_ledger') }}
    {% endset %}
    
    {% else %}

    {%- set first_date_query%}
        select cast({{ dbt.dateadd("month", -1, "current_date") }} as date)
    {% endset -%}

    {% set last_date_query %}
        select cast({{ dbt.current_timestamp() }} as date)
    {% endset -%}

    {% endif %}

    {%- set first_date = dbt_utils.get_single_value(first_date_query) %}
    {%- set last_date = dbt_utils.get_single_value(last_date_query) %}

    {{ dbt_utils.date_spine(
        datepart="month",
        start_date="cast('" ~ first_date ~ "' as date)",
        end_date=dbt.dateadd("month", 1, "cast('" ~ last_date  ~ "' as date)")
        )
    }}
),

general_ledger as (
    select *
    from {{ ref('sage_intacct__general_ledger') }}
),

date_spine as (
    select
        cast({{ dbt.date_trunc("year", "date_month") }} as date) as date_year,
        cast({{ dbt.date_trunc("month", "date_month") }} as date) as period_first_day,
        {{ dbt.last_day("date_month", "month") }} as period_last_day,
        row_number() over (order by cast({{ dbt.date_trunc("month", "date_month") }} as date)) as period_index
    from spine
),

final as (
    select distinct
        general_ledger.account_no,
        general_ledger.account_title,
        general_ledger.account_type,
        general_ledger.book_id,
        general_ledger.category,
        general_ledger.classification,
        general_ledger.currency,
        general_ledger.entry_state,
        date_spine.date_year,
        date_spine.period_first_day,
        date_spine.period_last_day,
        date_spine.period_index
    from general_ledger

    cross join date_spine
)

select *
from final
