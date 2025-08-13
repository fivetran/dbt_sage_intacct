
with base as (

    select * 
    from {{ ref('stg_sage_intacct__gl_batch_tmp') }}
),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_sage_intacct__gl_batch_tmp')),
                staging_columns=get_gl_batch_columns()
            )
        }}
    from base
),

final as (
    
    select 
        _fivetran_deleted as is_batch_deleted,
        _fivetran_synced,
        baselocation as base_location,
        baselocation_no as base_location_no,
        batch_date,
        batch_title,
        batchno as batch_no,
        createdby as created_by,
        journal,
        megaentityid as mega_entity_id,
        megaentitykey as mega_entity_key,
        megaentityname as mega_entity_name,
        modified,
        modifiedby as modified_by,
        modifiedbyid as modified_by_id,
        module,
        prbatchkey as pr_batch_key,
        recordno as record_no,
        referenceno as reference_no,
        reversed,
        reversedfrom as reversed_from,
        reversedkey as reversed_key,
        state,
        taximplications as tax_implications,
        templatekey as template_key,
        userinfo_loginid as user_info_login_id,
        userkey as user_key,
        whencreated as when_created,
        whenmodified as when_modified
    from fields
)

select *
from final
