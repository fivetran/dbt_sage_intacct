{% macro get_gl_batch_columns() %}

{% set columns = [
    {"name": "_fivetran_deleted", "datatype": "boolean"},
    {"name": "_fivetran_synced", "datatype": dbt.type_timestamp()},
    {"name": "baselocation", "datatype": dbt.type_int()},
    {"name": "baselocation_no", "datatype": dbt.type_int()},
    {"name": "batch_date", "datatype": "date"},
    {"name": "batch_title", "datatype": dbt.type_string()},
    {"name": "batchno", "datatype": dbt.type_int()},
    {"name": "createdby", "datatype": dbt.type_int()},
    {"name": "journal", "datatype": dbt.type_string()},
    {"name": "megaentityid", "datatype": dbt.type_int()},
    {"name": "megaentitykey", "datatype": dbt.type_int()},
    {"name": "megaentityname", "datatype": dbt.type_string()},
    {"name": "modified", "datatype": dbt.type_timestamp()},
    {"name": "modifiedby", "datatype": dbt.type_int()},
    {"name": "modifiedbyid", "datatype": dbt.type_string()},
    {"name": "module", "datatype": dbt.type_string()},
    {"name": "prbatchkey", "datatype": dbt.type_int()},
    {"name": "recordno", "datatype": dbt.type_string()},
    {"name": "referenceno", "datatype": dbt.type_string()},
    {"name": "reversed", "datatype": "date"},
    {"name": "reversedfrom", "datatype": "date"},
    {"name": "reversedkey", "datatype": dbt.type_int()},
    {"name": "state", "datatype": dbt.type_string()},
    {"name": "taximplications", "datatype": dbt.type_string()},
    {"name": "templatekey", "datatype": dbt.type_int()},
    {"name": "userinfo_loginid", "datatype": dbt.type_string()},
    {"name": "userkey", "datatype": dbt.type_int()},
    {"name": "whencreated", "datatype": dbt.type_timestamp()},
    {"name": "whenmodified", "datatype": dbt.type_timestamp()}
] %}

{{ return(columns) }}

{% endmacro %}
