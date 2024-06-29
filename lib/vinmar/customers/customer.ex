defmodule Vinmar.Customers.Customer do
  @moduledoc false
  use TypedEctoSchema

  import Ecto.Changeset

  alias Vinmar.Customers.{
    Country,
    CustomerType
  }

  @timestamps_opts [type: :utc_datetime]
  @primary_key {:id, Ecto.UUID, autogenerate: true}
  @optional_fields [:sap_id, :name, :created_at]
  @required_fields [:inception_at, :customer_type_id, :country_id]

  typed_schema "customers" do
    field :sap_id, :string
    field :name, :string
    field :created_at, :utc_datetime
    field :inception_at, :utc_datetime

    belongs_to :customer_type, CustomerType,
      foreign_key: :customer_type_id,
      type: Ecto.UUID

    belongs_to :country, Country,
      foreign_key: :country_id,
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
