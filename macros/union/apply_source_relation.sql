{% macro apply_source_relation() -%}

{{ adapter.dispatch('apply_source_relation', 'sage_intacct') () }}

{%- endmacro %}

{% macro default__apply_source_relation() -%}

{% if var('sage_intacct_sources', []) != [] %}
, _dbt_source_relation as source_relation
{% else %}
, '{{ var("sage_intacct_database", target.database) }}' || '.'|| '{{ var("sage_intacct_schema", "sage_intacct") }}' as source_relation
{% endif %}

{%- endmacro %}