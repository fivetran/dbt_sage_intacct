
{{ config(
    tags="fivetran_validations",
    enabled=var('fivetran_validation_tests_enabled', false)
) }}

with prod as (
    select
        document_id,
        count(*) as row_count,
        sum(cast(amount as {{ dbt.type_numeric() }})) as initial_amount,
        sum(cast(total_paid as {{ dbt.type_numeric() }})) as total_amount_paid,
        sum(cast(total_due as {{ dbt.type_numeric() }})) as total_amount_due
    from {{ target.schema }}_sage_intacct_prod.sage_intacct__ap_ar_enhanced
    group by 1
),

dev as (
    select
        document_id,
        count(*) as row_count,
        sum(cast(amount as {{ dbt.type_numeric() }})) as initial_amount,
        sum(cast(total_paid as {{ dbt.type_numeric() }})) as total_amount_paid,
        sum(cast(total_due as {{ dbt.type_numeric() }})) as total_amount_due
    from {{ target.schema }}_sage_intacct_dev.sage_intacct__ap_ar_enhanced
    group by 1
),

final as (
    select 
        prod.document_id,
        prod.row_count as prod_row_count,
        dev.row_count as dev_row_count,
        round(prod.initial_amount, 2) as prod_initial_amount,
        round(dev.initial_amount, 2) as dev_initial_amount,
        round(prod.total_amount_paid, 2) as prod_total_amount_paid,
        round(dev.total_amount_paid, 2) as dev_total_amount_paid,
        round(prod.total_amount_due, 2) as prod_total_amount_due,
        round(dev.total_amount_due, 2) as dev_total_amount_due
    from prod
    full outer join dev 
        on dev.document_id = prod.document_id
)

select *
from final
where (prod_row_count != dev_row_count 
        or prod_initial_amount != dev_initial_amount 
        or prod_total_amount_paid != dev_total_amount_paid 
        or prod_total_amount_due != dev_total_amount_due
    )
    {{ "and document_id not in " ~ var('fivetran_consistency_ap_ar_enhanced_exclusion_documents',[]) ~ "" if var('fivetran_consistency_ap_ar_enhanced_exclusion_documents',[]) }}