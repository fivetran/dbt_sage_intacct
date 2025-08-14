{% macro get_gl_account_columns() %}

{% set columns = [
    {"name": "_fivetran_deleted", "datatype": "boolean"},
    {"name": "_fivetran_synced", "datatype": dbt.type_timestamp()},
    {"name": "accountno", "datatype": dbt.type_string()},
    {"name": "accounttype", "datatype": dbt.type_string()},
    {"name": "alternativeaccount", "datatype": dbt.type_string()},
    {"name": "category", "datatype": dbt.type_string()},
    {"name": "categorykey", "datatype": dbt.type_int()},
    {"name": "closetoacctkey", "datatype": dbt.type_int()},
    {"name": "closingaccountno", "datatype": dbt.type_int()},
    {"name": "closingaccounttitle", "datatype": dbt.type_string()},
    {"name": "closingtype", "datatype": dbt.type_string()},
    {"name": "createdby", "datatype": dbt.type_int()},
    {"name": "modifiedby", "datatype": dbt.type_int()},
    {"name": "normalbalance", "datatype": dbt.type_string()},
    {"name": "recordno", "datatype": dbt.type_int()},
    {"name": "requireclass", "datatype": "boolean"},
    {"name": "requirecustomer", "datatype": "boolean"},
    {"name": "requiredept", "datatype": "boolean"},
    {"name": "requireemployee", "datatype": "boolean"},
    {"name": "requireitem", "datatype": "boolean"},
    {"name": "requireloc", "datatype": "boolean"},
    {"name": "requireproject", "datatype": "boolean"},
    {"name": "requirevendor", "datatype": "boolean"},
    {"name": "requirewarehouse", "datatype": "boolean"},
    {"name": "status", "datatype": dbt.type_string()},
    {"name": "taxable", "datatype": "boolean"},
    {"name": "title", "datatype": dbt.type_string()},
    {"name": "whencreated", "datatype": dbt.type_timestamp()},
    {"name": "whenmodified", "datatype": dbt.type_timestamp()}
] %}

{{ return(columns) }}

{% endmacro %}
