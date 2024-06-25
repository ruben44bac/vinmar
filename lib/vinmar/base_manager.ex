defmodule Vinmar.BaseManager do
  @moduledoc """
  Base module with basic manager functionality to generate new managers quickly.
  Every function is overridable

  Provided schema must implement a changeset/2 function

  Example:
    use TasksNotifications.Contexts.BaseManager, repo: Repo, schema: Schema

  """

  import Ecto.Query

  alias __MODULE__

  defmacro __using__(opts) do
    quote do
      import Ecto.Query
      alias Vinmar.BaseManager

      @schema unquote(Keyword.fetch!(opts, :schema))
      @repo unquote(Keyword.get(opts, :repo, TasksNotifications.Repo))
      @default_preload unquote(Keyword.get(opts, :default_preload, []))
      @except unquote(Keyword.get(opts, :except, []))
      @only unquote(
              Keyword.get(opts, :only, [
                :exists?,
                :get,
                :get!,
                :get_all,
                :stream,
                :aggregate,
                :create,
                :create!,
                :update,
                :update!,
                :update_state,
                :delete,
                :preloads
              ])
            )

      @generated_functions @only -- @except

      @type response_tuple :: {:ok, @schema.t()} | {:error, Ecto.Changeset.t()}
      @type filter_list() :: Keyword.t()
      @type search_list() :: Keyword.t()
      @type order_by() :: [desc: atom() | tuple(), asc: atom() | tuple()]
      @type preload_item :: atom() | {atom(), preload()}
      @type preload :: atom() | [preload_item()]

      if :exists? in @generated_functions do
        BaseManager.generate_exists?()
      end

      if :get in @generated_functions do
        BaseManager.generate_get()
      end

      if :get! in @generated_functions do
        BaseManager.generate_get!()
      end

      if :get_all in @generated_functions do
        BaseManager.generate_get_all()
      end

      if :stream in @generated_functions do
        BaseManager.generate_stream()
      end

      if :aggregate in @generated_functions do
        BaseManager.generate_aggregate()
      end

      if :update_state in @generated_functions do
        BaseManager.generate_update_state()
      end

      if :create in @generated_functions do
        BaseManager.generate_create()
      end

      if :create! in @generated_functions do
        BaseManager.generate_create!()
      end

      if :update in @generated_functions do
        BaseManager.generate_update()
      end

      if :update! in @generated_functions do
        BaseManager.generate_update!()
      end

      if :delete in @generated_functions do
        BaseManager.generate_delete()
      end

      if :preloads in @generated_functions do
        BaseManager.generate_preloads()
      end
    end
  end

  defmacro generate_exists? do
    quote do
      @doc """
      Checks if there exists an entry that matches the given query.

      # checks if any entry exist
      Manager.exists?()
      """
      @spec exists?(keyword(), keyword()) :: boolean()
      def exists?(filters \\ [], options \\ [])

      def exists?(filters, options) do
        BaseManager.do_exists?({@repo, @schema}, {filters, options})
      end

      defoverridable exists?: 0, exists?: 1, exists?: 2
    end
  end

  defmacro generate_get do
    quote do
      @doc """
      Gets a record by its ID or by the given filters
      A second parametter with preloads can be used.
      Manager.get("1234-1234-1234-1234")
      Manager.get(document_number: "12345541")
      """
      @spec get(String.t() | keyword(), preload()) :: @schema.t | nil
      def get(filters_or_id, preloads \\ @default_preload)

      def get(filters_or_id, preloads) do
        BaseManager.do_get({@repo, @schema}, {filters_or_id, preloads})
      end

      defoverridable get: 1, get: 2
    end
  end

  defmacro generate_get! do
    quote do
      @doc """
      Same as get/1 but raises if no record is found.
      """
      @spec get!(String.t() | keyword(), preload()) :: @schema.t
      def get!(filters_or_id, preloads \\ @default_preload)

      def get!(filters_or_id, preloads) do
        BaseManager.do_get!({@repo, @schema}, {filters_or_id, preloads})
      end

      defoverridable get!: 1, get!: 2
    end
  end

  defmacro generate_get_all do
    quote do
      @doc """
      Get a list of records
      """
      @spec get_all(filter_list(), order_by(), search_list(), preload()) :: list(@schema.t())
      def get_all(
            filters \\ [],
            order \\ [desc: :inserted_at],
            search \\ [],
            preloads \\ @default_preload
          )

      def get_all(filters, order, search, preloads) do
        BaseManager.do_get_all(
          {@repo, @schema},
          {filters, order, search, preloads}
        )
      end

      defoverridable get_all: 0, get_all: 1, get_all: 2, get_all: 3
    end
  end

  defmacro generate_stream do
    quote do
      @doc """
      Get a list of records in a stream (using Repo.stream)
      """
      @spec stream(filter_list(), order_by(), Keyword.t()) :: Enumerable.t()
      def stream(filters \\ [], order \\ [desc: :inserted_at], options \\ []) do
        BaseManager.do_stream(
          {@repo, @schema},
          {filters, order, options}
        )
      end

      defoverridable stream: 0, stream: 1, stream: 2, stream: 3
    end
  end

  defmacro generate_aggregate do
    quote do
      @doc """
      Calculates the given aggregate for the given filters
      """
      @spec aggregate(atom(), filter_list()) :: non_neg_integer() | float()
      def aggregate(aggregate, filters \\ [])

      def aggregate(aggregate, filters) do
        BaseManager.do_aggregate(
          {@repo, @schema},
          {aggregate, filters}
        )
      end

      defoverridable aggregate: 1, aggregate: 2
    end
  end

  defmacro generate_create do
    quote do
      @doc """
      Creates a new record
      """
      @spec create(map(), list(), map()) :: response_tuple()
      def create(attrs, options \\ [], carbonite \\ nil)

      def create(attrs, options, nil) do
        BaseManager.do_create(
          {@repo, @schema},
          {%@schema{}, attrs, options}
        )
      end

      def create(attrs, options, carbonite) do
        BaseManager.do_create(
          {@repo, @schema},
          {%@schema{}, attrs, options, carbonite}
        )
      end

      defoverridable create: 1, create: 2, create: 3
    end
  end

  defmacro generate_create! do
    quote do
      @doc """
      Creates a new record
      """
      @spec create!(map(), list()) :: @schema.t()
      def create!(attrs, options \\ []) do
        BaseManager.do_create!(
          {@repo, @schema},
          {%@schema{}, attrs, options}
        )
      end

      defoverridable create!: 1, create!: 2
    end
  end

  defmacro generate_update do
    quote do
      @doc """
      Updates a given schema
      """
      @spec update(@schema.t(), map()) :: response_tuple()
      @spec update(@schema.t(), map(), map() | nil) :: response_tuple()
      def update(struct, attrs, carbonite \\ nil)

      def update(%@schema{} = struct, attrs, nil) do
        BaseManager.do_update({@repo, @schema}, {struct, attrs})
      end

      def update(%@schema{} = struct, attrs, carbonite) do
        BaseManager.do_update(
          {@repo, @schema},
          {struct, attrs, carbonite}
        )
      end

      defoverridable update: 2, update: 3
    end
  end

  defmacro generate_update! do
    quote do
      @doc """
      Updates a given schema
      """
      @spec update!(@schema.t(), map()) :: @schema.t()
      def update!(%@schema{} = struct, attrs) do
        BaseManager.do_update!({@repo, @schema}, {struct, attrs})
      end

      defoverridable update!: 2
    end
  end

  defmacro generate_delete do
    quote do
      @doc """
      Deletes the given schema
      """
      @spec delete(@schema.t()) :: response_tuple()
      def delete(%@schema{} = struct) do
        @repo.delete(struct)
      end

      defoverridable delete: 1
    end
  end

  defmacro generate_preloads do
    quote do
      @doc """
      Loads preloads to the given struct
      """
      @spec preloads(@schema.t(), preload()) :: @schema.t()
      def preloads(struct, preloads) do
        @repo.preload(struct, preloads)
      end

      defoverridable preloads: 2
    end
  end

  def do_exists?({repo, schema}, {filters, options}) when is_list(filters) do
    schema
    |> where([], ^filters)
    |> repo.exists?(options)
  end

  def do_get({repo, schema}, {id, preloads}) when is_binary(id) do
    schema
    |> repo.get(id)
    |> repo.preload(preloads)
  end

  def do_get({repo, schema}, {filters, preloads}) when is_list(filters) do
    schema
    |> where([], ^filters)
    |> repo.one()
    |> repo.preload(preloads)
  end

  def do_get!({repo, schema}, {id, preloads}) when is_binary(id) do
    schema
    |> repo.get!(id)
    |> repo.preload(preloads)
  end

  def do_get!({repo, schema}, {filters, preloads}) when is_list(filters) do
    schema
    |> where([], ^filters)
    |> repo.one!()
    |> repo.preload(preloads)
  end

  def do_get_all({repo, schema}, {filters, order, search, preloads}) do
    schema
    |> where([], ^filters)
    |> build_search(search)
    |> order_by(^order)
    |> preload(^preloads)
    |> repo.all()
  end

  defp build_search(query, search) when length(search) == 0, do: query

  defp build_search(query, search) do
    search
    |> Enum.reduce(query, fn {k, v}, query_acc ->
      where(query_acc, [], ilike(^k, ^v))
    end)
  end

  def do_stream({repo, schema}, {filters, order, options}) do
    schema
    |> where([], ^filters)
    |> order_by(^order)
    |> repo.stream(options)
  end

  def do_aggregate({repo, schema}, {aggregate, filters}) do
    schema
    |> where([], ^filters)
    |> repo.aggregate(aggregate)
  end

  def do_create({repo, schema}, {struct, attrs, options}) do
    struct
    |> schema.changeset(attrs)
    |> repo.insert(options)
  end

  def do_create(
        {repo, schema},
        {struct, attrs, options, %{type: type, transaction_responsible: transaction_responsible}}
      ) do
    Ecto.Multi.new()
    |> Carbonite.Multi.insert_transaction(%{
      meta: %{type: type, transaction_responsible: transaction_responsible}
    })
    |> Ecto.Multi.insert(:create_entity, schema.changeset(struct, attrs))
    |> repo.transaction(options)
  end

  def do_create!({repo, schema}, {struct, attrs, options}) do
    struct
    |> schema.changeset(attrs)
    |> repo.insert!(options)
  end

  def do_update({repo, schema}, {struct, attrs}) do
    struct
    |> schema.changeset(attrs)
    |> repo.update()
  end

  def do_update(
        {repo, schema},
        {struct, attrs, options, %{type: type, transaction_responsible: transaction_responsible}}
      ) do
    Ecto.Multi.new()
    |> Carbonite.Multi.insert_transaction(%{
      meta: %{type: type, transaction_responsible: transaction_responsible}
    })
    |> Ecto.Multi.update(:update_entity, schema.changeset(struct, attrs))
    |> repo.transaction(options)
  end

  def do_update!({repo, schema}, {struct, attrs}) do
    struct
    |> schema.changeset(attrs)
    |> repo.update!()
  end
end
