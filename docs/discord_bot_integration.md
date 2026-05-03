# Discord Music Bot Integration Architecture

> **Status**: Design Document — Not yet implemented  
> **Last Updated**: 2026-05-03

---

## 1. Context

The existing **Hyfata Music Bot** is built in **Java** using the **JDA (Java Discord API)** library. It currently runs as a standalone bot inside Discord servers (guilds), playing music in voice channels.

The Flutter app should act as a **remote control** for this bot, allowing users to:
- View the current queue and now-playing track.
- Play / pause / skip.
- Add songs to the queue.
- Select which Discord server (guild) to control.
- Invite friends to a synchronized "listen together" session.

---

## 2. High-Level Architecture

Because the bot is already written in Java/JDA, the cleanest approach is to expose a **small gateway/bridge** (either inside the bot or as a sidecar service) that speaks a protocol the Flutter app can consume.

```
┌─────────────────┐         WebSocket / REST          ┌─────────────────────────────┐
│  Flutter App    │  <────────────────────────────->  │  Hyfata Bot Gateway         │
│  (Dart)         │      JSON commands & events       │  (Java / Kotlin / Netty)    │
└─────────────────┘                                   └─────────────────────────────┘
         │                                                        │
         │                                                        │
   ┌─────┴─────┐                                           ┌─────┴─────┐
   │  Hyfata   │                                           │    JDA    │
   │  Auth     │                                           │  (Java)   │
   │  Server   │                                           │           │
   └───────────┘                                           └───────────┘
```

### 2.1 Why WebSocket?
- **Bidirectional**: The bot must push events (track started, queue updated, player state changed) to the app without polling.
- **Low latency**: Playback controls should feel instant.
- **Simple contract**: A single persistent connection per user is easier to reason about than hundreds of REST polling loops.

### 2.2 Alternative: REST-only
If adding a WebSocket server to the Java bot is too heavy, a **REST API + Server-Sent Events (SSE)** or **long-polling** fallback could work. However, for a music remote control, WebSocket is strongly recommended.

---

## 3. Authentication Flow

The Flutter app already authenticates with the **Hyfata OAuth2** server. The bot gateway should **verify the same access token** rather than introducing a second auth scheme.

```
1. User logs into Flutter app via Hyfata OAuth.
2. App receives access_token (JWT or opaque).
3. App opens WebSocket to Bot Gateway, sending token in the handshake header.
4. Bot Gateway calls Hyfata Auth Server (token introspection endpoint) to verify.
5. On success, the connection is accepted and bound to the user's Discord ID.
```

**Benefits**:
- Single sign-on experience.
- The bot already knows the user's Discord identity via Hyfata auth.
- No extra passwords or API keys to manage.

---

## 4. Gateway Protocol

### 4.1 Connection Details
- **Transport**: WebSocket (`wss://bot.hyfata.example/v1/gateway`)
- **Heartbeat**: Client sends `PING` every 30s; server replies `PONG`. Missed 3 heartbeats = disconnect.
- **Reconnection**: Exponential backoff with jitter.

### 4.2 Command Schema (App → Bot)

All commands share a common envelope:

```json
{
  "op": "COMMAND_NAME",
  "guildId": "123456789012345678",
  "requestId": "uuid-v4",
  "payload": { ... }
}
```

| Command (`op`) | Payload | Description |
|---|---|---|
| `PLAY` | `{ "query": "never gonna give you up" }` | Searches and queues the best match. |
| `PAUSE` | `{}` | Pauses playback. |
| `RESUME` | `{}` | Resumes playback. |
| `SKIP` | `{}` | Skips current track. |
| `PREVIOUS` | `{}` | Goes back one track. |
| `SEEK` | `{ "positionMs": 120000 }` | Seeks to position in milliseconds. |
| `STOP` | `{}` | Stops and clears queue. |
| `QUEUE_ADD` | `{ "query": "track name or url" }` | Adds to end of queue without interrupting. |
| `QUEUE_REMOVE` | `{ "index": 3 }` | Removes track at queue index. |
| `QUEUE_SHUFFLE` | `{}` | Shuffles remaining queue. |
| `SET_VOLUME` | `{ "volume": 80 }` | Sets player volume 0–100. |
| `GET_STATE` | `{}` | Requests a full state dump. |

### 4.3 Event Schema (Bot → App)

```json
{
  "op": "EVENT_NAME",
  "guildId": "123456789012345678",
  "payload": { ... }
}
```

| Event (`op`) | Payload | Description |
|---|---|---|
| `READY` | `{ "userId": "...", "guilds": [...] }` | Sent on successful connection. Lists guilds the user can control. |
| `NOW_PLAYING` | `{ "track": { "title", "artist", "durationMs", "positionMs" } }` | Emitted when a new track starts. |
| `PLAYER_STATE` | `{ "isPlaying": true, "positionMs": 45000, "volume": 75 }` | Periodic state update (every 5s or on change). |
| `QUEUE_UPDATE` | `{ "tracks": [...], "currentIndex": 2 }` | Full queue snapshot. |
| `TRACK_ADDED` | `{ "track": {...}, "index": 5 }` | Confirmation that a track was added. |
| `TRACK_ENDED` | `{ "track": {...} }` | Fired when a track finishes naturally. |
| `ERROR` | `{ "message": "Voice channel not joined" }` | Human-readable error from the bot. |

---

## 5. Java Bot Changes Required

### 5.1 Gateway Server Module
A new module (e.g., `bot-gateway`) should be added to the Java project:
- Uses **Netty** or an embedded **Spring WebFlux** server for WebSocket.
- Maintains a map of `userId -> WebSocketSession`.
- Listens to JDA audio events and forwards them to the connected session.

### 5.2 Auth Introspection
Implement a lightweight client to the Hyfata OAuth introspection endpoint:
```java
POST /oauth/introspect
Authorization: Basic <bot-client-credentials>
Body: token=<user-access-token>

Response: { "active": true, "sub": "discord-user-id", ... }
```

### 5.3 Command Dispatcher
Inside the bot, map incoming WebSocket commands to existing JDA audio commands:
```java
public class AudioCommandDispatcher {
    public void handle(Guild guild, User user, PlayCommand cmd) {
        AudioManager manager = guild.getAudioManager();
        // Reuse existing youtube-dlp / search logic
        // Queue track via existing scheduler
    }
}
```

### 5.4 Guild Selector
Because a user may be in multiple servers with the bot, the Flutter app must present a **Guild Selector** before sending commands. The `READY` event provides the list.

---

## 6. Flutter App Architecture

### 6.1 New Components

| Component | Responsibility |
|---|---|
| `BotGatewayService` | Manages WebSocket connection, heartbeat, reconnection, serialization. |
| `BotCommandRepository` | Sends typed commands, awaits acks (optional). |
| `BotStateNotifier` | Riverpod `AsyncNotifier` exposing `BotPlayerState` to UI. |
| `GuildSelectorPage` | UI to pick which Discord guild to control. |
| `RemotePlayerBar` | Optional overlay showing "Controlling [Server Name]" + basic controls. |

### 6.2 State Shape
```dart
class BotPlayerState {
  final String? selectedGuildId;
  final TrackEntity? currentTrack;
  final bool isPlaying;
  final Duration position;
  final List<TrackEntity> queue;
  final String? errorMessage;
}
```

### 6.3 UI Flow
1. User taps "Discord Bot" in settings or nav.
2. App connects to `BotGatewayService` using stored Hyfata token.
3. `READY` event arrives → show `GuildSelectorPage`.
4. User picks a guild → `BotStateNotifier` starts listening to events for that guild.
5. A floating remote-control panel appears, mirroring the local player UI but sending commands via WebSocket.

---

## 7. Listen-Together Invites

The "invite friends to listen" feature mentioned in the main app plan can leverage the same gateway:

1. User creates a **room** via the bot (`CREATE_ROOM` command).
2. Bot returns a short code (e.g., `HYF-AB12`).
3. User shares the code via Discord message (using Discord's share sheet or a simple text paste).
4. Friends open the link `hyfata://listen-together?room=HYF-AB12`.
5. App joins the same WebSocket room and receives synchronized playback commands from the host.

This makes the bot the **single source of truth** for playback timing, ensuring everyone hears the same thing at the same time.

---

## 8. Security Considerations

- **TLS everywhere**: WebSocket must use `wss://`.
- **Token validation**: Never trust the client; always introspect the OAuth token on the Java side.
- **Rate limiting**: Prevent abuse by limiting commands per user per second (e.g., 5 commands/sec).
- **Guild permissions**: Verify the user has appropriate voice/music permissions in the target guild before executing commands.

---

## 9. Implementation Phases

| Phase | Work |
|---|---|
| 1 | Add WebSocket gateway module to Java bot (auth + heartbeat). |
| 2 | Implement `PLAY`, `PAUSE`, `SKIP`, `GET_STATE` commands and `NOW_PLAYING`, `PLAYER_STATE` events. |
| 3 | Build Flutter `BotGatewayService` + `BotStateNotifier` + Guild Selector UI. |
| 4 | Add queue management commands (`QUEUE_ADD`, `QUEUE_REMOVE`, `QUEUE_SHUFFLE`). |
| 5 | Implement listen-together room logic. |

---

## 10. Open Questions

1. Should the gateway run **inside the same JVM** as the JDA bot, or as a **separate microservice**?
   - *Inside*: Easier shared state, but scales with the bot process.
   - *Separate*: Better isolation, requires Redis or similar for state sharing.
2. Should we support **guild-specific API keys** for server admins who want to restrict remote control?
3. Do we need a **fallback REST API** for environments where WebSocket is blocked (corporate firewalls)?
