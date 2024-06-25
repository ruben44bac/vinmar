defmodule Vinmar.Customers.Country do
  @moduledoc false
  use TypedEctoSchema

  import Ecto.Changeset

  @timestamps_opts [type: :utc_datetime]
  @primary_key {:id, Ecto.UUID, autogenerate: true}
  @optional_fields [:name]
  @required_fields [
    :rating,
    :mr_2015,
    :sp_rating,
    :sp_score,
    :db_rating,
    :db_score,
    :coface_rating,
    :coface_score,
    :eiu_rating,
    :eiu_score,
    :ihs_rating,
    :score,
    :total,
    :mean_score,
    :comments,
    :insurance_coverage
  ]

  typed_schema "countries" do
    field :name, :string
    field :rating, :string
    field :mr_2015, :string
    field :sp_rating, :string
    field :sp_score, :decimal
    field :db_rating, :string
    field :db_score, :decimal
    field :coface_rating, :string
    field :coface_score, :decimal
    field :eiu_rating, :string
    field :eiu_score, :decimal
    field :ihs_rating, :decimal
    field :score, :decimal
    field :total, :decimal
    field :mean_score, :decimal
    field :comments, :string
    field :insurance_coverage, :string

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
