defmodule VinmarWeb.NavbarComponents do
  @moduledoc """

  """
  use Phoenix.LiveComponent

  def render(assigns) do
    ~H"""
    <div class="hidden lg:flex lg:w-64 lg:flex-col lg:fixed lg:inset-y-0">
      <!-- Sidebar component, swap this element with another sidebar if you like -->
      <div class="flex flex-col flex-grow bg-white pt-5 pb-4 overflow-y-auto">
        <div class="flex items-center flex-shrink-0 px-4 text-3xl text-white font-bold text-center">
          <img src="/images/logo.png" class="w-3/4 h-auto" >
        </div>
        <nav class="mt-5 flex-1 flex flex-col divide-y divide-gray-300 overflow-y-auto" aria-label="Sidebar">
          <div class="px-2 space-y-1">
            <%= for s <- @sections do %>
              <a href={s.url} class={s.class} aria-current="page">
                <%= Phoenix.HTML.raw(s.svg) %>
                <%= s.name %>
              </a>
            <% end %>
          </div>
          <div class="pt-2 mt-auto">
            <div class="px-2 space-y-1">
              <a href="#" class="group flex items-center px-2 py-2 text-sm leading-6 font-medium rounded-md text-green-800 hover:text-green-900 hover:font-bold hover:bg-green-200">
                <!-- Heroicon name: outline/cog -->
                <svg class="mr-4 h-6 w-6 text-green-900" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" aria-hidden="true">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z" />
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                </svg>
                Configuraciones
              </a>
              <a href="#" class="group flex items-center px-2 py-2 text-sm leading-6 font-medium rounded-md text-green-800 hover:text-green-900 hover:font-bold hover:bg-green-200">
                <!-- Heroicon name: outline/question-mark-circle -->
                <svg class="mr-4 h-6 w-6 text-green-900" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" aria-hidden="true">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8.228 9c.549-1.165 2.03-2 3.772-2 2.21 0 4 1.343 4 3 0 1.4-1.278 2.575-3.006 2.907-.542.104-.994.54-.994 1.093m0 3h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                </svg>
                Ayuda
              </a>
              <a href="#" class="group flex items-center px-2 py-2 text-sm leading-6 font-medium rounded-md text-green-800 hover:text-green-900 hover:font-bold hover:bg-green-200">
                <!-- Heroicon name: outline/shield-check -->
                <svg class="mr-4 h-6 w-6 text-green-900" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" aria-hidden="true">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z" />
                </svg>
                Privacidad
              </a>
              <a href="/login" class="group flex items-center px-2 py-2 text-sm leading-6 font-medium rounded-md text-green-800 hover:text-green-900 hover:font-bold hover:bg-green-200">
                <!-- Heroicon name: outline/shield-check -->
                <svg class="mr-4 h-5 w-5 text-green-900" xmlns="http://www.w3.org/2000/svg" stroke="currentColor" viewBox="0 0 512 512">
                  <path fill="currentColor" d="M160 96c17.7 0 32-14.3 32-32s-14.3-32-32-32H96C43 32 0 75 0 128V384c0 53 43 96 96 96h64c17.7 0 32-14.3 32-32s-14.3-32-32-32H96c-17.7 0-32-14.3-32-32l0-256c0-17.7 14.3-32 32-32h64zM504.5 273.4c4.8-4.5 7.5-10.8 7.5-17.4s-2.7-12.9-7.5-17.4l-144-136c-7-6.6-17.2-8.4-26-4.6s-14.5 12.5-14.5 22v72H192c-17.7 0-32 14.3-32 32l0 64c0 17.7 14.3 32 32 32H320v72c0 9.6 5.7 18.2 14.5 22s19 2 26-4.6l144-136z"/>
                </svg>
                Salir
              </a>
            </div>
          </div>
        </nav>
      </div>
    </div>
    """
  end

  def mount(socket) do
    {:ok, assign(socket, current_user: nil, sections: sections(0))}
  end

  def update(attrs, socket) do
    {:ok, assign(socket, current_user: attrs[:current_user], sections: sections(attrs[:section_id]))}
  end

  defp sections(id \\ 0) do
    [
      %{id: 1, name: "Home", url: "/", svg: "
        <svg class=\"mr-4 flex-shrink-0 h-6 w-6 text-green-900\" xmlns=\"http://www.w3.org/2000/svg\" fill=\"none\" viewBox=\"0 0 24 24\" stroke=\"currentColor\" aria-hidden=\"true\">
          <path stroke-linecap=\"round\" stroke-linejoin=\"round\" stroke-width=\"2\" d=\"M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6\" />
        </svg>"},
      %{id: 2, name: "Clientes", url: "/clients", svg: "
        <svg  class=\"mr-4 flex-shrink-0 h-6 w-6 text-green-900\" xmlns=\"http://www.w3.org/2000/svg\" width=\"24\" height=\"24\" viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"2\" stroke-linecap=\"round\" stroke-linejoin=\"round\">
          <path d=\"M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2\"></path>
          <circle cx=\"9\" cy=\"7\" r=\"4\"></circle>
          <path d=\"M23 21v-2a4 4 0 0 0-3-3.87\"></path>
          <path d=\"M16 3.13a4 4 0 0 1 0 7.75\"></path>
        </svg>"},
        %{id: 3, name: "Credit recommendation", url: "/credit_recommendation", svg: "
        <svg  class=\"mr-4 flex-shrink-0 h-6 w-6 text-green-900\" xmlns=\"http://www.w3.org/2000/svg\" width=\"24\" height=\"24\" viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"2\" stroke-linecap=\"round\" stroke-linejoin=\"round\">
          <path d=\"M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2\"></path>
          <circle cx=\"9\" cy=\"7\" r=\"4\"></circle>
          <path d=\"M23 21v-2a4 4 0 0 0-3-3.87\"></path>
          <path d=\"M16 3.13a4 4 0 0 1 0 7.75\"></path>
        </svg>"}
    ]
    |> Enum.map(fn s ->
      s
      |> Map.put(
        :class,
        if(id == s.id,
          do: "bg-rose-800 text-white",
          else: "text-green-800 hover:text-green-900 hover:font-bold hover:bg-green-200"
        ) <> " group flex items-center px-2 py-2 text-sm leading-6 font-medium rounded-md"
      )
    end)
  end
end
