
{{ config(
    tags="fivetran_validations",
    enabled=var('fivetran_validation_tests_enabled', false)
) }}

-- These validations are assuming the variables `sage_intacct__using_bills` and `sage_intacct__using_invoices` are set to `true`.

with ap_source as (
    select
        bill_id,
        count(*) as bill_row_count
    from {{ ref('stg_sage_intacct__ap_bill_item') }}
    group by 1
),

ar_source as (
    select
        invoice_id,
        count(*) as invoice_row_count
    from {{ ref('stg_sage_intacct__ar_invoice_item') }}
    group by 1
),

ap_ar_enhanced as (
    select
        document_id,
        document_type,
        count(*) as end_model_row_count
    from {{ ref('sage_intacct__ap_ar_enhanced') }}
    group by 1, 2
),

match_check as (
    select 
        ap_ar_enhanced.document_id,
        ap_ar_enhanced.document_type,
        ap_ar_enhanced.end_model_row_count,
        case when ap_ar_enhanced.document_type = 'invoice' then ar_source.invoice_row_count else ap_source.bill_row_count end as source_row_count
    from ap_ar_enhanced
    full outer join ap_source
        on ap_ar_enhanced.document_id = ap_source.bill_id
    full outer join ar_source
        on ap_ar_enhanced.document_id = ar_source.invoice_id
)

select *
from match_check
where end_model_row_count != source_row_count
{{ "and document_id not in " ~ var('fivetran_integrity_ap_ar_enhanced_exclusion_documents',[]) ~ "" if var('fivetran_integrity_ap_ar_enhanced_exclusion_documents',[]) }}