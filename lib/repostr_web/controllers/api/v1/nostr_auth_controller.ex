defmodule RepostrWeb.Api.V1.NostrAuthController do
  use RepostrWeb, :controller

  def login(conn, %{"event" => event}) do
    # Get the pubkey from the event
    pubkey = event["pubkey"]

    if pubkey do
      # Store in session
      conn
      |> put_session(:user_pubkey, pubkey)
      |> json(%{success: true})
    else
      conn
      |> put_status(401)
      |> json(%{error: "Missing public key"})
    end
  end
end
