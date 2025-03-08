defmodule RepostrWeb.SessionController do
  use RepostrWeb, :controller
  
  def clear(conn, _params) do
    # Clear the entire session
    conn
    |> configure_session(drop: true)
    |> redirect(to: ~p"/")
  end
end