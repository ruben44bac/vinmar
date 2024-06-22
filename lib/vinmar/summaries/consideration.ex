defmodule Vinmar.Summaries.Consideration do
  @moduledoc false
  use TypedEctoSchema

  import Ecto.Changeset

  alias Vinmar.Summaries.ExecutiveSummary

  @timestamps_opts [type: :utc_datetime]
  @primary_key {:id, Ecto.UUID, autogenerate: true}
  @optional_fields [:type, :executive_summary_id]
  @required_fields []

  typed_schema "executive_summary_considerations" do
    field :type, Ecto.Enum, values: [:positive, :negative]

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
