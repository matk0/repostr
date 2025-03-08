export function initNostrLogin() {
  document.addEventListener('DOMContentLoaded', () => {
    const loginButton = document.getElementById('nostr-login-button');
    if (!loginButton) return;

    loginButton.addEventListener('click', async () => {
      document.dispatchEvent(
        new CustomEvent('nlLaunch', { detail: 'welcome' }),
      );
    });
  });
}
