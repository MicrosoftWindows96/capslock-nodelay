# capslock-nodelay

Remove the macOS Caps Lock activation delay. Persists across reboots. No app, no Gatekeeper.

A `LaunchAgent` that runs `hidutil property --set '{"CapsLockDelayOverride":0}'` at login.

## Install

```bash
./install.sh
```

Applies immediately, no logout needed.

## Uninstall

```bash
launchctl bootout gui/$(id -u)/com.user.capslocknodelay
rm ~/Library/LaunchAgents/com.user.capslocknodelay.plist
hidutil property --set '{"CapsLockDelayOverride":-1}'
```

## One-shot (no install)

```bash
hidutil property --set '{"CapsLockDelayOverride":0}'
```

Resets on reboot.

## License

MIT
