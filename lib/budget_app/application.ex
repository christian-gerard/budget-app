defmodule BudgetApp.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      BudgetAppWeb.Telemetry,
      BudgetApp.Repo,
      {DNSCluster, query: Application.get_env(:budget_app, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: BudgetApp.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: BudgetApp.Finch},
      # Start a worker by calling: BudgetApp.Worker.start_link(arg)
      # {BudgetApp.Worker, arg},
      # Start to serve requests, typically the last entry
      BudgetAppWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: BudgetApp.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    BudgetAppWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
