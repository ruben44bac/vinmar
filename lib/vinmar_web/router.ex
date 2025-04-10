defmodule VinmarWeb.Router do
  alias Credo.CLI.Output.Summary
  use VinmarWeb, :router

  import VinmarWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {VinmarWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", VinmarWeb do
    pipe_through :browser
  end

  # Other scopes may use custom stacks.
  # scope "/api", VinmarWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:vinmar, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: VinmarWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", VinmarWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    live_session :redirect_if_user_is_authenticated,
      on_mount: [{VinmarWeb.UserAuth, :redirect_if_user_is_authenticated}] do
      live "/users/register", UserRegistrationLive, :new
      live "/users/log_in", UserLoginLive, :new
      live "/users/reset_password", UserForgotPasswordLive, :new
      live "/users/reset_password/:token", UserResetPasswordLive, :edit
    end

    post "/users/log_in", UserSessionController, :create
  end

  scope "/", VinmarWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [{VinmarWeb.UserAuth, :ensure_authenticated}] do
      live "/users/settings", UserSettingsLive, :edit
      live "/users/settings/confirm_email/:token", UserSettingsLive, :confirm_email

      live "/", HomeLive.Index, :index

      live "/customer", CustomerLive.Index, :index
      live "/customer/form", CustomerLive.Form, :new
      live "/customer/form/:id", CustomerLive.Form, :edit

      live "/summary", SummaryLive.Index, :index
      live "/summary/form", SummaryLive.Form, :new
      live "/summary/form/:id", SummaryLive.Form, :edit
      live "/summary/form/:id/:step", SummaryLive.Form, :edit

      live "/local_currency", LocalCurrencyLive.Index, :index
      live "/local_currency/form", LocalCurrencyLive.Form, :new
      live "/local_currency/form/:id", LocalCurrencyLive.Form, :edit
    end
  end

  scope "/", VinmarWeb do
    pipe_through [:browser]

    get "/users/log_out", UserSessionController, :delete

    live_session :current_user,
      on_mount: [{VinmarWeb.UserAuth, :mount_current_user}] do
      live "/users/confirm/:token", UserConfirmationLive, :edit
      live "/users/confirm", UserConfirmationInstructionsLive, :new
    end
  end
end
