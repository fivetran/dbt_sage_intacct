[![Apache License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
# Sage Intacct ([docs](https://fivetran.github.io/dbt_sage_intacct/#!/overview)) 

This package models Sage Intacct data from [Fivetran's connector](https://fivetran.com/docs/applications/sage_intacct). It uses data in the format described by [this ERD](https://fivetran.com/docs/applications/sage_intacct-#schemainformation).

The main focus of this package is to enable users to insights into their Sage Intacct data that can be used for financial reporting and analysis. This is achieved by the following:
- Creating the general ledger, balance sheet, and profile & loss statement on a month by month grain
- Creating an enhanced AR and AP model 

## Models
This package contains transformation models, designed to work simultaneously with our [Sage Intacct source package](https://github.com/fivetran/dbt_sage_intacct_source). A dependency on the source package is declared in this package's `packages.yml` file, so it will automatically download when you run `dbt deps`. The primary outputs of this package are described below. Intermediate models are used to create these output models.
| **model**                | **description**                                                                                                                                |
| ------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------- |
| [sage_intacct__general_ledger](https://github.com/fivetran/dbt_sage_intacct/blob/master/models/sage_intacct__general_ledger.sql) | Table containing all transactions with offsetting debit and credit entries for each account, category, and classification. |
| [sage_intacct__general_ledger_by_period](https://github.com/fivetran/dbt_sage_intacct/blob/master/models/sage_intacct__general_ledger_by_period.sql) | Table containing the beginning balance, ending balance, and net change of the dollar amount for each month and for each account, category, and classification. This table can be used to generate different financial statements for your business based on your customer accounting period. Examples include the balance sheet and income statement models. | 
| [sage_intacct__balance_sheet](https://github.com/fivetran/dbt_sage_intacct/blob/master/models/sage_intacct__balance_sheet.sql)             | Total amounts by period per account, category, and classification for all balance sheet transactions. 
| [sage_intacct__profit_and_loss](https://github.com/fivetran/dbt_sage_intacct/blob/master/models/sage_intacct__profit_and_loss.sql)       | Total amounts by period per account, category, and classification for all profit & loss transactions. 
| [sage_intacct__ap_ar_enhanced](https://github.com/fivetran/dbt_sage_intacct/blob/master/models/sage_intacct__ap_ar_enhanced.sql) | All transactions for each bill or invoice with their associated accounting period and due dates. Includes additional detail regarding the customer, location, department, vendor, and account. Lastly, contains fields like the line number and total number of items in the overall bill or invoice.

## Installation Instructions
Check [dbt Hub](https://hub.getdbt.com/) for the latest installation instructions, or [read the dbt docs](https://docs.getdbt.com/docs/package-management) for more information on installing packages.

Include in your `packages.yml`

```yaml
packages:
  - package: fivetran/sage_intacct
    version: [">=0.1.0", "<0.2.0"]
```

## Configuration
By default, this package looks for your Sage Intacct data in the `sage intacct` schema of your [target database](https://docs.getdbt.com/docs/running-a-dbt-project/using-the-command-line-interface/configure-your-profile). 
If this is not where your Sage Intacct data is, add the below configuration to your `dbt_project.yml` file.

```yml
# dbt_project.yml

...
config-version: 2

vars:
    sage_intacct_database: your_database_name
    sage_intacct_schema: your_schema_name
```
### Passthrough Columns
This package allows users to add additional columns to the `stg_sage_intacct__gl_account` table. 
Columns passed through must be present in the upstream source tables. See below for an example of how the passthrough columns should be configured within your `dbt_project.yml` file.

```yml
# dbt_project.yml

...
vars:
  sage_intacct_source:
    sage_account_pass_through_columns: ['new_custom_field', 'custom_field_2']
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


## Contributions
Don't see a model or specific metric you would have liked to be included? Notice any bugs when installing 
and running the package? If so, we highly encourage and welcome contributions to this package! 
Please create issues or open PRs against `main`. Check out [this post](https://discourse.getdbt.com/t/contributing-to-a-dbt-package/657) on the best workflow for contributing to a package.

## Database Support

This package has been tested on Spark, BigQuery, Snowflake, Redshift, and Postgres.

## Resources:
- Provide [feedback](https://www.surveymonkey.com/r/DQ7K7WW) on our existing dbt packages or what you'd like to see next
- Have questions or feedback, or need help? Book a time during our office hours [here](https://calendly.com/fivetran-solutions-team/fivetran-solutions-team-office-hours) or shoot us an email at solutions@fivetran.com.
- Find all of Fivetran's pre-built dbt packages in our [dbt hub](https://hub.getdbt.com/fivetran/)
- Learn how to orchestrate dbt transformations with Fivetran [here](https://fivetran.com/docs/transformations/dbt).
- Learn more about Fivetran overall [in our docs](https://fivetran.com/docs)
- Check out [Fivetran's blog](https://fivetran.com/blog)
- Learn more about dbt [in the dbt docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [chat](http://slack.getdbt.com/) on Slack for live discussions and support
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the dbt blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices