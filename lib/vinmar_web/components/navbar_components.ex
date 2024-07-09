defmodule VinmarWeb.NavbarComponent do
  @moduledoc """

  """
  use Phoenix.LiveComponent

  def render(assigns) do
    ~H"""
    <div class="w-full">
      <div class="hidden lg:flex lg:w-64 lg:flex-col lg:fixed lg:inset-y-0 p-3">
        <!-- Sidebar component, swap this element with another sidebar if you like -->
        <div class="flex flex-col flex-grow bg-slate-900 rounded-lg overflow-y-auto p-3">
          <div class="flex items-center flex-shrink-0 text-3xl bg-slate-100 rounded-lg py-6 flex font-bold text-center">
            <img src="/images/logo.png" class="w-3/4 h-auto mx-auto" />
          </div>
          <nav
            class="mt-5 flex-1 flex flex-col divide-y divide-gray-300 overflow-y-auto"
            aria-label="Sidebar"
          >
            <div class="space-y-1">
              <%= for s <- @sections do %>
                <a href={s.url} class={s.class} aria-current="page">
                  <%= Phoenix.HTML.raw(s.svg) %>
                  <%= s.name %>
                </a>
              <% end %>
            </div>
            <div class="pt-2 mt-auto">
              <div class=" space-y-1">
                <a
                  href="#"
                  class="group flex items-center px-2 py-2 text-sm leading-6 font-medium rounded-md text-slate-100 hover:text-green-900 hover:font-bold hover:bg-green-200"
                >
                  <!-- Heroicon name: outline/cog -->
                  <svg
                    class="mr-4 h-6 w-6"
                    xmlns="http://www.w3.org/2000/svg"
                    fill="none"
                    viewBox="0 0 24 24"
                    stroke="currentColor"
                    aria-hidden="true"
                  >
                    <path
                      stroke-linecap="round"
                      stroke-linejoin="round"
                      stroke-width="2"
                      d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z"
                    />
                    <path
                      stroke-linecap="round"
                      stroke-linejoin="round"
                      stroke-width="2"
                      d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"
                    />
                  </svg>
                  Configuraciones
                </a>
                <a
                  href="#"
                  class="group flex items-center px-2 py-2 text-sm leading-6 font-medium rounded-md text-slate-100 hover:text-green-900 hover:font-bold hover:bg-green-200"
                >
                  <!-- Heroicon name: outline/question-mark-circle -->
                  <svg
                    class="mr-4 h-6 w-6"
                    xmlns="http://www.w3.org/2000/svg"
                    fill="none"
                    viewBox="0 0 24 24"
                    stroke="currentColor"
                    aria-hidden="true"
                  >
                    <path
                      stroke-linecap="round"
                      stroke-linejoin="round"
                      stroke-width="2"
                      d="M8.228 9c.549-1.165 2.03-2 3.772-2 2.21 0 4 1.343 4 3 0 1.4-1.278 2.575-3.006 2.907-.542.104-.994.54-.994 1.093m0 3h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"
                    />
                  </svg>
                  Ayuda
                </a>
                <a
                  href="#"
                  class="group flex items-center px-2 py-2 text-sm leading-6 font-medium rounded-md text-slate-100 hover:text-green-900 hover:font-bold hover:bg-green-200"
                >
                  <!-- Heroicon name: outline/shield-check -->
                  <svg
                    class="mr-4 h-6 w-6"
                    xmlns="http://www.w3.org/2000/svg"
                    fill="none"
                    viewBox="0 0 24 24"
                    stroke="currentColor"
                    aria-hidden="true"
                  >
                    <path
                      stroke-linecap="round"
                      stroke-linejoin="round"
                      stroke-width="2"
                      d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z"
                    />
                  </svg>
                  Privacidad
                </a>
                <a
                  href="/users/log_out"
                  class="group flex items-center px-2 py-2 text-sm leading-6 font-medium rounded-md text-slate-100 hover:text-green-900 hover:font-bold hover:bg-green-200"
                >
                  <!-- Heroicon name: outline/shield-check -->
                  <svg
                    class="mr-4 h-5 w-5"
                    xmlns="http://www.w3.org/2000/svg"
                    stroke="currentColor"
                    viewBox="0 0 512 512"
                  >
                    <path
                      fill="currentColor"
                      d="M160 96c17.7 0 32-14.3 32-32s-14.3-32-32-32H96C43 32 0 75 0 128V384c0 53 43 96 96 96h64c17.7 0 32-14.3 32-32s-14.3-32-32-32H96c-17.7 0-32-14.3-32-32l0-256c0-17.7 14.3-32 32-32h64zM504.5 273.4c4.8-4.5 7.5-10.8 7.5-17.4s-2.7-12.9-7.5-17.4l-144-136c-7-6.6-17.2-8.4-26-4.6s-14.5 12.5-14.5 22v72H192c-17.7 0-32 14.3-32 32l0 64c0 17.7 14.3 32 32 32H320v72c0 9.6 5.7 18.2 14.5 22s19 2 26-4.6l144-136z"
                    />
                  </svg>
                  Salir
                </a>
              </div>
            </div>
          </nav>
        </div>
      </div>
      <div class="lg:hidden w-full px-2 py-2 bg-slate-900 text-white z-20">
        <div class="w-full inline-flex items-center">
          <div class="w-10 h-10 inline-flex items-center"></div>
          <div class="mx-auto">
            <label class="text-2xl text-white font-bold">Vinmar</label>
          </div>
          <button
            class="w-10 h-10 inline-flex items-center"
            type="button"
            phx-click="open_menu"
            phx-target={@myself}
          >
            <svg
              xmlns="http://www.w3.org/2000/svg"
              fill="currentColor"
              class="w-6 h-6 text-white mx-auto"
              viewBox="0 0 448 512"
            >
              <path d="M0 96C0 78.3 14.3 64 32 64H416c17.7 0 32 14.3 32 32s-14.3 32-32 32H32C14.3 128 0 113.7 0 96zM0 256c0-17.7 14.3-32 32-32H416c17.7 0 32 14.3 32 32s-14.3 32-32 32H32c-17.7 0-32-14.3-32-32zM448 416c0 17.7-14.3 32-32 32H32c-17.7 0-32-14.3-32-32s14.3-32 32-32H416c17.7 0 32 14.3 32 32z" />
            </svg>
          </button>
        </div>
      </div>
      <%= if @open_menu do %>
        <div class="z-40 fixed top-0 left-0 w-full h-screen bg-slate-900">
          <div class="w-full inline-flex items-center p-2">
            <div class="w-10 h-10 inline-flex items-center"></div>
            <div class="mx-auto">
              <label class="text-2xl text-white font-bold">Vinmar</label>
            </div>
            <button
              class="w-10 h-10 inline-flex items-center"
              type="button"
              phx-click="open_menu"
              phx-target={@myself}
            >
              <svg
                xmlns="http://www.w3.org/2000/svg"
                fill="currentColor"
                class="w-6 h-6 text-white mx-auto"
                viewBox="0 0 384 512"
              >
                <path d="M342.6 150.6c12.5-12.5 12.5-32.8 0-45.3s-32.8-12.5-45.3 0L192 210.7 86.6 105.4c-12.5-12.5-32.8-12.5-45.3 0s-12.5 32.8 0 45.3L146.7 256 41.4 361.4c-12.5 12.5-12.5 32.8 0 45.3s32.8 12.5 45.3 0L192 301.3 297.4 406.6c12.5 12.5 32.8 12.5 45.3 0s12.5-32.8 0-45.3L237.3 256 342.6 150.6z" />
              </svg>
            </button>
          </div>
          <div>
            <div class="space-y-1 mt-10">
              <%= for s <- @sections do %>
                <a href={s.url} class={s.class} aria-current="page">
                  <%= s.name %>
                </a>
              <% end %>
            </div>
          </div>
        </div>
      <% end %>
    </div>
    """
  end

  def mount(socket) do
    {:ok, assign(socket, current_user: nil, sections: sections(0), open_menu: false)}
  end

  def update(attrs, socket) do
    {:ok,
     assign(socket, current_user: attrs[:current_user], sections: sections(attrs[:section_id]))}
  end

  def handle_event("open_menu", _params, socket) do
    {:noreply, assign(socket, open_menu: !socket.assigns.open_menu)}
  end

  defp sections(id \\ 0) do
    [
      %{id: 1, name: "Home", url: "/", svg: "
        <svg class=\"mr-4 flex-shrink-0 h-6 w-6\" xmlns=\"http://www.w3.org/2000/svg\" fill=\"none\" viewBox=\"0 0 24 24\" stroke=\"currentColor\" aria-hidden=\"true\">
          <path stroke-linecap=\"round\" stroke-linejoin=\"round\" stroke-width=\"2\" d=\"M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6\" />
        </svg>"},
      %{id: 2, name: "Customer", url: "/customer", svg: "
        <svg  class=\"mr-4 flex-shrink-0 h-6 w-6\" xmlns=\"http://www.w3.org/2000/svg\" width=\"24\" height=\"24\" viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"2\" stroke-linecap=\"round\" stroke-linejoin=\"round\">
          <path d=\"M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2\"></path>
          <circle cx=\"9\" cy=\"7\" r=\"4\"></circle>
          <path d=\"M23 21v-2a4 4 0 0 0-3-3.87\"></path>
          <path d=\"M16 3.13a4 4 0 0 1 0 7.75\"></path>
        </svg>"},
      %{
        id: 3,
        name: "Summary",
        url: "/summary",
        svg: """
        <svg class=\"mr-4 flex-shrink-0 h-6 w-6\"  xmlns="http://www.w3.org/2000/svg" width=\"24\" height=\"24\" fill=\"currentColor\" viewBox=\"0 0 384 512\">
          <path d="M64 0C28.7 0 0 28.7 0 64V448c0 35.3 28.7 64 64 64H320c35.3 0 64-28.7 64-64V160H256c-17.7 0-32-14.3-32-32V0H64zM256 0V128H384L256 0zM64 80c0-8.8 7.2-16 16-16h64c8.8 0 16 7.2 16 16s-7.2 16-16 16H80c-8.8 0-16-7.2-16-16zm0 64c0-8.8 7.2-16 16-16h64c8.8 0 16 7.2 16 16s-7.2 16-16 16H80c-8.8 0-16-7.2-16-16zm128 72c8.8 0 16 7.2 16 16v17.3c8.5 1.2 16.7 3.1 24.1 5.1c8.5 2.3 13.6 11 11.3 19.6s-11 13.6-19.6 11.3c-11.1-3-22-5.2-32.1-5.3c-8.4-.1-17.4 1.8-23.6 5.5c-5.7 3.4-8.1 7.3-8.1 12.8c0 3.7 1.3 6.5 7.3 10.1c6.9 4.1 16.6 7.1 29.2 10.9l.5 .1 0 0 0 0c11.3 3.4 25.3 7.6 36.3 14.6c12.1 7.6 22.4 19.7 22.7 38.2c.3 19.3-9.6 33.3-22.9 41.6c-7.7 4.8-16.4 7.6-25.1 9.1V440c0 8.8-7.2 16-16 16s-16-7.2-16-16V422.2c-11.2-2.1-21.7-5.7-30.9-8.9l0 0 0 0c-2.1-.7-4.2-1.4-6.2-2.1c-8.4-2.8-12.9-11.9-10.1-20.2s11.9-12.9 20.2-10.1c2.5 .8 4.8 1.6 7.1 2.4l0 0 0 0 0 0c13.6 4.6 24.6 8.4 36.3 8.7c9.1 .3 17.9-1.7 23.7-5.3c5.1-3.2 7.9-7.3 7.8-14c-.1-4.6-1.8-7.8-7.7-11.6c-6.8-4.3-16.5-7.4-29-11.2l-1.6-.5 0 0c-11-3.3-24.3-7.3-34.8-13.7c-12-7.2-22.6-18.9-22.7-37.3c-.1-19.4 10.8-32.8 23.8-40.5c7.5-4.4 15.8-7.2 24.1-8.7V232c0-8.8 7.2-16 16-16z"/>
        </svg>
        """
      },
      %{
        id: 4,
        name: "Credit Analysis",
        url: "/local_currency",
        svg: """
        <svg class=\"mr-4 flex-shrink-0 h-6 w-6\"  xmlns="http://www.w3.org/2000/svg" width=\"24\" height=\"24\" fill=\"currentColor\" viewBox=\"0 0 512 512\">
          <path d="M75 75L41 41C25.9 25.9 0 36.6 0 57.9V168c0 13.3 10.7 24 24 24H134.1c21.4 0 32.1-25.9 17-41l-30.8-30.8C155 85.5 203 64 256 64c106 0 192 86 192 192s-86 192-192 192c-40.8 0-78.6-12.7-109.7-34.4c-14.5-10.1-34.4-6.6-44.6 7.9s-6.6 34.4 7.9 44.6C151.2 495 201.7 512 256 512c141.4 0 256-114.6 256-256S397.4 0 256 0C185.3 0 121.3 28.7 75 75zm181 53c-13.3 0-24 10.7-24 24V256c0 6.4 2.5 12.5 7 17l72 72c9.4 9.4 24.6 9.4 33.9 0s9.4-24.6 0-33.9l-65-65V152c0-13.3-10.7-24-24-24z"/>
        </svg>
        """
      }
    ]
    |> Enum.map(fn s ->
      s
      |> Map.put(
        :class,
        if(id == s.id,
          do: "text-green-800 text-white",
          else:
            "text-white lg:text-slate-100 hover:text-green-900 hover:font-bold hover:bg-green-200"
        ) <>
          " group block text-center lg:flex items-center px-2 py-2 text-xl lg:text-sm leading-6 font-medium rounded-md"
      )
    end)
  end
end
