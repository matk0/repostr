defmodule RepostrWeb.NostrAuthController do
  use RepostrWeb, :controller

  def logout(conn, _params) do
    conn
    |> clear_session()
    |> redirect(to: ~p"/")
  end
end
