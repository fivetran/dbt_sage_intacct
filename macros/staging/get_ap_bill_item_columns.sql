{% macro get_ap_bill_item_columns() %}

{% set columns = [
    {"name": "_fivetran_synced", "datatype": dbt.type_timestamp()},
    {"name": "accountkey", "datatype": dbt.type_int()},
    {"name": "accountno", "datatype": dbt.type_float()},
    {"name": "accounttitle", "datatype": dbt.type_string()},
    {"name": "amount", "datatype": dbt.type_float()},
    {"name": "basecurr", "datatype": dbt.type_string()},
    {"name": "baselocation", "datatype": dbt.type_int()},
    {"name": "billable", "datatype": "boolean"},
    {"name": "billed", "datatype": "boolean"},
    {"name": "classid", "datatype": dbt.type_string()},
    {"name": "classname", "datatype": dbt.type_string()},
    {"name": "createdby", "datatype": dbt.type_int()},
    {"name": "currency", "datatype": dbt.type_string()},
    {"name": "customerid", "datatype": dbt.type_string()},
    {"name": "customername", "datatype": dbt.type_string()},
    {"name": "departmentid", "datatype": dbt.type_string()},
    {"name": "departmentname", "datatype": dbt.type_string()},
    {"name": "entry_date", "datatype": "date"},
    {"name": "entrydescription", "datatype": dbt.type_string()},
    {"name": "exchange_rate", "datatype": dbt.type_int()},
    {"name": "itemid", "datatype": dbt.type_string()},
    {"name": "itemname", "datatype": dbt.type_string()},
    {"name": "line_no", "datatype": dbt.type_int()},
    {"name": "lineitem", "datatype": "boolean"},
    {"name": "locationid", "datatype": dbt.type_string()},
    {"name": "locationname", "datatype": dbt.type_string()},
    {"name": "offsetglaccountno", "datatype": dbt.type_int()},
    {"name": "offsetglaccounttitle", "datatype": dbt.type_string()},
    {"name": "projectid", "datatype": dbt.type_string()},
    {"name": "projectname", "datatype": dbt.type_string()},
    {"name": "recordkey", "datatype": dbt.type_string()},
    {"name": "recordno", "datatype": dbt.type_string()},
    {"name": "recordtype", "datatype": dbt.type_string()},
    {"name": "state", "datatype": dbt.type_string()},
    {"name": "totalpaid", "datatype": dbt.type_float()},
    {"name": "totalselected", "datatype": dbt.type_float()},
    {"name": "vendorid", "datatype": dbt.type_string()},
    {"name": "vendorname", "datatype": dbt.type_string()},
    {"name": "whencreated", "datatype": dbt.type_timestamp()},
    {"name": "whenmodified", "datatype": dbt.type_timestamp()}
] %}

{{ return(columns) }}

{% endmacro %}
