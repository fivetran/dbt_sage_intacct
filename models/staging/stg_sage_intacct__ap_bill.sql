{{ config(enabled=var('sage_intacct__using_bills', True)) }}

with base as (

    select * 
    from {{ ref('stg_sage_intacct__ap_bill_tmp') }}

),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_sage_intacct__ap_bill_tmp')),
                staging_columns=get_ap_bill_columns()
            )
        }}
        
    from base
),

final as (
    
    select 
        cast(recordno as {{ dbt.type_string() }}) as bill_id,
        _fivetran_deleted,
        _fivetran_synced,
        auwhencreated as au_created_at,
        billtopaytocontactname as bill_to_pay_to_contact_name,
        billtopaytokey as bill_to_pay_to_key,
        currency,
        description,
        docnumber as doc_number,
        due_in_days as due_in_days,
        recordid as record_id,
        recordtype as record_type,
        shiptoreturntocontactname as ship_to_return_to_contact_name,
        shiptoreturntokey as ship_to_return_to_key,
        state,
        totaldue as total_due,
        totalentered as total_entered,
        totalpaid as total_paid,
        vendorid as vendor_id,
        vendorname as vendor_name,
        whencreated as created_at,
        whendue as due_at,
        whenmodified as modified_at,
        whenpaid as paid_at,
        whenposted as posted_at

    from fields
)

select * from final
where not coalesce(_fivetran_deleted, false)
