defmodule RepostrWeb.HomeLive do
  use RepostrWeb, :live_view

  def mount(_params, session, socket) do
    user_pubkey = session["user_pubkey"]

    IO.puts("pubkey:")
    IO.puts(user_pubkey)

    socket =
      socket
      |> assign(:logged_in, user_pubkey != nil)
      |> assign(:user_pubkey, user_pubkey)

    {:ok, socket}
  end
end
