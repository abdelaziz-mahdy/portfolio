# Working in this repo

## Building for web always needs `--base-href`

```bash
flutter build web --release --base-href "/portfolio/"
```

The site is served from `abdelaziz-mahdy.github.io/portfolio/`, a subpath. Without the
flag Flutter emits `<base href="/">`, every asset resolves against the domain root,
and the deployed page is blank with no useful error. `deploy.yml` uses this exact
command — keep local builds identical so a break shows up before CI.

Serving a release build locally requires the same subpath, so symlink `build/web` to a
`portfolio/` directory and serve the parent. Serving `build/web` at a root will not
work.

## CV content belongs in `assets/profile.json`, never in Dart

Name, tagline, location, summary, skills, experience, education, publications,
certificates, awards and courses are all in `assets/profile.json`, fetched from the CDN
at runtime. Editing that file and pushing updates the live site with no rebuild.

Do not move any of it back into `constants.dart` — that file holds wiring only
(which repo, which branch, which JSON). Adding a content field means extending
`Profile.fromJson`, not adding a constant.

## Never publish private data through `assets/profile.json`

It is committed to a public repository and served from a CDN. No phone numbers,
no home address, and nothing belonging to other people — a CV's referees are the
usual trap, since their contact details are not the author's to publish.
`test/profile_test.dart` enforces this and runs in CI.

Employer detail needs judgement the tests cannot apply: describe the role and
the general domain, not internal architecture, client characteristics, or
unreleased specifics. When copying from a CV, assume every bullet needs
rewriting for a public audience rather than assuming it is safe.

## Never write private GitHub data into `assets/user_info.json`

`assets/user_info.json` is committed to a public repository. `python/github_user_info.py` has
three independent guards: `privacy: PUBLIC` on the repository queries, a skip for pull
requests against private base repositories, and a final `isPrivate` filter before
serialising. A token with the `repo` scope will happily return private repositories, so
removing any guard leaks them. Keep all three.

## Colours and type come from the theme, never from constants

Pull request state colours and the star glyph live in `PortfolioPalette`
(`lib/theme/portfolio_palette.dart`), a `ThemeExtension`. Text styles come from
`Theme.of(context).textTheme`.

This is not stylistic. A hard-coded `Colors.yellow` star measured 1.22:1 against a
light card while passing at 13.65:1 in dark, and white on GitHub's brand green
(`#2CBE4E`) measured 2.45:1. The values in the palette are chosen to clear 4.5:1 in
both modes; if you add a state colour, check the ratio before committing it.

## Layout responds to constraints, not to a boolean

Use `LayoutMetrics.of(constraints.maxWidth)` from `lib/layout/breakpoints.dart` inside a
`LayoutBuilder`, and derive grid columns with `columnsFor(...)`.

The previous code used a single `width < 600` boolean and hard-coded
`crossAxisCount: 2` with `SizedBox(width: 400)` children, which put 800px of cards into
a 355px column on every phone. Do not reintroduce a fixed card width or column count.

## GraphQL errors arrive as HTTP 200

GitHub returns query failures with a 200 status and an `errors` array. `run_query` in
the generator raises on that array; do not weaken it to a status-code check, and do not
wrap the entrypoint in a bare `except` — a silent failure lets CI commit stale data
over a broken run.
