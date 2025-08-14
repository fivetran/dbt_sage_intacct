{% macro get_ap_bill_columns() %}

{% set columns = [
    {"name": "_fivetran_deleted", "datatype": "boolean"},
    {"name": "_fivetran_synced", "datatype": dbt.type_timestamp()},
    {"name": "auwhencreated", "datatype": dbt.type_timestamp()},
    {"name": "basecurr", "datatype": dbt.type_string()},
    {"name": "billtopaytocontactname", "datatype": dbt.type_string()},
    {"name": "billtopaytokey", "datatype": dbt.type_int()},
    {"name": "currency", "datatype": dbt.type_string()},
    {"name": "description", "datatype": dbt.type_string()},
    {"name": "docnumber", "datatype": dbt.type_string()},
    {"name": "due_in_days", "datatype": dbt.type_int()},
    {"name": "recordid", "datatype": dbt.type_string()},
    {"name": "recordno", "datatype": dbt.type_string()},
    {"name": "recordtype", "datatype": dbt.type_string()},
    {"name": "shiptoreturntocontactname", "datatype": dbt.type_string()},
    {"name": "shiptoreturntokey", "datatype": dbt.type_int()},
    {"name": "state", "datatype": dbt.type_string()},
    {"name": "totaldue", "datatype": dbt.type_float()},
    {"name": "totalentered", "datatype": dbt.type_float()},
    {"name": "totalpaid", "datatype": dbt.type_float()},
    {"name": "vendorid", "datatype": dbt.type_string()},
    {"name": "vendorname", "datatype": dbt.type_string()},
    {"name": "whencreated", "datatype": "date"},
    {"name": "whendue", "datatype": "date"},
    {"name": "whenmodified", "datatype": dbt.type_timestamp()},
    {"name": "whenpaid", "datatype": "date"},
    {"name": "whenposted", "datatype": "date"}
] %}

{{ return(columns) }}

{% endmacro %}
