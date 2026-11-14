# Vision

Olive CSS is a utility-class framework whose generator is a Guile program: you
put Tailwind's class names in your HTML, the framework emits plain CSS, and every
family, scale, variant and colour in between is Lisp you can read and change. Its
direction is to stay the framework whose *whole* behaviour is a parameterised
program — no config file, no npm, no runtime — while closing the utility-parity
gap that currently stops a Tailwind user from switching, and to make the argument
it already bets on properly: generate everything, prune what a site uses, and the
result is as small as on-demand generation without ever parsing a template.

## Where olive-css is today

About 5,800 lines of Guile in `src/olive-css/`: `main.scm` (664) is the generator
and its parameters, `dsl.scm` (387) the CSS AST, palette arithmetic in OKLCH and
the minifier, `tree-shaking.scm` (373) the pruner, `cli.scm` (284) the command line,
`builds.scm` (233) the registry of shipped stylesheets, `sizes.scm` (145) the
t-shirt, numeric, fraction, tracking and alpha vocabularies, and `decl/` — nineteen
modules, 3,670 lines, one per utility family from `layout.scm` through
`masks.scm`. Four Veritas unit files with 42 `test` forms. MIT throughout: the
code, the generated CSS and the documentation alike.

The generating half is nine parameters, and they are the API. `(olive-css-gen)`
appends the reset, the core utilities, the palette utilities, animations, the state
variants, the colour rules, the optional `data-theme="dark"` layer and the
responsive block; `write-css-to-file` minifies it unless `minified?` is `#f`. A
build is a `parameterize` around one call, which is why `builds.scm` is a list of
palettes and feature sets rather than a config format, and why the repository's own
nine stylesheets — LucidPlan, Iter Vitae, Byggsteg, WikiMusic, rc-huidkliniek and
four others — live in `resources/css/` as the regression corpus and the artefacts
at once.

The pruning half is the other product. The tree-shaker imports only
`(olive-css license)`, so pruning never loads the generator; it walks a built site
for the file suffixes a build names, reads the class names its `scan-mode`
understands (`class` attributes, alternatively SXML `(class "...")` attributes, or
nothing at all when the build declares its classes), escapes the names the way CSS
escapes them (`hover:bg-x` becomes `hover\:bg-x`), de-duplicates, then parses the
stylesheet into *nested blocks* rather than matching lines, so a rule inside
`@media`, `@container`, `@supports`, `@layer` or the dark-mode block is understood
as nested. A 9.1 MB build becomes about 7 KB for the sample page.

`docs/comparison.org` measures the utility surface honestly: ~95% parity with
Tailwind v4's families, with the weakest category named rather than hidden —
variants at ~90%, where what is left is arbitrary values and stacked
combinations rather than whole families; effects and SVG at ~90%, for want of
mask colour stops and `stroke-dasharray`; and arbitrary values
(`w-[13px]`, `content-['x']`) everywhere, which a static generator cannot
enumerate and therefore cannot prune.

## The vision

1. **A Tailwind user can switch without rewriting a page.** The named gaps —
   `group`/`peer`/`has`, `aria-*` and `data-*`, container queries, 3D
   transforms, gradient and shadow colour stops — have landed, which is the
   difference between "it looks right in a demo" and a framework someone can
   adopt for a real site. What remains is the arbitrary-value escape hatch and
   stacking, both of which are design decisions rather than missing families.
2. **The generator never has to understand your templates.** On-demand
   generation needs a parser for your HTML, or your JSX, or your Phoenix
   templates. Generating everything and pruning the built output needs only the
   output. The direction is to make that trade a documented position with
   measurements behind it, because it is the reason this framework works with
   every template language at once.
3. **A stylesheet can be split and layered.** Cascade layers would let a site apply
   Olive CSS *under* its own CSS without specificity fights. The tree-shaker already
   parses `@layer` blocks; the generator would have to emit them with a name.
4. **The framework checks your markup, not only your CSS.** The pruner already
   scans a site and knows every selector it kept. The same pass can report a class
   the stylesheet has no rule for — a typo that today ships unstyled.
5. **A build is a value you can measure.** Every build has a size, a rule count and
   a cost in bytes per family, and today nothing reports any of them. A release that
   changes the minifier or the scales should say what it did to 9.1 MB.

## Features that are in scope and not built yet

- **Mask colour stops and custom mask images.** The last named family Tailwind
  has and this generator does not: the masks module draws black-to-transparent
  gradients, so a coloured stop or an image URL means custom CSS.
- **`stroke-dasharray` and friends** in `decl/svg.scm`.
- **Arbitrary values** (`w-[13px]`, `content-['x']`, `[&>svg]`): one small,
  explicit, recognised shape, because a class the generator cannot enumerate
  cannot be pruned.
- **Stacked variants** (`md:group-hover:bg-x`, `print:hover:bg-x`). The
  selector, at-rule and state layers are generated independently, so a
  combination needs an explicit entry in a build. Combining two layers costs
  their product in bytes, so the decision is about which combinations to
  afford, not about whether the machinery allows it.


## New features that would be worth having

- **`olive-css check`**, reporting every class in a built site that the stylesheet
  has no rule for. Speculative in that no code anticipates it, and the tree-shaker
  already does the scan, the escaping and the selector parsing — so it is a
  reporting mode, not a second implementation.
- **`olive-css size`**, printing each build's byte count and rule count, so a
  palette change's cost is a number in a review rather than a surprise in
  production — and CI can hold a budget against it.
- **Cascade-layer output**, a parameter wrapping the families in
  `@layer reset, base, components, utilities;` so a site's own CSS wins without
  `!important`. The pruner already preserves `@layer` blocks, so the halves agree
  by construction.
- **CSS custom properties as a build mode**: emit `--olive-blue-500` once in
  `:root` and reference it, so a theme swaps at runtime without regenerating.
  Speculative, and it costs bytes in a build that does not need it — hence opt-in.
- **An arbitrary-value escape hatch**, documented as a compromise: a class the
  generator cannot enumerate cannot be pruned, so if it exists it should be one
  small, explicit, recognised shape — `p-[13px]` — not a general CSS parser.

## Contributions that would move the needle

1. **`olive-css check`.** Built on the pruner's existing scan, it turns a silent
   class of bug — a typo that ships unstyled — into a non-zero exit, and it is what
   a user wants the first time they misspell `md:flex`.
2. **`olive-css size`, and a byte budget in the CI task.** It puts the minifier's
   own trade-offs — the changelog already discusses giving up `;}` for a 100×
   slowdown in tree-shaking — under a number rather than under memory. The
   complete build grew by four megabytes in one pass; a per-family byte report
   would have said so per family.
3. **Mask colour stops and custom mask images.** The last named family Tailwind
   has and `decl/masks.scm` does not.
4. **An arbitrary-value shape**, small and explicit enough that the pruner can
   keep it: `p-[13px]` and `content-['x']`, not a general CSS parser.
5. **Stacked variants**, generated per requested pair (`md:group-hover:`) rather
   than as a cross-product, so the byte cost stays proportional to what a site
   asked for.

## Compared to related projects

| Project | What it is | Where Olive CSS differs |
| --- | --- | --- |
| Tailwind CSS | The reference utility framework: class names compiled on demand by a JavaScript engine that scans your source files, CSS-first configuration in v4, arbitrary values, cascade layers, and a broad variant set including `group`, `peer`, `has` and container queries. | The syntax is borrowed; the engine is not. Tailwind is JavaScript and needs Node; Olive CSS is Guile, emits one `.css` file, and is configured by `parameterize` rather than by a config file — which makes a build a program, at the cost of Tailwind's on-demand generation and its arbitrary values. |
| UnoCSS | An atomic CSS engine that generates utilities on demand from presets, with attributify mode, an inspector and a much faster engine than Tailwind's. | UnoCSS's whole thesis is speed of generation and the preset ecosystem; Olive CSS's thesis is that the generator is a program you can rewrite. UnoCSS's inspector is the closest thing to `olive-css check` listed here, and would be the model for it. |
| Tachyons | The original functional CSS: a fixed, hand-written scale of atomic classes, no build step and no configuration. | Tachyons proves the atomic model without a compiler. Olive CSS keeps that spirit — the output is plain CSS you own — but generates the scale from `sizes.scm` and the palettes, so a colour or step is a value rather than a file to edit by hand. |
| Bootstrap | The component framework: a grid, components, Sass sources and a JavaScript layer. | A different product, and a useful contrast: Bootstrap styles components from the framework's design, Olive CSS styles from utility names chosen in your HTML. Nothing in Olive CSS is a component, and nothing in Bootstrap is a family you can parameterise in a host language. |
| Pico CSS | Minimal, classless and semi-classless CSS: semantic HTML styled sensibly, with variables for theming. | Pico asks you to write no classes at all; Olive CSS asks for Tailwind's. Both reject a build toolchain, and Pico's `:root` variable layer is the shape a custom-properties build mode here would take. |
| Open Props | A set of CSS custom-property design tokens — colours, easings, sizes — with no classes and no generator. | Open Props's insight is that variables are the portable layer; Olive CSS emits literal declarations today and would gain from that layer as an opt-in mode. Against Open Props, Olive CSS has the classes and the tree-shaker. |
| Garden (Clojure) | A Clojure library for writing CSS as data — selectors and declarations as vectors and maps, composed with functions and emitted to a stylesheet. | The nearest cousin in language and instincts: both trade a config file for a host-language DSL. Garden composes hand-written CSS; Olive CSS *generates a whole framework* and then prunes it, which is why it needs an AST, a palette arithmetic in OKLCH and a pruner, and Garden needs none of them. |

What the others do that Olive CSS could still add: Tailwind's on-demand generation
and arbitrary values cannot be copied without copying Node, which is why this
project's answer has to be the pruning half done well; UnoCSS's inspector is the
model for a `check` command; Pico's and Open Props's variable-first thinking is the
model for a custom-properties build mode; Tachyons' discipline about a fixed scale
is a reminder that `sizes.scm` is a *decision*, not an implementation detail.

Where Olive CSS is ahead and should stay ahead: the generator is a library, so a
project can call `olive-css-gen` from its own Scheme, change one family in ten lines
and keep the rest; the tree-shaker parses nested at-rule blocks and CSS escapes
rather than matching lines, so it works on a stylesheet no JIT emitted; nothing
needs a runtime — no npm, no watcher, no bundler — and the artefact is one `.css`
file a browser already understands; the framework is MIT with no paid tier; and the
build is reproducible through Guix, bit for bit, which no JavaScript generator in
this table can claim.

## In the long run

**Generate everything, prune what is used.** The architectural bet, to be defended
with numbers rather than claimed: a 9.1 MB build and a 7 KB output mean the
expensive work happens once per framework release and the cheap work once per
site. In exchange the framework never parses a template — it works with HTML, a
Sitebuilder output, whatever a project writes — and the generator stays a pure
function of its parameters. The three scanning modes are where that trade bends:
an application that builds class names at run time declares them
(`preserved-classes`, `preserved-patterns`) rather than making the pruner parse a
program.

**The scales are the API.** `sizes.scm` holds the t-shirt sizes, numeric steps,
fractions, container widths, trackings, alphas and colour weights, and every
`decl/` module reads them. Parity with Tailwind is a vocabulary question before
it is a code question: matching means matching the names and the steps, and the
framework's durability depends on those lists staying readable and documented as
the decisions they are.

**No toolchain is the moat.** The site that uses Olive CSS has no `node_modules`,
no lockfile to audit and no build step to keep working between other projects'
releases; it has a stylesheet and a command that regenerates it. Every year that
the JavaScript toolchain changes shape, that becomes a better argument — and it is
the one this project can make without competing on engine speed.

## Getting involved

`guix shell -m manifest.scm -- maak test` runs the Veritas suite and `maak build`
regenerates the nine stylesheets in `resources/css/`, which are the regression
corpus as much as the artefacts. A new utility family belongs in its own `decl/`
module with a test in `utilities.scm`; a new variant belongs in `main.scm`'s variant
parameters with a test that renders it. `docs/comparison.org` is where the parity
claim lives, and it should move when the code does.

*This document describes intent, not commitments: it names directions the project
would like to take, and no item in it is promised for any release.*
