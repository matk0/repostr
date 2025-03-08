defmodule RepostrWeb.HomeLive do
  use RepostrWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
