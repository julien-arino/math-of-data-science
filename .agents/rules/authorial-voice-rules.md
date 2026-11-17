---
trigger: always_on
description: "Authorial voice, prose style, lexical constraints and spelling rules across all written documents"
---

# Authorial voice and writing style

Apply these rules whenever drafting, editing or reviewing prose across LaTeX manuscripts, lecture notes, slides, Rnw/Quarto/Markdown documents and reports.

## Lexical and rhetorical prohibitions

- **Banned buzzwords**: Avoid inflated academic jargon and cryptic terminology. Never use:
  - *Verbs*: delve, underscore, elucidate, bolster, spearhead, harness, unveil, navigate, foster, catalyse, illuminate, leverage, unpack, showcase.
  - *Adjectives and adverbs*: pivotal, paramount, intricate, meticulous, comprehensive, nuanced, holistic, unprecedented, seamless, groundbreaking, notably, crucially or sentence-initial importantly. Use *robust* strictly in its technical dynamical-systems or statistical sense.
  - *Nouns*: tapestry, landscape, realm, synergy, cornerstone, plethora, linchpin, bedrock. Use *paradigm* strictly as a literal technical classifier (e.g., "Other modelling paradigms such as agent-based models").
- **Transitions and filler**:
  - Never use *Moreover*. Use *Furthermore* sparingly (at most once per section for a substantive addition, never as a default paragraph starter) and do not stack additive transitions across consecutive sentences or paragraphs.
  - Never use throat-clearing phrases such as "It is worth noting that", "It is important to stress/emphasise that", "Needless to say", "A growing body of literature", "pave the way for" or "play a pivotal/crucial role" (write "play a role" or "govern" instead).
- **Preferred connectors**:
  - *Deductive*: "Thus,", "Therefore,", "Hence,", "As a consequence,", "It follows that", "In other words,".
  - *Contrastive*: "Contrary to..." (preferred over "Unlike..."), "On the other hand,", "However," and mid-sentence ", though,".
  - *Synthesis*: "Altogether," to open a concluding observation at the end of a subsection.

## Spelling, punctuation and formatting

- **UK English spelling**: Default to UK spelling unless instructed otherwise, including *modelling, modelled, modellers, behaviour, summarise, characterise, organisation, realisations, spatialisation, analyse, endeavour, scrutinise, travellers, centre, programme* (for research/policy; *program* is acceptable for computer code) and *parametrise* / *parametrisation* (no *e* after *t*).
- **No Oxford commas**: Write `A, B and C`, never `A, B, and C`.
- **No em dashes in prose**: Never use em dashes (`---` or `—`) or spaced en dashes (` -- `) as parenthetical punctuation in sentences; use commas, parentheses, colons, semicolons or separate sentences instead. In LaTeX, `--` is permitted in sectioning titles (`\section`, `\subsection`, `\subsubsection`, etc., e.g., `\subsection{Refinement -- Parametric stochasticity}`) and tight compound terms (e.g., `\emph{importation}--\emph{amplification}`).
- **Sentence case**: Capitalise only the first word, proper nouns and acronyms in all titles, headings, LaTeX sectioning commands (`\title`, `\chapter`, `\section`, `\subsection`, `\subsubsection`), captions and figure labels.
- **Dates**: Use `22 January 2020` in prose and `2020-01-22` in tables and code (never US `January 22, 2020`).
- **Latin terms**: Italicise *per capita*, *stricto sensu* and *a priori*; keep `i.e.,` and `e.g.,` unitalicised and followed by a comma.

## Voice, idioms and mathematical exposition

- **Pronouns**: In solo-authored manuscripts, lecture notes and reviews, use singular `I` and `let me` ("Here, I review...", "Before considering..., let me spend some time on..."), reserving `we` for joint work with collaborators. In co-authored manuscripts, use active `we` in the present tense ("We investigate...", "We suppose...", "We denote...").
- **Mathematical directives**: Guide derivations with direct imperatives: `Consider...`, `Suppose that...`, `Let...`, `Note that...`, `Observe that...` and `Remark that...`.
- **Plain-language interpretation**: Integrate displayed equations into sentences without a preceding colon, and follow key definitions, spectral conditions or thresholds with a direct plain-language or domain interpretation ("In words, they state that...", "The biological interpretation of this is that...", "In practice, finding an eigenvalue less than $1$ means that...").
- **Characteristic lexis (do not smooth out)**: Preserve natural French-inflected mathematical English where present, including *adequation*, *repartition*, *spatialisation*, *mathematise*, *epizooties*, *associated to*, *confronted to* and `allows to` + infinitive, unless explicitly asked for US-journal copy-editing.
- **Scare quotes**: Bracket concise informal shorthand or metaphors in quotes (`` ``toy'' `` models, `` ``failed'' `` epidemics in LaTeX) rather than replacing them with verbose jargon.

## Scientific temperament

- **Never oversell**: Call simplified models what they are ("deliberately over-simplified", "toy models"), note unrealistic parameter regimes plainly and state what a framework cannot address (e.g., ODEs vs contact tracing) without defensive apologies.
- **Separate explanation from forecasting**: Acknowledge openly when mechanistic models prioritise structural understanding over short-term statistical forecasting.
- **Direct scope and data limits**: Interrogate data limitations (reporting delays, under-ascertainment, spatial aggregation mismatches) upfront, state omitted routine proofs or out-of-scope analyses plainly and close discussions with concrete limitations or next questions rather than promotional claims of novelty or impact.
