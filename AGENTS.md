# Project

This repository contains ODT Portal, an organization service catalog built as a conventional Rails application.

- Use English for documentation, code comments, commit messages, and developer-facing text.
- Use Docker Compose as the primary development workflow. Run project commands in the `web` service unless a task specifically concerns the host or container setup.
- Start the application with `docker compose up --build`.
- Run one-off commands with `docker compose exec web <command>` when the stack is already running, or `docker compose run --rm web <command>` when it is not.
- Preserve the current stack: Ruby 4.0.4, Rails 8.1, PostgreSQL, Minitest and RSpec, Hotwire (Turbo and Stimulus), Importmap, Propshaft, Tailwind CSS through `tailwindcss-rails`, DaisyUI, Solid Cache, Solid Queue, Solid Cable, Active Storage with S3-compatible MinIO, and OmniAuth/OpenID Connect with Keycloak.
- Treat `Gemfile`, `Gemfile.lock`, `config/importmap.rb`, and the checked-in Docker files as the authoritative dependency and runtime definitions. Do not introduce a parallel toolchain without explicit approval.
- Prefer existing Rails generators, conventions, helpers, and framework capabilities over custom infrastructure.

# Instruction Priority

Follow instructions in this order, from highest to lowest priority:

1. System, platform, and safety instructions supplied to the agent.
2. The user's current request and explicit decisions.
3. The most specific `AGENTS.md` that applies to the file being changed; a nested file overrides this root file within its directory.
4. This root `AGENTS.md`.
5. Repository documentation and established local conventions.

- Never reinterpret a lower-priority instruction to bypass a higher-priority one.
- If instructions conflict or a requested change would violate a security, data-safety, or approval boundary, stop and ask for clarification before making that part of the change.
- Make small, task-focused changes. Do not broaden scope based on assumptions.
- Inspect relevant code and tests before editing. Prefer the repository's established patterns when they are consistent with these instructions.

# Testing

Use test-driven development for every behavior change and bug fix.

- Invoke the installed Matt Pocock TDD plugin or skill before beginning implementation work and follow its workflow on every implementation task.
- Verify that the plugin was actually available and invoked. Never claim to have used it when it was unavailable.
- If the Matt Pocock TDD plugin is unavailable, tell the user before implementation. Continue with a manual Red-Green-Refactor workflow only after the user explicitly approves the fallback.
- Red: add or update a focused test that describes the requested behavior and confirm that it fails for the expected reason.
- Green: make the smallest change that passes the test.
- Refactor: improve the implementation while keeping the relevant tests green.
- Use RSpec for new unit tests. Follow conventional `spec/` locations, use descriptive examples, and test observable behavior rather than private implementation details.
- Maintain existing Minitest coverage and helpers; migrate tests only when a task requires it rather than duplicating coverage across frameworks.
- Put tests in the layer that owns the behavior; prefer model/unit, request/controller, integration, and system tests as appropriate. Do not duplicate the same coverage in both frameworks without a clear reason.
- Every bug fix must include a regression test when the behavior can reasonably be tested.
- Run directly affected tests first. Use `docker compose exec web bundle exec rspec spec/path/to/example_spec.rb` for RSpec tests and `docker compose exec web bin/rails test test/models/service_test.rb` for existing Minitest tests.
- Run `docker compose exec web bin/rubocop` for Ruby changes.
- Run `docker compose exec web bin/ci` for broad, cross-cutting, security-sensitive, or release-oriented changes when practical.
- Do not change assertions, weaken coverage, skip tests, or alter production behavior merely to make a test pass.
- If a required check cannot run, report the exact command, reason, and remaining uncertainty.

# Rails Architecture

Follow the Rails Way and favor DHH-style, convention-driven design.

- Model the application around resources and domain concepts. Use standard Rails and Active Record conventions before introducing custom abstractions.
- Keep controllers resourceful, small, and focused on HTTP concerns: loading records, authorization, invoking domain behavior, and selecting the response.
- Put cohesive business rules close to the Active Record models that own the data. Extract plain Ruby objects only when they represent a meaningful domain concept or substantially improve clarity.
- Avoid generic service-object layers, command buses, repositories over Active Record, and speculative abstractions.
- Prefer RESTful routes and the seven conventional actions. Introduce a new resource or nested resource instead of accumulating custom member or collection actions when that produces a clearer domain model.
- Use strong parameters and standard Rails rendering, redirect, validation, callback, job, mailer, and caching facilities.
- Keep methods focused and names domain-oriented. Prefer readable duplication over a premature abstraction, but remove duplication once a stable concept is evident.
- Prevent N+1 queries and avoid loading unbounded record sets. Use Active Record scopes and eager loading where appropriate.
- Keep framework-generated files and established directory conventions intact unless the task clearly requires a change.

# Database

- Obtain explicit user approval before creating a migration, changing a migration, or changing the database schema.
- Never edit `db/schema.rb` by hand. Update it only by running approved Rails migrations.
- Create reversible migrations. Use `change` when Rails can reverse the operation; otherwise provide correct `up` and `down` methods.
- Use backward-compatible, expand-and-contract changes for removing or renaming tables, columns, indexes, and constraints.
- Do not combine destructive schema changes with application code that still depends on the old schema.
- Avoid long table locks and unsafe full-table rewrites. For large or production-sensitive changes, explain rollout and rollback risks before proceeding.
- Add database constraints and indexes when they enforce real invariants or support demonstrated query patterns; keep matching model validations where they improve user feedback.
- Do not place production data fixes in schema migrations. Use an explicit, reviewable data-migration or maintenance strategy.
- Never run destructive database commands or production migrations without explicit authorization.

# Hotwire and Frontend

- Use Turbo for navigation, form submissions, frames, and stream updates.
- Use Stimulus for small, reusable client-side behaviors that cannot be expressed cleanly with HTML, CSS, or Turbo.
- Preserve Importmap. Do not introduce Node.js, a JavaScript bundler, or a frontend framework without explicit approval.
- Keep Stimulus controllers small and declarative. Use targets, values, classes, and actions instead of querying unrelated DOM globally.
- Do not use inline JavaScript or inline event handlers.
- Keep ERB focused on presentation. Extract repeated markup into partials and presentation logic into helpers; do not place substantial business logic or complex queries in views.
- Preserve progressive enhancement: core navigation and form behavior should remain usable without custom JavaScript whenever practical.
- Handle Turbo lifecycle and frame behavior explicitly when adding interactive UI; do not assume full-page loads.

# UI and Accessibility

- Use Tailwind CSS utilities and the project's existing visual language.
- DaisyUI is the component layer. Prefer its semantic component classes and theme tokens, supplemented by Tailwind utilities, instead of recreating equivalent components ad hoc.
- Preserve established layouts and interaction patterns unless the task explicitly asks for redesign.
- Use semantic HTML first. Use native buttons, links, labels, headings, dialogs, and form controls for their intended purposes.
- Ensure all functionality is keyboard accessible and has visible focus states.
- Give form controls accessible names, associate errors and help text correctly, and provide useful alternative text for meaningful images. Mark decorative images and icons appropriately.
- Do not rely on color alone to convey state. Maintain readable contrast, adequate target sizes, and clear hover, focus, disabled, loading, empty, and error states.
- Support responsive layouts at mobile and desktop sizes. Avoid fixed dimensions that cause clipping or horizontal scrolling.
- Use ARIA only when native HTML cannot express the required semantics, and keep ARIA state synchronized with the UI.

# Security

- Do not expose or log secrets, credentials, tokens, or sensitive personal data.
- Preserve authentication and authorization checks.
- Add authorization coverage for new endpoints or actions.
- Treat all user input as untrusted.
- Use strong parameters and allow-list accepted attributes.
- Do not construct SQL, shell commands, paths, redirects, or URLs using unchecked interpolated input.
- Use parameterized Active Record queries and Rails escaping defaults.
- Avoid `html_safe`, `raw`, and equivalent bypasses unless the content is demonstrably trusted and the reason is documented.
- Validate uploaded files, external URLs, and redirect destinations appropriate to their use and threat model.
- Avoid leaking record existence or sensitive details through differing authorization errors.
- Keep sensitive values in environment variables or Rails credentials, and preserve parameter filtering.
- Do not weaken authentication, authorization, CSRF, CSP, session, cookie, validation, or transport-security controls to make tests pass.
- Treat changes involving Keycloak claims, client roles, login/logout flows, admin access, MinIO credentials, CSP, or session handling as security-sensitive and run focused security and authorization tests.

# Dependencies and Git

- Do not add, remove, or upgrade dependencies unless required by the task.
- Before adding a dependency:
  1. Confirm the existing stack cannot reasonably solve the problem.
  2. Explain why it is required and obtain explicit user approval.
  3. Update the appropriate manifest and lockfile together.
  4. Add or update relevant tests.
- Prefer narrowly scoped, maintained dependencies compatible with the existing runtime and license expectations.
- Preserve user changes and uncommitted work.
- Review `git status` and relevant diffs before editing and before completion.
- Do not create commits, branches, tags, or pull requests unless explicitly requested.
- Do not run destructive Git commands, including `git reset --hard`, `git clean -fd`, and `git checkout -- .`.
- Do not revert, overwrite, stage, or reformat unrelated changes.
- Do not modify generated or vendored files unless the task requires it and the corresponding source or generation workflow is also handled.

# Completion

Before declaring work complete:

- Ensure the requested behavior is implemented and acceptance criteria are satisfied.
- Confirm the TDD cycle was followed for behavior changes, including a regression test for bug fixes when feasible.
- Run directly affected tests.
- Run relevant linting, formatting, security, and broader test checks in proportion to the change's risk.
- Review the final diff for correctness, security issues, accidental generated files, secrets, debug code, and unrelated changes.
- Update relevant documentation when commands, configuration, environment variables, behavior, or operational procedures change.
- Do not claim checks passed unless they were actually run and completed successfully.
- Report what changed, which checks were run and their results, and any checks not run or remaining risks.