<!--section="sage-intacct_transformation_model"-->
# Sage Intacct dbt Package

This dbt package transforms data from Fivetran's Sage Intacct connector into analytics-ready tables.

## Resources

- Number of materialized models¹: 23
- Connector documentation
  - [Sage Intacct connector documentation](https://fivetran.com/docs/connectors/applications/sage-intacct)
  - [Sage Intacct ERD](https://fivetran.com/docs/connectors/applications/sage-intacct#schemainformation)
- dbt package documentation
  - [GitHub repository](https://github.com/fivetran/dbt_sage_intacct)
  - [dbt Docs](https://fivetran.github.io/dbt_sage_intacct/#!/overview)
  - [DAG](https://fivetran.github.io/dbt_sage_intacct/#!/overview?g_v=1)
  - [Changelog](https://github.com/fivetran/dbt_sage_intacct/blob/main/CHANGELOG.md)
- dbt Core™ supported versions
  - `>=1.3.0, <3.0.0`

## What does this dbt package do?
This package enables you to create general ledger, balance sheet, and profit & loss statements by period and enhance AR and AP models. It creates enriched models with metrics focused on financial reporting and analysis.

> Please be aware that the [dbt_sage_intacct](https://github.com/fivetran/dbt_sage_intacct) package was developed with single-currency company data. As such, the package models will not reflect accurate totals if your account has multi-currency enabled. If multi-currency functionality is desired, we welcome discussion to support this in a future version.

### Output schema
Final output tables are generated in the following target schema:

```
<your_database>.<connector/schema_name>_sage_intacct
```

### Final output tables

By default, this package materializes the following final tables:

| Table | Description |
| :---- | :---- |
| [sage_intacct__general_ledger](https://github.com/fivetran/dbt_sage_intacct/blob/master/models/sage_intacct__general_ledger.sql) | Tracks all financial transactions with offsetting debit and credit entries by account, category, and classification to provide a complete audit trail and transaction history. <br></br>**Example Analytics Questions:**<ul><li>What is the total debit and credit activity by account and classification?</li><li>Which accounts have the highest transaction volumes or largest balance changes?</li><li>How do debits and credits balance across different categories and time periods?</li></ul>|
| [sage_intacct__general_ledger_by_period](https://github.com/fivetran/dbt_sage_intacct/blob/master/models/sage_intacct__general_ledger_by_period.sql) | Summarizes account activity by period with beginning balances, ending balances, and net changes to track financial position over time and support financial statement preparation. <br></br>**Example Analytics Questions:**<ul><li>What are the beginning and ending balances for each account by period?</li><li>Which accounts show the largest net changes period-over-period?</li><li>How do period-over-period balances trend by account category and classification?</li></ul>|
| [sage_intacct__balance_sheet](https://github.com/fivetran/dbt_sage_intacct/blob/master/models/sage_intacct__balance_sheet.sql) | Aggregates balance sheet transactions by period, account, category, and classification to track assets, liabilities, and equity over time. <br></br>**Example Analytics Questions:**<ul><li>What is the total asset value versus total liability value for each reporting period?</li><li>How have account balances changed across different balance sheet categories?</li><li>What is the equity position by classification and time period?</li></ul>|
| [sage_intacct__profit_and_loss](https://github.com/fivetran/dbt_sage_intacct/blob/master/models/sage_intacct__profit_and_loss.sql) | Summarizes revenue and expense transactions by period, account, category, and classification to analyze profitability and income statement performance. <br></br>**Example Analytics Questions:**<ul><li>What are total revenues versus total expenses for each accounting period?</li><li>Which expense accounts or categories are growing fastest?</li><li>What is the net profit or loss by classification and time period?</li></ul>|
| [sage_intacct__ap_ar_enhanced](https://github.com/fivetran/dbt_sage_intacct/blob/master/models/sage_intacct__ap_ar_enhanced.sql) | Provides detailed accounts payable and receivable transaction data with bill/invoice information, due dates, customer and vendor details, and line item breakdowns. <br></br>**Example Analytics Questions:**<ul><li>Which customers or vendors have the highest outstanding balances?</li><li>Which bills and invoices are approaching their due dates?</li><li>How do transaction volumes vary by department, location, or account?</li></ul>|

¹ Each Quickstart transformation job run materializes these models if all components of this data model are enabled. This count includes all staging, intermediate, and final models materialized as `view`, `table`, or `incremental`.

---

## Prerequisites
To use this dbt package, you must have the following:

- At least one Fivetran Sage Intacct connection syncing data into your destination.
- A **BigQuery**, **Snowflake**, **Redshift**, **PostgreSQL**, **Databricks**, or **DuckDB** destination.

## How do I use the dbt package?
You can either add this dbt package in the Fivetran dashboard or import it into your dbt project:

- To add the package in the Fivetran dashboard, follow our [Quickstart guide](https://fivetran.com/docs/transformations/data-models/quickstart-management).
- To add the package to your dbt project, follow the setup instructions in the dbt package's [README file](https://github.com/fivetran/dbt_sage_intacct/blob/main/README.md#how-do-i-use-the-dbt-package) to use this package.

<!--section-end-->

### Install the package
Include the following sage_intacct package version in your `packages.yml` file:
> TIP: Check [dbt Hub](https://hub.getdbt.com/) for the latest installation instructions or [read the dbt docs](https://docs.getdbt.com/docs/package-management) for more information on installing packages.
```yml
packages:
  - package: fivetran/sage_intacct
    version: [">=1.4.0", "<1.5.0"] # we recommend using ranges to capture non-breaking changes automatically
```

> All required sources and staging models are now bundled into this transformation package. Do not include `fivetran/sage_intacct_source` in your `packages.yml` since this package has been deprecated.

#### Databricks Dispatch Configuration
If you are using a Databricks destination with this package you will need to add the below (or a variation of the below) dispatch configuration within your `dbt_project.yml`. This is required in order for the package to accurately search for macros within the `dbt-labs/spark_utils` then the `dbt-labs/dbt_utils` packages respectively.
```yml
dispatch:
  - macro_namespace: dbt_utils
    search_order: ['spark_utils', 'dbt_utils']
```

### Define database and schema variables
#### Option A: Single connection
By default, this package runs using your destination and the `sage_intacct` schema. If this is not where your Sage Intacct data is (for example, if your Sage Intacct schema is named `sage_intacct_fivetran`), add the following configuration to your root `dbt_project.yml` file:

```yml
vars:
    sage_intacct_database: your_destination_name
    sage_intacct_schema: your_schema_name
```

#### Option B: Union multiple connections
If you have multiple Sage Intacct connections in Fivetran and would like to use this package on all of them simultaneously, we have provided functionality to do so. For each source table, the package will union all of the data together and pass the unioned table into the transformations. The `source_relation` column in each model indicates the origin of each record.

To use this functionality, you will need to set the `sage_intacct_sources` variable in your root `dbt_project.yml` file:

```yml
# dbt_project.yml

vars:
  sage_intacct:
    sage_intacct_sources:
      - database: connection_1_destination_name # Required
        schema: connection_1_schema_name # Required
        name: connection_1_source_name # Required only if following the step in the following subsection

      - database: connection_2_destination_name
        schema: connection_2_schema_name
        name: connection_2_source_name
```

#### Optional: Incorporate unioned sources into DAG

If you use [Fivetran Transformations for dbt Core™](https://fivetran.com/docs/transformations/dbt#transformationsfordbtcore) and are unioning multiple Sage Intacct connections, you can define your sources in a property `.yml` file, [using this as a template](https://github.com/fivetran/dbt_sage_intacct/blob/main/models/staging/src_sage_intacct.yml). Set the variable `has_defined_sources: true` under the Sage Intacct namespace in your `dbt_project.yml`. Otherwise, your Sage Intacct connections won't appear in your DAG. See the `union_connections` macro [documentation](https://github.com/fivetran/dbt_fivetran_utils/tree/releases/v0.4.latest#optional-union-connections-defined-sources-configuration) for full configuration details.

### (Optional) Additional configurations

<details open><summary>Expand/Collapse configurations</summary>

#### Passthrough Columns
This package allows users to add additional columns to the `stg_sage_intacct__gl_account` and `stg_sage_intacct__gl_detail` table.
Columns passed through must be present in the upstream source tables. See below for an example of how the passthrough columns should be configured within your `dbt_project.yml` file.

```yml
# dbt_project.yml

vars:
  sage_account_pass_through_columns: ['new_custom_field', 'custom_field_2']
  sage_gl_pass_through_columns: ['custom_field_3', 'custom_field_4']
```
#### Custom Account Classification
Accounts roll up into different accounting classes based on their category. The categories are brought in from the `gl_account` table. We created a variable for each accounting class (`Asset`, `Liability`, `Equity`, `Revenue`, `Expense`) that can be modified to include different categories based on your business. You can modify the variables within your root `dbt_project.yml` file. The default values for the respective classes are as follows:

```yml
# dbt_project.yml

vars:
    sage_intacct_category_asset: ('Inventory','Fixed Assets','Other Current Assets','Cash and Cash Equivalents','Intercompany Receivable','Accounts Receivable','Deposits and Prepayments','Goodwill','Intangible Assets','Short-Term Investments','Inventory','Accumulated Depreciation','Other Assets','Unrealized Currency Gain/Loss','Patents','Investment in Subsidiary','Escrows and Reserves','Long Term Investments')
    sage_intacct_category_equity: ('Partners Equity','Retained Earnings','Dividend Paid')
    sage_intacct_category_expense: ('Advertising and Promotion Expense','Other Operating Expense','Cost of Sales Revenue', 'Professional Services Expense','Cost of Services Revenue','Payroll Expense','Payroll Taxes','Travel Expense','Cost of Goods Sold','Other Expenses','Compensation Expense','Federal Tax','Depreciation Expense')
    sage_intacct_category_liability: ('Accounts Payable','Other Current Liabilities','Accrued Liabilities','Note Payable - Current','Deferred Taxes Liabilities - Long Term','Note Payable - Long Term','Other Liabilities','Deferred Revenue - Current')
    sage_intacct_category_revenue: ('Revenue','Revenue - Sales','Dividend Income','Revenue - Other','Other Income','Revenue - Services','Revenue - Products')
```
#### Disabling and Enabling Models

When setting up your Sage Intacct (Sage) connection in Fivetran, it is possible that not every table this package expects will be synced. This can occur because you either don't use that functionality in Sage or have actively decided to not sync some tables. In order to disable the relevant functionality in the package, you will need to add the relevant variables.

By default, all variables are assumed to be `true`. You only need to add variables for the tables you would like to disable:

```yml
# dbt_project.yml

config-version: 2

vars:
    sage_intacct__using_invoices: false                 # default is true
    sage_intacct__using_bills: false                    # default is true
```
#### Changing the Build Schema
By default this package will build the Sage Intacct staging models within a schema titled (<target_schema> + `_sage_intacct_staging`) and the Sage Intacct final models with a schema titled (<target_schema> + `_sage_intacct`) in your target database. If this is not where you would like your modeled Sage Intacct data to be written to, add the following configuration to your `dbt_project.yml` file:

```yml
# dbt_project.yml 

models:
    sage_intacct:
      +schema: my_new_schema_name # Leave +schema: blank to use the default target_schema.
      staging:
        +schema: my_new_schema_name # Leave +schema: blank to use the default target_schema.
```
#### Change the source table references
If an individual source table has a different name than the package expects, add the table name as it appears in your destination to the respective variable:

> IMPORTANT: See this project's [`dbt_project.yml`](https://github.com/fivetran/dbt_sage_intacct/blob/main/dbt_project.yml) variable declarations to see the expected names.

```yml
vars:
    sage_intacct_<default_source_table_name>_identifier: your_table_name 
```

#### Source casing for case-sensitive destinations
By default, the package applies case-insensitive comparisons when resolving `source_relation` values. If your destination is case-sensitive and you want downstream transformations to respect the exact casing of your source database and schema names, set the following variable:

```yml
vars:
    fivetran_using_source_casing: true
```

</details>

### (Optional) Orchestrate your models with Fivetran Transformations for dbt Core™
<details><summary>Expand for more details</summary>

Fivetran offers the ability for you to orchestrate your dbt project through [Fivetran Transformations for dbt Core™](https://fivetran.com/docs/transformations/dbt#transformationsfordbtcore). Learn how to set up your project for orchestration through Fivetran in our [Transformations for dbt Core setup guides](https://fivetran.com/docs/transformations/dbt/setup-guide#transformationsfordbtcoresetupguide).

</details>

## Does this package have dependencies?
This dbt package is dependent on the following dbt packages. These dependencies are installed by default within this package. For more information on the following packages, refer to the [dbt hub](https://hub.getdbt.com/) site.
> IMPORTANT: If you have any of these dependent packages in your own `packages.yml` file, we highly recommend that you remove them from your root `packages.yml` to avoid package version conflicts.

```yml
packages:
    - package: fivetran/fivetran_utils
      version: [">=0.4.0", "<0.5.0"]

    - package: dbt-labs/dbt_utils
      version: [">=1.0.0", "<2.0.0"]

    - package: dbt-labs/spark_utils
      version: [">=0.3.0", "<0.4.0"]
```

<!--section="sage-intacct_maintenance"-->
## How is this package maintained and can I contribute?

### Package Maintenance
The Fivetran team maintaining this package only maintains the [latest version](https://hub.getdbt.com/fivetran/sage_intacct/latest/) of the package. We highly recommend you stay consistent with the latest version of the package and refer to the [CHANGELOG](https://github.com/fivetran/dbt_sage_intacct/blob/main/CHANGELOG.md) and release notes for more information on changes across versions.

### Contributions
A small team of analytics engineers at Fivetran develops these dbt packages. However, the packages are made better by community contributions.

We highly encourage and welcome contributions to this package. Learn how to contribute to a package in dbt's [Contributing to an external dbt package article](https://discourse.getdbt.com/t/contributing-to-a-dbt-package/657).

<!--section-end-->

## Are there any resources available?
- If you have questions or want to reach out for help, see the [GitHub Issue](https://github.com/fivetran/dbt_sage_intacct/issues/new/choose) section to find the right avenue of support for you.
- If you would like to provide feedback to the dbt package team at Fivetran or would like to request a new dbt package, fill out our [Feedback Form](https://www.surveymonkey.com/r/DQ7K7WW).