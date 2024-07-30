{{ config(
    tags="fivetran_validations",
    enabled=var('fivetran_validation_tests_enabled', false)
) }}

-- this test is to make sure there is no fanout between the spine and the general_ledger_by_period

with spine as (
    select count(*) as spine_count
    from {{ target.schema }}_sage_intacct_dev.int_sage_intacct__general_ledger_date_spine
),

general_ledger_by_period as (
    select count(*) as glp_count
    from {{ target.schema }}_sage_intacct_dev.sage_intacct__general_ledger_by_period
)

-- test will return values and fail if the row counts don't match
select *
from spine
join general_ledger_by_period
    on spine.spine_count != general_ledger_by_period.glp_count