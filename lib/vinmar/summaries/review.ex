defmodule Vinmar.Summaries.Review do
  @moduledoc false
  use TypedEctoSchema

  import Ecto.Changeset

  alias Vinmar.Summaries.ExecutiveSummary

  @timestamps_opts [type: :utc_datetime]
  @primary_key {:id, Ecto.UUID, autogenerate: true}
  @optional_fields [:executive_summary_id]
  @required_fields [
    :account_application,
    :credit_references,
    :credit_request_form,
    :visual_compliance,
    :financial_statements,
    :credit_reports,
    :insurance,
    :explanation
  ]

  typed_schema "executive_summary_review" do
    field :account_application, :boolean, default: false
    field :credit_references, :boolean, default: false
    field :credit_request_form, :boolean, default: false
    field :visual_compliance, :boolean, default: false
    field :financial_statements, :boolean, default: false
    field :credit_reports, :boolean, default: false
    field :insurance, :boolean, default: false
    field :explanation, :string

    belongs_to :executive_summary, ExecutiveSummary,
      foreign_key: :executive_summary_id,
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
