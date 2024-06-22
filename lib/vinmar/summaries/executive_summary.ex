defmodule Vinmar.Summaries.ExecutiveSummary do
  @moduledoc false
  use TypedEctoSchema

  import Ecto.Changeset

  alias Vinmar.Accounts.User
  alias Vinmar.Customers.Customer

  alias Vinmar.Summaries.{
    ReviewedPeriod,
    CollateralType,
    InsuranceCompany,
    FinancialStatementSource
  }

  @timestamps_opts [type: :utc_datetime]
  @primary_key {:id, Ecto.UUID, autogenerate: true}
  @optional_fields [
    :customer_id,
    :user_id
  ]
  @required_fields [
    :version,
    :version_date,
    :reviewed_at,
    :next_reviewed_at,
    :current_credit_limit,
    :current_insurance_coverage,
    :request_credit_limit,
    :request_insurance_coverage,
    :amount,
    :last_expirated_at,
    :dra,
    :recommended_limit,
    :credit_agency_rating,
    :summary,
    :recommended_credit_limit,
    :payment_term,
    :credit_facilities,
    :availability_headroom,
    :expirated_at,
    :current_coverage_type,
    :request_coverage_type,
    :outlook,
    :financial_statement_source_id,
    :current_insurance_company_id,
    :request_insurance_company_id,
    :collateral_type_id,
    :reviewed_period_id
  ]

  typed_schema "executive_summaries" do
    field :version, :decimal
    field :version_date, :date
    field :reviewed_at, :utc_datetime
    field :next_reviewed_at, :utc_datetime
    field :current_credit_limit, Money.Ecto.Amount.Type
    field :current_insurance_coverage, Money.Ecto.Amount.Type
    field :request_credit_limit, Money.Ecto.Amount.Type
    field :request_insurance_coverage, Money.Ecto.Amount.Type
    field :amount, Money.Ecto.Amount.Type
    field :last_expirated_at, :utc_datetime
    field :dra, :integer
    field :recommended_limit, Money.Ecto.Amount.Type
    field :credit_agency_rating, :string
    field :summary, :string
    field :recommended_credit_limit, Money.Ecto.Amount.Type
    field :payment_term, :decimal
    field :credit_facilities, Money.Ecto.Amount.Type
    field :availability_headroom, Money.Ecto.Amount.Type
    field :expirated_at, :utc_datetime

    field :current_coverage_type, Ecto.Enum, values: [:named, :dcl, :uninsured]
    field :request_coverage_type, Ecto.Enum, values: [:named, :dcl, :uninsured]
    field :outlook, Ecto.Enum, values: [:positive, :stable, :negative]

    belongs_to :financial_statement_source, FinancialStatementSource,
      foreign_key: :financial_statement_source_id,
      type: Ecto.UUID

    belongs_to :current_insurance_company, InsuranceCompany,
      foreign_key: :current_insurance_company_id,
      type: Ecto.UUID

    belongs_to :insurance_company, InsuranceCompany,
      foreign_key: :request_insurance_company_id,
      type: Ecto.UUID

    belongs_to :collateral_type, CollateralType,
      foreign_key: :collateral_type_id,
      type: Ecto.UUID

    belongs_to :reviewed_period, ReviewedPeriod,
      foreign_key: :reviewed_period_id,
      type: Ecto.UUID

    belongs_to :user, User,
      foreign_key: :user_id,
      type: Ecto.UUID

    belongs_to :customer, Customer,
      foreign_key: :customer_id,
      type: Ecto.UUID

    timestamps()
  end

  @spec changeset(t(), map()) :: Ecto.Changeset.t()
  def changeset(schema, attrs) do
    schema
    |> cast(attrs, @required_fields)
    |> cast(attrs, @optional_fields)
    |> validate_required(@required_fields)
  end
end
