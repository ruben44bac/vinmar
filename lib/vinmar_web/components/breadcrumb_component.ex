defmodule VinmarWeb.BreadcrumbComponent do
  @moduledoc false

  use Phoenix.LiveComponent

  def render(assigns) do
    ~H"""
    <div class="w-full bg-white rounded-lg p-3">
      <nav class="flex" aria-label="Breadcrumb">
        <ol role="list" class="flex items-center space-x-4">
          <%= for {data, index} <- Enum.with_index(@tree) do %>
            <%= if data.key == :home do %>
              <li>
                <div>
                  <a href={data.link} class="text-gray-400 hover:text-gray-500">
                    <svg
                      class="h-5 w-5 flex-shrink-0"
                      viewBox="0 0 20 20"
                      fill="currentColor"
                      aria-hidden="true"
                    >
                      <path
                        fill-rule="evenodd"
                        d="M9.293 2.293a1 1 0 011.414 0l7 7A1 1 0 0117 11h-1v6a1 1 0 01-1 1h-2a1 1 0 01-1-1v-3a1 1 0 00-1-1H9a1 1 0 00-1 1v3a1 1 0 01-1 1H5a1 1 0 01-1-1v-6H3a1 1 0 01-.707-1.707l7-7z"
                        clip-rule="evenodd"
                      />
                    </svg>
                    <span class="sr-only">Home</span>
                  </a>
                </div>
              </li>
            <% else %>
              <li>
                <div class="flex items-center">
                  <%= if index < length(@tree) do %>
                    <svg
                      class="h-5 w-5 flex-shrink-0 text-gray-400"
                      viewBox="0 0 20 20"
                      fill="currentColor"
                      aria-hidden="true"
                    >
                      <path
                        fill-rule="evenodd"
                        d="M7.21 14.77a.75.75 0 01.02-1.06L11.168 10 7.23 6.29a.75.75 0 111.04-1.08l4.5 4.25a.75.75 0 010 1.08l-4.5 4.25a.75.75 0 01-1.06-.02z"
                        clip-rule="evenodd"
                      />
                    </svg>
                  <% end %>
                  <a
                    href={data.link}
                    class="ml-4 text-sm font-medium text-gray-500 hover:text-gray-700"
                    aria-current="page"
                  >
                    <%= data.name %>
                  </a>
                </div>
              </li>
            <% end %>
          <% end %>
        </ol>
      </nav>
    </div>
    """
  end

  def mount(socket) do
    {:ok, assign(socket, tree: [])}
  end

  def update(attrs, socket) do
    {:ok, assign(socket, tree: complete_tree(attrs.tree))}
  end

  defp complete_tree(tree) do
    Enum.map(tree, &get_tree(&1))
  end

  defp get_tree(:home), do: %{link: "/", name: "Home", key: :home}

  defp get_tree(:customer_list),
    do: %{link: "/customer", name: "Customers", key: :customer_list}

  defp get_tree(:new_customer),
    do: %{link: "/customer/form", name: "New Customer", key: :new_customer}

  defp get_tree(:edit_customer),
    do: %{link: "#", name: "Edit Customer", key: :edit_customer}

  defp get_tree(:summary_list),
    do: %{link: "/summary", name: "Summaries", key: :summary_list}

  defp get_tree(:new_summary),
    do: %{link: "/summary/form", name: "New Summary", key: :new_summary}

  defp get_tree(:edit_summary),
    do: %{link: "#", name: "Edit Summary", key: :edit_summary}

  defp get_tree(:local_currency_list),
    do: %{link: "/local_currency", name: "Credit Analysis", key: :local_currency_list}

  defp get_tree(:new_local_currency),
    do: %{link: "/local_currency/form", name: "New Credit Analysis", key: :new_local_currency}

  defp get_tree(:edit_local_currency),
    do: %{link: "#", name: "Edit Credit Analysis", key: :edit_local_currency}

  defp get_tree(_atom), do: %{link: "/", name: "", key: :atom}
end
