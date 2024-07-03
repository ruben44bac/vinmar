defmodule Vinmar.Repo.Migrations.InitTables do
  use Ecto.Migration

  def change do
    create table(:countries, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false, default: fragment("gen_random_uuid()")
      add :name, :string
      add :rating, :string

      timestamps(type: :utc_datetime)
    end

    create table(:customer_types, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false, default: fragment("gen_random_uuid()")
      add :name, :string

      timestamps(type: :utc_datetime)
    end

    create table(:customers, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false, default: fragment("gen_random_uuid()")
      add :sap_id, :string
      add :name, :string
      add :created_at, :utc_datetime
      add :inception_at, :utc_datetime

      add(:customer_type_id, references(:customer_types, on_delete: :nothing, type: :uuid))

      add(:country_id, references(:countries, on_delete: :nothing, type: :uuid))

      timestamps(type: :utc_datetime)
    end

    create table(:reviewed_periods, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false, default: fragment("gen_random_uuid()")
      add :name, :string
      add :days, :integer

      timestamps(type: :utc_datetime)
    end

    create table(:financial_statement_sources, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false, default: fragment("gen_random_uuid()")
      add :name, :string

      timestamps(type: :utc_datetime)
    end

    create table(:insurance_companies, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false, default: fragment("gen_random_uuid()")
      add :name, :string

      timestamps(type: :utc_datetime)
    end

    create table(:collateral_types, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false, default: fragment("gen_random_uuid()")
      add :name, :string

      timestamps(type: :utc_datetime)
    end

    execute(
      "CREATE TYPE coverage_type AS ENUM ('named', 'dcl', 'uninsured')",
      "DROP TYPE coverage_type"
    )

    execute(
      "CREATE TYPE outlook_type AS ENUM ('positive', 'stable', 'negative')",
      "DROP TYPE outlook_type"
    )

    create table(:executive_summaries, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false, default: fragment("gen_random_uuid()")
      add :version, :decimal
      add :version_date, :date
      add :reviewed_at, :utc_datetime
      add :next_reviewed_at, :utc_datetime
      add :current_credit_limit, :money_with_currency
      add :current_insurance_coverage, :money_with_currency
      add :request_credit_limit, :money_with_currency
      add :request_insurance_coverage, :money_with_currency
      add :amount, :money_with_currency
      add :last_expirated_at, :utc_datetime
      add :dra, :integer
      add :recommended_limit, :money_with_currency
      add :credit_agency_rating, :string
      add :summary, :string
      add :recommended_credit_limit, :money_with_currency
      add :payment_term, :decimal
      add :credit_facilities, :money_with_currency
      add :availability_headroom, :money_with_currency
      add :expirated_at, :utc_datetime
      add :current_coverage_type, :coverage_type
      add :request_coverage_type, :coverage_type
      add :outlook, :outlook_type

      add(
        :financial_statement_source_id,
        references(:financial_statement_sources, on_delete: :nothing, type: :uuid)
      )

      add(
        :current_insurance_company_id,
        references(:insurance_companies, on_delete: :nothing, type: :uuid)
      )

      add(
        :request_insurance_company_id,
        references(:insurance_companies, on_delete: :nothing, type: :uuid)
      )

      add(:collateral_type_id, references(:collateral_types, on_delete: :nothing, type: :uuid))
      add(:reviewed_period_id, references(:reviewed_periods, on_delete: :nothing, type: :uuid))
      add(:user_id, references(:users, on_delete: :nothing, type: :uuid))
      add(:customer_id, references(:customers, on_delete: :nothing, type: :uuid))

      timestamps(type: :utc_datetime)
    end

    execute(
      "CREATE TYPE executive_summary_consideration_type AS ENUM ('positive', 'negative')",
      "DROP TYPE executive_summary_consideration_type"
    )

    create table(:executive_summary_considerations, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false, default: fragment("gen_random_uuid()")
      add :type, :executive_summary_consideration_type

      add(
        :executive_summary_id,
        references(:executive_summaries, on_delete: :nothing, type: :uuid)
      )

      timestamps(type: :utc_datetime)
    end

    create table(:executive_summary_review, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false, default: fragment("gen_random_uuid()")
      add :account_application, :boolean, default: false
      add :credit_references, :boolean, default: false
      add :credit_request_form, :boolean, default: false
      add :visual_compliance, :boolean, default: false
      add :financial_statements, :boolean, default: false
      add :credit_reports, :boolean, default: false
      add :insurance, :boolean, default: false
      add :explanation, :string

      add(
        :executive_summary_id,
        references(:executive_summaries, on_delete: :nothing, type: :uuid)
      )

      timestamps(type: :utc_datetime)
    end

    create table(:financial_statement_formats, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false, default: fragment("gen_random_uuid()")
      add :name, :string

      timestamps(type: :utc_datetime)
    end

    create table(:currency_types, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false, default: fragment("gen_random_uuid()")
      add :country, :string, size: 100
      add :country_key, :string, size: 7
      add :money_name, :string, size: 100
      add :money_key, :string, size: 5

      timestamps(type: :utc_datetime)
    end

    create table(:exchange_rates, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false, default: fragment("gen_random_uuid()")
      add :dollar_amount, :money_with_currency
      add :day, :date

      add(:currency_type_id, references(:currency_types, on_delete: :nothing, type: :uuid))
      timestamps(type: :utc_datetime)
    end

    create table(:local_currencies, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false, default: fragment("gen_random_uuid()")

      add(
        :financial_statement_format_id,
        references(:financial_statement_formats, on_delete: :nothing, type: :uuid)
      )

      add(:currency_type_id, references(:currency_types, on_delete: :nothing, type: :uuid))

      add(:customer_id, references(:customers, on_delete: :nothing, type: :uuid))

      add(:user_id, references(:users, on_delete: :nothing, type: :uuid))

      timestamps(type: :utc_datetime)
    end

    create table(:local_currency_periods, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false, default: fragment("gen_random_uuid()")
      add :balance_f_x, :money_with_currency
      add :pl_f_x, :decimal
      add :period, :string
      add :statetment_a, :utc_datetime
      add :statetment_as_to, :utc_datetime
      add :no_months, :integer
      add :units, :decimal
      add :cash, :money_with_currency
      add :accounts_receivable_net, :money_with_currency
      add :inventory, :money_with_currency
      add :affiliates_advances, :money_with_currency
      add :def_refundable_inc_tax, :money_with_currency
      add :other_current_assets, :money_with_currency
      add :prepaid, :money_with_currency
      add :machinery_equipment, :money_with_currency
      add :office_equipment, :money_with_currency
      add :other_fixed_assets, :money_with_currency
      add :transportation_equipment, :money_with_currency
      add :real_state_buildings, :money_with_currency
      add :less_accumulated_depr, :money_with_currency
      add :due_from_affiliates, :money_with_currency
      add :deferred_charges, :money_with_currency
      add :intangible_goodwill, :money_with_currency
      add :investment_others, :money_with_currency
      add :other_assets_1, :money_with_currency
      add :other_assets_2, :money_with_currency
      add :bank_overdraft, :money_with_currency
      add :accounts_payable, :money_with_currency
      add :bank_payable, :money_with_currency
      add :other_current_liab, :money_with_currency
      add :current_portion_ltd, :money_with_currency
      add :bank_long_term_debt, :money_with_currency
      add :other_lt_liabilities, :money_with_currency
      add :subordinated_debt, :money_with_currency
      add :common_stock, :money_with_currency
      add :other, :money_with_currency
      add :treasury_stock, :money_with_currency
      add :retained_earnings, :money_with_currency
      add :other_2, :money_with_currency
      add :dividens_other, :money_with_currency
      add :cash_flow_operation, :money_with_currency
      add :revenue, :money_with_currency
      add :less_return_allow, :money_with_currency
      add :cost_goods_sold, :money_with_currency
      add :cost_goods_other, :money_with_currency
      add :salaries_wages, :money_with_currency
      add :operating_experenses, :money_with_currency
      add :selling_expense, :money_with_currency
      add :other_selling_expense, :money_with_currency
      add :bad_debt_expense, :money_with_currency
      add :general_admin_exp, :money_with_currency
      add :depreciation_expense, :money_with_currency
      add :amortization_expense, :money_with_currency
      add :interest_expense, :money_with_currency
      add :non_recurring_expense, :money_with_currency
      add :interest_income, :money_with_currency
      add :other_income_expense, :money_with_currency
      add :taxes, :money_with_currency
      add(:local_currency_id, references(:local_currencies, on_delete: :nothing, type: :uuid))
      add(:exchange_rate_id, references(:exchange_rates, on_delete: :nothing, type: :uuid))
      add(:user_id, references(:users, on_delete: :nothing, type: :uuid))

      timestamps(type: :utc_datetime)
    end
  end
end
