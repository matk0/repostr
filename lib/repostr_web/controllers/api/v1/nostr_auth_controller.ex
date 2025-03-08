defmodule RepostrWeb.Api.V1.NostrAuthController do
  use RepostrWeb, :controller

  def login(conn, %{"event" => event}) do
    # Get the pubkey from the event
    pubkey = event["pubkey"]
    IO.puts("API received pubkey: #{pubkey}")
    IO.puts("=============")
    IO.puts(pubkey)
    IO.puts("=============")

    if pubkey do
      # Print session before we modify it
      IO.puts("Session before storing pubkey:")
      IO.inspect(get_session(conn), label: "Session before")

      # Store in session using string key to match LiveView
      conn = put_session(conn, "user_pubkey", pubkey)

      # Print session after we modify it to verify
      IO.puts("Session after storing pubkey:")
      IO.inspect(get_session(conn), label: "Session after")

      # Return success response
      json(conn, %{success: true})
    else
      conn
      |> put_status(401)
      |> json(%{error: "Missing public key"})
    end
  end
end
