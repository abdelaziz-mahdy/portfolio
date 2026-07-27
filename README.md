# portfolio

Personal portfolio for [abdelaziz-mahdy](https://github.com/abdelaziz-mahdy), built with
Flutter web and deployed to GitHub Pages at
<https://abdelaziz-mahdy.github.io/portfolio/>.

## Building for the web

```bash
flutter build web --release --base-href "/portfolio/"
```

**`--base-href` is not optional.** The site is served from a subpath
(`abdelaziz-mahdy.github.io/**portfolio/**`), not from a domain root. Without the flag
Flutter writes `<base href="/">` and every asset request — `main.dart.js`,
`assets/user_info.json`, the fonts, the CanvasKit payload — resolves against
`abdelaziz-mahdy.github.io/` and 404s. The page loads to a blank screen with no
obvious error. The value must start and end with a slash.

`.github/workflows/deploy.yml` runs exactly this command on every push to `main`,
so local builds and CI builds should match. Output lands in `build/web/`.

To preview a release build locally, serve it from a directory where it sits under a
`portfolio/` path, so the base href resolves the same way it does in production:

```bash
mkdir -p /tmp/serve && ln -sfn "$PWD/build/web" /tmp/serve/portfolio && (cd /tmp/serve && python3 -m http.server 8000)
```

Then open <http://localhost:8000/portfolio/>. Opening `build/web/index.html` directly,
or serving `build/web` at a root, will not work — same base-href reason.

## Developing

```bash
flutter run -d chrome
```

Hot reload with `r`, hot restart with `R`. No `--base-href` is needed here: the dev
server serves from the root.

## Checks

```bash
flutter analyze && flutter test
```

## Updating your CV content — no code, no rebuild

Everything a reader sees about you — name, tagline, location, summary, skills,
experience, education, publications, certificates, awards, courses — lives in
[`assets/profile.json`](assets/profile.json), not in Dart.

The app fetches that file from `raw.githubusercontent.com` at runtime, so:

```bash
# edit assets/profile.json, then
git commit -am "Update CV content" && git push
```

The live site picks it up on the next load. No `flutter build`, no deploy, no
Dart. The copy bundled as an asset is only the offline fallback.

Adding a job means appending an object to `experience`. Removing a whole
section means emptying its array — the card disappears rather than rendering an
empty box. Every optional field accepts `null`.

### What must not go in it

`assets/profile.json` is committed to a public repository and served from a CDN. Keep
out phone numbers, home address, and anything about other people — a CV's
referees are the usual trap, since their emails and phone numbers are not yours
to publish. `test/profile_test.dart` fails the build if a phone number, a
references section, or a second email address appears in the file.

Employer detail deserves the same care: describe your role and the general
domain, not internal architecture, client characteristics, or unreleased
product specifics. A CV you hand to a recruiter and a page anyone can scrape
are not the same audience.

## Where the GitHub data comes from

The app does **not** call `api.github.com` at runtime. Browser calls are
unauthenticated, so every visitor shares a 60 requests/hour budget per IP and the
page rate-limits itself after a few reloads.

Instead, `python/github_user_info.py` runs in CI with a token (5000 requests/hour)
and writes `assets/user_info.json`. The app reads that file:

1. from `raw.githubusercontent.com` at runtime — CDN-served, no rate limit, and
   refreshed by CI without redeploying the site;
2. falling back to the copy bundled as a Flutter asset when the network copy is
   unreachable.

`.github/workflows/get_user_info.yml` regenerates the dataset on every push to
`main`, daily at 03:00 UTC, and on manual dispatch.

### Only public data is ever written

The generator asks for `privacy: PUBLIC` repositories, skips pull requests whose
base repository is private, and drops anything still marked private before
serialising. `user_info.json` is committed to a public repository, so a token
carrying the `repo` scope must never be able to leak private repository names
through it. If you change the GraphQL queries, keep all three guards.

To run the generator locally:

```bash
GITHUB_TOKEN="$(gh auth token)" GITHUB_REPOSITORY="abdelaziz-mahdy/portfolio" python3 python/github_user_info.py
```

It writes `assets/user_info.json`, plus `contributed_repos.json` and `CONTRIBUTED_REPOS.md`, relative to
the working directory.

## Layout

| Path | What lives there |
| --- | --- |
| `assets/profile.json` | All CV content — edit this, not Dart |
| `assets/user_info.json` | CI-generated GitHub dataset — never edit by hand |
| `lib/constants/constants.dart` | Wiring only: which repo, branch and JSON paths |
| `lib/constants/view/` | Biography cards, rendering `profile.json` |
| `lib/profile/models/` | `profile.json` parsing |
| `lib/github/models/` | `user_info.json` parsing |
| `lib/github/data/` | Remote fetch with bundled-asset fallback, for both documents |
| `lib/github/controller/` | The single owner of both loaded documents |
| `lib/github/view/` | Contribution and project sections |
| `lib/theme/` | Colour tokens, text theme, and the theme-mode controller |
| `lib/layout/breakpoints.dart` | Window size classes and width-derived layout metrics |
| `lib/widgets/linked_text.dart` | Renders inline `[label](url)` links from JSON content |
| `python/` | The CI data generator |

Colours for pull request states and the star glyph come from the `PortfolioPalette`
theme extension, not from `Colors.*` constants — hard-coded values cannot flip with
the theme, and the pairings there are chosen to clear WCAG AA contrast in both
modes.
