#import "@preview/touying:0.7.4": *
#import "assets/theme/bonham-theme.typ": *
#import "@preview/cetz:0.4.2"
#import "assets/general/slides.typ": thank-you-slide, contact_info_slide

#let cetz-canvas = touying-reducer.with(
  reduce: cetz.canvas,
  cover: cetz.draw.hide.with(bounds: true)
)

// Thin on-theme border for photos/screenshots/plots sitting on the dark bg,
// same treatment as the site's card/portrait borders (see README).
#let framed(path, width: 100%) = box(
  stroke: 0.75pt + bonham-dark.border,
  radius: 3pt,
  clip: true,
  image(path, width: width),
)

// Card wrapper for code blocks so they read as panels against the dark bg.
#let code-card(body) = box(
  fill: bonham-dark.surface,
  inset: 8pt,
  radius: 4pt,
  width: 100%,
  body,
)

#show: bonham-theme.with(
  aspect-ratio: "16-9",
  footer: self => self.info.institution,
  // Whole-deck dark "terminal" palette; focus-slide flips to the light
  // "paper" palette instead, as the deliberate change-of-register slide.
  bg: bonham-dark.bg,
  surface: bonham-dark.surface,
  border: bonham-dark.border,
  text-color: bonham-dark.text,
  text-muted: bonham-dark.text-muted,
  primary: bonham-dark.primary,
  accent: bonham-dark.accent,
  secondary: bonham-dark.secondary,
  dark-bg: bonham-light.bg,
  dark-surface: bonham-light.surface,
  dark-border: bonham-light.border,
  dark-text: bonham-light.text,
  dark-text-muted: bonham-light.text-muted,
  dark-primary: bonham-light.primary,
  dark-accent: bonham-light.accent,
  dark-secondary: bonham-light.secondary,
  config-info(
    title: [The State of BioJulia],
    eyebrow: [BioJulia Minisymposium],
    author: [Kevin Bonham, PhD],
    date: datetime(year: 2026, month: 8, day: 13),
    institution: [JuliaCon 2026],
    logo: image("assets/general/lab-logo-banner.png", width: 8em),
  ),
)

#title-slide()

#outline-slide(title: [Agenda], level: 1, numbered: (false,))

= Computing in Biology

== Biology and computing has a rich history

#slide(align: top)[
  #set text(15pt)
  #set par(leading: 0.55em, spacing: 0.85em)
  - *1965* --- Dayhoff's Atlas of Protein Sequence and Structure
  #pause
  - *1970* --- Needleman–Wunsch global alignment
  #pause
  - *1971* --- Protein Data Bank founded at Brookhaven
  #pause
  - *1975* --- Levitt \& Warshel, first computer simulation of protein folding
  #pause
  - *1977* --- McCammon, Gelin \& Karplus, first molecular dynamics simulation of a protein (BPTI); Karplus, Levitt, and Warshel shared the 2013 Nobel Prize
  #pause
  - *1978* --- Dayhoff PAM substitution matrices
  #pause
  - *1981* --- Smith–Waterman local alignment
  #pause
  - *1990* --- BLAST
  #pause
  - *1994* --- Burrows–Wheeler Transform
  #pause
  - *1995* --- first complete bacterial genome (#emph[H. influenzae], TIGR)
  #pause
  - *2000--2003* --- Human Genome Project draft / completion
  #pause
  - *2001* --- Pevzner et al. de Bruijn / Eulerian-path formulation of fragment assembly
  #pause
  - *2020* --- AlphaFold2 wins CASP14, near-experimental accuracy
  #pause
  - *2021* --- AlphaFold2 Nature paper and open-source release; AlphaFold DB (200M+ structures)
]

= History of BioJulia

== First commit --- Bio.jl, January 2014

#slide[
  #text(font: font-heading, size: 1.1em, weight: "bold")[Early contributors]
  #v(1.2em)
  #grid(
    columns: (1fr, 1fr, 1fr),
    row-gutter: 0.5em,
    column-gutter: 0em,
    ..(
      ("images/blahah_head.png", "@blahah"),
      ("images/bicycle1885_head.jpg", "@bicycle1885"),
      ("images/dcjones_head.jpg", "@dcjones"),
      ("images/kdm9_head.jpg", "@kdm9"),
      ("images/jgreener64_head.png", "@jgreener64"),
      ("images/transgirlcodes_head.jpg", "@transgirlcodes"),
    ).map(pair => align(center)[
      #framed(pair.at(0), width: 30%)
      #v(0.3em)
      #text(font: font-mono, size: 0.8em)[#pair.at(1)]
    ])
  )
]

== Parsing infrastructure

#slide(align: top)[
  #grid(
    columns: (3fr, 1fr),
    column-gutter: 2em,
    [
      #set text(18pt)
      - *May 2015* --- `@dcjones` introduces Ragel for fast, accurate parsing
      #pause
      - *Jan 2016* --- `@bicycle1885` replaces Ragel with an all-Julia state-machine generator (`Automa.jl`)
      #pause
      - *Sep 2023* --- `@jakobnissen` releases `Automa.jl` v1.0
    ],
    [
      #uncover("1-")[#framed("images/dcjones_head.jpg", width: 45%)]
      #v(0.6em)
      #uncover("2-")[#framed("images/bicycle1885_head.jpg", width: 45%)]
      #v(0.6em)
      #uncover("3-")[#framed("images/jakobnissen_head.jpg", width: 45%)]
    ],
  )
]

== Infrastructure and other milestones

#slide(align: top)[
  #grid(
    columns: (3fr, 1fr),
    column-gutter: 2em,
    [
      #set text(16pt)
      - *April 2016* --- `@kescobo`'s first contribution to `Bio.jl` (a BLAST wrapper, now `NCBIBlast.jl`)
      #pause
      - *May 2017* --- decomposition of the monorepo (e.g. `Bio.Seq` becomes `BioSequences.jl`), driven by `@bicycle1885` and `@transgirlcodes`
      #pause
      - *Dec 2018* --- transition from REQUIRE to Project.toml
      #pause
      - *Feb 2019 -- May 2020* --- use of the BioJulia package registry
      #pause
      - *May 2020* --- `Bio.jl` officially deprecated / archived
    ],
    [
      #uncover("1-")[#framed("images/kescobo_head.png", width: 45%)]
      #v(0.6em)
      #uncover("2-")[#framed("images/bicycle1885_head.jpg", width: 45%)]
      #v(0.6em)
      #uncover("2-")[#framed("images/transgirlcodes_head.jpg", width: 45%)]
    ],
  )
]

= BioJulia in 2026

== What is BioJulia?

#slide(align: top)[
  #set text(19pt)
  - A loose collection of bioinformatics and other bio-related packages
  #pause
  - "Led" by `@kescobo` (that's me) and `@jakobnissen` --- but our authority is rather... inconspicuous
  #pause
  - Main benefit of org membership: discoverability (maybe), and a higher bus factor if you disappear
  #pause
  - Unified documentation at #link("https://biojulia.dev")[biojulia.dev]
]

== Most-starred repositories

#slide[#align(center)[#framed("images/stars.svg", width: 85%)]]

== Repository statistics

#slide[#align(center)[#framed("images/repostats.svg", width: 85%)]]

== Contributor statistics

#slide[#align(center)[#framed("images/commiters.svg", width: 85%)]]

= Highlights and growth areas

== BioSequences.jl efficiently encodes biological sequences

#slide(align: top)[
  #set text(14pt)
  #code-card[
    ```julia
    import Base: summarysize
    using BioSequences, Random

    seq = randseq(DNAAlphabet{2}(), 512)
    str = String(seq)

    summarysize(seq) # 184
    summarysize(str) # 520
    ```
  ]
  #pause
  #code-card[
    ```julia
    help?> DNAAlphabet{2}
      DNA nucleotide alphabet.

      DNAAlphabet has a parameter N determining the BitsPerSymbol
      trait. Currently supported values of N are 2 and 4.
    ```
  ]
  #pause
  #code-card[
    ```julia
    julia> @btime findall(DNA_A, $seq);
      1.487 μs (4 allocations: 1.92 KiB)

    julia> @btime findall(==('A'), $str);
      3.093 μs (4 allocations: 1.92 KiB)
    ```
  ]
]

== BioSequences.jl competes with special-purpose languages

#slide[
  #grid(
    columns: (1fr, 1fr),
    column-gutter: 1em,
    framed("images/cajun/seq-fig1.png"),
    framed("images/cajun/seq-fig4.png"),
  )
  #v(0.6em)
  #align(center)[#text(font: font-mono, size: 0.6em, fill: bonham-dark.text-muted)[
    Seq Language: https://doi.org/10.5281/zenodo.3374036 · Blog post: biojulia.dev/posts/seq-lang/
  ]]
]

== BioSequences.jl competes with special-purpose languages

#slide[
  #align(center)[#framed("images/cajun/seq-fig5.png", width: 55%)]
  #v(0.6em)
  #align(center)[#text(font: font-mono, size: 0.6em, fill: bonham-dark.text-muted)[
    Seq Language: https://doi.org/10.5281/zenodo.3374036 · Blog post: biojulia.dev/posts/seq-lang/
  ]]
]

== File parsing is a critical part of bioinformatics

#slide(align: top)[
  #set text(12.5pt)
  #grid(
    columns: (1fr, 1fr),
    column-gutter: 1.5em,
    [
      *FASTA*
      #code-card[
        ```txt
        > some header | other info
        AATTACGC
        > foo
        AGGGAGATCCC
        ```
      ]
      #v(0.5em)
      *FASTQ*
      #code-card[
        ```txt
        @ some header | other info
        AATTACGC
        +
        AAAAA#EE
        @ foo
        AGGGAGATCCC
        +
        AA#G</EEA6E
        ```
      ]
    ],
    [
      *SAM*
      #code-card[
        ```txt
        @HD  VN:1.0  SO:unsorted
        @SQ  SN:1455__A0A0C2TZA5__A3781_04875  LN:1008
        @SQ  SN:1455__A0A0C2XRW0__A3781_18225  LN:804
        @SQ  SN:1455__A0A0C2XXQ4__A3781_14565  LN:867
        ...
        VH01194:15:AAAWT2VHV:1:1101  16  cobJ  67  3
        150M  *  0  0  CTGCAGGCGGCG...  AS:i:-59  NM:i:12
        ```
      ]
      #pause
      #v(0.8em)
      #align(center)[
        #text(style: "italic")[
          "The development of every bioinformatics tool begins with the
          definition of a new file format, incompatible with all previous
          formats."
        ]
        #v(0.4em)
        #text(font: font-mono, size: 0.7em)[--- Charles Darwin]
      ]
    ],
  )
]

== Automa.jl builds correct, efficient parsers

#slide(align: top)[
  #align(center)[#framed("images/cajun/Automa.png", width: 76%)]
  #v(0.6em)
  #set text(13pt)
  #grid(
    columns: (1fr, 1fr),
    column-gutter: 1.5em,
    [
      #pause
      #code-card[
        ```julia
        fasta_regex = let
            header = re"[a-z]+"
            seqline = re"[ACGT]+"
            record = '>' * header * '\n' * rep1(seqline * '\n')
            rep(record)
        end
        ```
      ]
    ],
    [
      #pause
      #code-card[
        ```julia
        machine = let
            header = onexit!(onenter!(re"[a-z]+", :mark_pos), :header)
            seqline = onexit!(onenter!(re"[ACGT]+", :mark_pos), :seqline)
            record = onexit!(re">" * header * '\n' * rep1(seqline * '\n'), :record)
            compile(rep(record))
        end
        ```
      ]
    ],
  )
  #v(0.5em)
  #text(font: font-mono, size: 0.65em, fill: bonham-dark.text-muted)[
    author: `@bicycle1885`, many improvements: `@jakobnissen` · Repo: github.com/BioJulia/Automa.jl
  ]
]

== BioMakie.jl enables easy plotting of protein structures

#slide[
  #set text(13pt)
  #grid(
    columns: (3fr, 2fr),
    column-gutter: 1.5em,
    [
      #code-card[
        ```julia
        using BioMakie
        using GLMakie
        using BioStructures
        struc = retrievepdb("2vb1") |> Observable
        ## or
        struc = read("2vb1.pdb", BioStructures.PDB) |> Observable

        fig = Figure()
        plotstruc!(fig, struc; plottype = :ballandstick,
            gridposition = (1, 1), atomcolors = aquacolors)
        plotstruc!(fig, struc; plottype = :covalent, gridposition = (1, 2))
        ```
      ]
    ],
    align(center)[#framed("images/cajun/struct1.png", width: 95%)],
  )
  #v(0.4em)
  #text(font: font-mono, size: 0.65em, fill: bonham-dark.text-muted)[
    author: `@dkool` · Repo: github.com/BioJulia/BioMakie.jl
  ]
]

== BioMakie.jl enables easy plotting of protein structures

#slide[
  #grid(
    columns: (1fr, 1fr),
    column-gutter: 1.5em,
    [
      #text(size: 0.75em)[Viewing amino-acid frequencies in a multiple sequence alignment]
      #v(0.4em)
      #framed("images/cajun/msaselection.gif", width: 90%)
    ],
    [
      #pause
      #text(size: 0.75em)[Database info for a protein, including a GPT response via `OpenAI.jl`]
      #v(0.4em)
      #framed("images/cajun/dbinfo.gif", width: 90%)
    ],
  )
  #v(0.4em)
  #text(font: font-mono, size: 0.65em, fill: bonham-dark.text-muted)[Repo: github.com/BioJulia/BioMakie.jl]
]

== SingleCellProjections.jl enables fast, memory-efficient scRNA-seq

#slide[
  #align(center)[#framed("images/cajun/ssp.svg", width: 55%)]
  #v(0.5em)
  #align(center)[#text(font: font-mono, size: 0.65em, fill: bonham-dark.text-muted)[
    Repo: github.com/BioJulia/SingleCellProjections.jl
  ]]
]

== SingleCellProjections.jl enables fast, memory-efficient scRNA-seq

#slide[
  #align(center)[#framed("images/cajun/ssp-benchmark.png", width: 55%)]
  #v(0.5em)
  #align(center)[#text(font: font-mono, size: 0.65em, fill: bonham-dark.text-muted)[
    Repo: github.com/BioJulia/SingleCellProjections.jl
  ]]
]

#focus-slide[
  #text(size: 0.75em, weight: "medium")[Limitations? Come to our BoF]

  #v(0.7em)
  #text(size: 0.85em, style: "italic")[Using Julia for Computational Biology (and pharma, and health)]

  #v(1.1em)
  #text(font: font-mono, size: 0.55em)[14 August 2026 · 15:45--16:45 · Alte Mensa]
]

#contact_info_slide

#thank-you-slide(slidesurl: "https://github.com/BonhamLab/presentation_biojulia")
