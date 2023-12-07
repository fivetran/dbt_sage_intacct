<p align="center">
    <a alt="License"
        href="https://github.com/fivetran/dbt_sage_intacct/blob/main/LICENSE">
        <img src="https://img.shields.io/badge/License-Apache%202.0-blue.svg" /></a>
    <a alt="dbt-core">
        <img src="https://img.shields.io/badge/dbt_Core™_version->=1.3.0_,<2.0.0-orange.svg" /></a>
    <a alt="Maintained?">
        <img src="https://img.shields.io/badge/Maintained%3F-yes-green.svg" /></a>
    <a alt="PRs">
        <img src="https://img.shields.io/badge/Contributions-welcome-blueviolet" /></a>
</p>

# Sage Intacct Transformation dbt Package ([Docs](https://fivetran.github.io/dbt_sage_intacct/))

# 📣 What does this dbt package do?
- Produces modeled tables that leverage Sage Intacct data from [Fivetran's connector](https://fivetran.com/docs/applications/sage-intacct) in the format described by [this ERD](https://fivetran.com/docs/applications/sage-intacct#schemainformation) and builds off the output of our [Sage Intacct source package](https://github.com/fivetran/dbt_sage_intacct_source).

The main focus of this package is to provide users with insights into their Sage Intacct data that can be used for financial reporting and analysis. This is achieved by the following:
- Creating the general ledger, balance sheet, and profile & loss statement on a month by month grain
- Creating an enhanced AR and AP model 
## Compatibility

> Please be aware that the [dbt_sage_intacct](https://github.com/fivetran/dbt_sage_intacct) and [dbt_sage_intacct_source](https://github.com/fivetran/dbt_sage_intacct_source) packages were developed with single-currency company data. As such, the package models will not reflect accurate totals if your account has multi-currency enabled. If multi-currency functionality is desired, we welcome discussion to support this in a future version. 

The following table provides a detailed list of all models materialized within this package by default. 

| **Model**                | **Description**                                                                                                                                                                                                   |
| ------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------- |
| [sage_intacct__general_ledger](https://github.com/fivetran/dbt_sage_intacct/blob/master/models/sage_intacct__general_ledger.sql) | Table containing all transactions with offsetting debit and credit entries for each account, category, and classification. |
| [sage_intacct__general_ledger_by_period](https://github.com/fivetran/dbt_sage_intacct/blob/master/models/sage_intacct__general_ledger_by_period.sql) | Table containing the beginning balance, ending balance, and net change of the dollar amount for each month and for each account, category, and classification. This table can be used to generate different financial statements for your business based on your customer accounting period. Examples include the balance sheet and income statement models. | 
| [sage_intacct__balance_sheet](https://github.com/fivetran/dbt_sage_intacct/blob/master/models/sage_intacct__balance_sheet.sql)             | Total amounts by period per account, category, and classification for all balance sheet transactions. 
| [sage_intacct__profit_and_loss](https://github.com/fivetran/dbt_sage_intacct/blob/master/models/sage_intacct__profit_and_loss.sql)       | Total amounts by period per account, category, and classification for all profit & loss transactions. 
| [sage_intacct__ap_ar_enhanced](https://github.com/fivetran/dbt_sage_intacct/blob/master/models/sage_intacct__ap_ar_enhanced.sql) | All transactions for each bill or invoice with their associated accounting period and due dates. Includes additional detail regarding the customer, location, department, vendor, and account. Lastly, contains fields like the line number and total number of items in the overall bill or invoice.

# 🎯 How do I use the dbt package?

## Step 1: Prerequisites
To use this dbt package, you must have the following:

- At least one Fivetran Sage Intacct connector syncing data into your destination.
- A **BigQuery**, **Snowflake**, **Redshift**, **PostgreSQL**, or **Databricks** destination.

### Databricks Dispatch Configuration
If you are using a Databricks destination with this package you will need to add the below (or a variation of the below) dispatch configuration within your `dbt_project.yml`. This is required in order for the package to accurately search for macros within the `dbt-labs/spark_utils` then the `dbt-labs/dbt_utils` packages respectively.
```yml
dispatch:
  - macro_namespace: dbt_utils
    search_order: ['spark_utils', 'dbt_utils']
```

## Step 2: Install the package
Include the following sage_intacct package version in your `packages.yml` file:
> TIP: Check [dbt Hub](https://hub.getdbt.com/) for the latest installation instructions or [read the dbt docs](https://docs.getdbt.com/docs/package-management) for more information on installing packages.
```yaml
packages:
  - package: fivetran/sage_intacct
    version: [">=0.3.0", "<0.4.0"] # we recommend using ranges to capture non-breaking changes automatically
```

Do NOT include the `sage_intacct_source` package in this file. The transformation package itself has a dependency on it and will install the source package as well.

## Step 3: Define database and schema variables
By default, this package runs using your destination and the `sage_intacct` schema. If this is not where your Sage Intacct data is (for example, if your Sage Intacct schema is named `sage_intacct_fivetran`), add the following configuration to your root `dbt_project.yml` file:

```yml
vars:
    sage_intacct_database: your_database_name
    sage_intacct_schema: your_schema_name
```

## (Optional) Step 4: Additional configurations

### Passthrough Columns
This package allows users to add additional columns to the `stg_sage_intacct__gl_account` and `stg_sage_intacct__gl_detail` table. 
Columns passed through must be present in the upstream source tables. See below for an example of how the passthrough columns should be configured within your `dbt_project.yml` file.

```yml
# dbt_project.yml

...
vars:
  sage_account_pass_through_columns: ['new_custom_field', 'custom_field_2']
  sage_gl_pass_through_columns: ['custom_field_3', 'custom_field_4']
```
### Custom Account Classification
Accounts roll up into different accounting classes based on their category. The categories are brought in from the `gl_account` table. We created a variable for each accounting class (`Asset`, `Liability`, `Equity`, `Revenue`, `Expense`) that can be modified to include different categories based on your business. You can modify the variables within your root `dbt_project.yml` file. The default values for the respective classes are as follows:

```yml
# dbt_project.yml

...
vars:
    sage_intacct_category_asset: ('Inventory','Fixed Assets','Other Current Assets','Cash and Cash Equivalents','Intercompany Receivable','Accounts Receivable','Deposits and Prepayments','Goodwill','Intangible Assets','Short-Term Investments','Inventory','Accumulated Depreciation','Other Assets','Unrealized Currency Gain/Loss','Patents','Investment in Subsidiary','Escrows and Reserves','Long Term Investments')
    sage_intacct_category_equity: ('Partners Equity','Retained Earnings','Dividend Paid')
    sage_intacct_category_expense: ('Advertising and Promotion Expense','Other Operating Expense','Cost of Sales Revenue', 'Professional Services Expense','Cost of Services Revenue','Payroll Expense','Payroll Taxes','Travel Expense','Cost of Goods Sold','Other Expenses','Compensation Expense','Federal Tax','Depreciation Expense')
    sage_intacct_category_liability: ('Accounts Payable','Other Current Liabilities','Accrued Liabilities','Note Payable - Current','Deferred Taxes Liabilities - Long Term','Note Payable - Long Term','Other Liabilities','Deferred Revenue - Current')
    sage_intacct_category_revenue: ('Revenue','Revenue - Sales','Dividend Income','Revenue - Other','Other Income','Revenue - Services','Revenue - Products')
```
### Disabling and Enabling Models

When setting up your Sage Intacct (Sage) connection in Fivetran, it is possible that not every table this package expects will be synced. This can occur because you either don't use that functionality in Sage or have actively decided to not sync some tables. In order to disable the relevant functionality in the package, you will need to add the relevant variables.

By default, all variables are assumed to be `true`. You only need to add variables for the tables you would like to disable:

```yml
# dbt_project.yml

config-version: 2

vars:
    sage_intacct__using_invoices: false                 # default is true
    sage_intacct__using_bills: false                    # default is true
```
### Changing the Build Schema
By default this package will build the Sage Intacct staging models within a schema titled (<target_schema> + `_stg_sage_intacct`) and the Sage Intacct final models with a schema titled (<target_schema> + `_sage_intacct`) in your target database. If this is not where you would like your modeled Sage Intacct data to be written to, add the following configuration to your `dbt_project.yml` file:

```yml
# dbt_project.yml 

...
models:
  sage_intacct:
    +schema: my_new_schema_name # leave blank for just the target_schema
  sage_intacct_source:
    +schema: my_new_schema_name # leave blank for just the target_schema
```
### Change the source table references
If an individual source table has a different name than the package expects, add the table name as it appears in your destination to the respective variable:

> IMPORTANT: See this project's [`dbt_project.yml`](https://github.com/fivetran/dbt_sage_intacct/blob/main/dbt_project.yml) variable declarations to see the expected names.

```yml
vars:
    sage_intacct_<default_source_table_name>_identifier: your_table_name 
```

## (Optional) Step 5: Orchestrate your models with Fivetran Transformations for dbt Core™  
<details><summary>Expand for more details</summary>

Fivetran offers the ability for you to orchestrate your dbt project through [Fivetran Transformations for dbt Core™](https://fivetran.com/docs/transformations/dbt). Learn how to set up your project for orchestration through Fivetran in our [Transformations for dbt Core setup guides](https://fivetran.com/docs/transformations/dbt#setupguide).

</details>

# 🔍 Does this package have dependencies?
This dbt package is dependent on the following dbt packages. Please be aware that these dependencies are installed by default within this package. For more information on the following packages, refer to the [dbt hub](https://hub.getdbt.com/) site.
> IMPORTANT: If you have any of these dependent packages in your own `packages.yml` file, we highly recommend that you remove them from your root `packages.yml` to avoid package version conflicts.
    
```yml
packages:
    - package: fivetran/sage_intacct_source
      version: [">=0.3.0", "<0.4.0"]

    - package: fivetran/fivetran_utils
      version: [">=0.4.0", "<0.5.0"]

    - package: dbt-labs/dbt_utils
      version: [">=1.0.0", "<2.0.0"]

    - package: dbt-labs/spark_utils
      version: [">=0.3.0", "<0.4.0"]
```
# 🙌 How is this package maintained and can I contribute?
## Package Maintenance
The Fivetran team maintaining this package _only_ maintains the latest version of the package. We highly recommend you stay consistent with the [latest version](https://hub.getdbt.com/fivetran/sage_intacct/latest/) of the package and refer to the [CHANGELOG](https://github.com/fivetran/dbt_sage_intacct/blob/main/CHANGELOG.md) and release notes for more information on changes across versions.

## Contributions
A small team of analytics engineers at Fivetran develops these dbt packages. However, the packages are made better by community contributions! 

We highly encourage and welcome contributions to this package. Check out [this dbt Discourse article](https://discourse.getdbt.com/t/contributing-to-a-dbt-package/657) on the best workflow for contributing to a package!

# 🏪 Are there any resources available?
- If you have questions or want to reach out for help, please refer to the [GitHub Issue](https://github.com/fivetran/dbt_sage_intacct/issues/new/choose) section to find the right avenue of support for you.
- If you would like to provide feedback to the dbt package team at Fivetran or would like to request a new dbt package, fill out our [Feedback Form](https://www.surveymonkey.com/r/DQ7K7WW).
- Have questions or want to just say hi? Book a time during our office hours [on Calendly](https://calendly.com/fivetran-solutions-team/fivetran-solutions-team-office-hours) or email us at solutions@fivetran.com.
