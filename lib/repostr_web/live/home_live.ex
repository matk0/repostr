defmodule RepostrWeb.HomeLive do
  use RepostrWeb, :live_view

  def mount(_params, session, socket) do
    IO.puts("Session data received in LiveView:")
    IO.inspect(session, label: "Complete session")
    
    user_pubkey = session["user_pubkey"]
    IO.puts("User pubkey: #{inspect(user_pubkey)}")
    
    logged_in = user_pubkey != nil
    IO.puts("Logged in? #{logged_in}")

    socket =
      socket
      |> assign(:logged_in, logged_in)
      |> assign(:user_pubkey, user_pubkey)

    {:ok, socket}
  end
  
  # Handle logout event
  def handle_event("logout", _params, socket) do
    # Update the socket assignments for immediate UI feedback
    socket = 
      socket
      |> assign(:logged_in, false)
      |> assign(:user_pubkey, nil)
    
    # Send JS command to trigger nostr-login logout
    # The JS hook will handle the rest (including page navigation)
    {:noreply, push_event(socket, "nostr-logout", %{})}
  end
end
