export function initNostrLogin() {
  // Variable to track if we've already handled authentication
  // Check session storage to see if we've already logged in to prevent infinite loops
  let authHandled = sessionStorage.getItem('nostrAuthHandled') === 'true';

  document.addEventListener('DOMContentLoaded', () => {
    const loginButton = document.getElementById('nostr-login-button');
    if (!loginButton) return;

    loginButton.addEventListener('click', async () => {
      document.dispatchEvent(
        new CustomEvent('nlLaunch', { detail: 'welcome' }),
      );
    });
  });

  // Listen for direct logout event from LiveView or other sources
  document.addEventListener('nlLogout', () => {
    console.log('Received direct nlLogout event');
    sessionStorage.removeItem('nostrAuthHandled');
    // Dispatch this to nostr-login as well
    document.dispatchEvent(
      new CustomEvent('nlAuth', { detail: { type: 'logout' } })
    );
  });

  document.addEventListener('nlAuth', async (e) => {
    // Prevent handling the same auth event multiple times
    if (authHandled) {
      console.log('Auth already handled, skipping');
      return;
    }

    // Handle login or signup events
    if (e.detail.type === 'login' || e.detail.type === 'signup') {
      try {
        // Set flag to prevent multiple auth attempts
        authHandled = true;

        // Get the public key from the window.nostr
        const pubkey = await window.nostr.getPublicKey();
        console.log('Authenticated with pubkey:', pubkey);

        // Send the pubkey to the server to create a session
        const response = await fetch('/api/v1/nostr/auth', {
          method: 'POST',
          credentials: 'same-origin', // Important: Include cookies with the request
          headers: {
            'Content-Type': 'application/json',
            'X-CSRF-Token': document
              .querySelector("meta[name='csrf-token']")
              .getAttribute('content'),
          },
          body: JSON.stringify({
            event: {
              pubkey: pubkey,
              // Include minimal required fields to pass validation
              id: 'auth',
              sig: 'auth',
              kind: 27235,
              created_at: Math.floor(Date.now() / 1000),
              content: 'Login to Repostr',
              tags: [['domain', window.location.host]],
            },
          }),
        });

        if (response.ok) {
          // Authentication successful - store in session storage and reload
          sessionStorage.setItem('nostrAuthHandled', 'true');

          window.location.reload();
        } else {
          console.log(response);
          console.error('Server rejected authentication');
          alert('Authentication failed. Please try again.');
          // Reset flag so user can try again
          authHandled = false;
        }
      } catch (error) {
        console.error('Error during authentication:', error);
        alert('Authentication error: ' + error.message);
        // Reset flag so user can try again
        authHandled = false;
      }
    } else if (e.detail.type === 'logout') {
      // Clear auth state when logout event is received from nostr-login
      sessionStorage.removeItem('nostrAuthHandled');
      // Client-side navigation is handled in the LiveView hook
    }
  });
}
