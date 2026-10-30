### A Pluto.jl notebook ###
# v1.1.0

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    #! format: off
    return quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
    #! format: on
end

# ╔═╡ aa799557-29e1-4637-8e8f-2937d2edab7d
using PlutoUI

# ╔═╡ b7651817-5920-4052-b91f-514eabd5f896
md"""
# Exercise: Global Alignment with Needleman-Wunsch

*Lecture "Sequence alignment and analysis" (EBIF 3.1), Hochschule Kempten*

In this notebook you implement the heart of the Needleman-Wunsch algorithm yourself: first the **F-matrix** (exercise 1), then the **traceback** (exercise 2). Everything else (input fields, sliders, the coloured matrix, the alignment view) is already there.

**How it works**

- Grey code cells with `# TODO` are yours. Edit them and press **Shift + Enter** to run.
- Below every exercise there is a **check** that tests your code against several examples and tells you what is still wrong.
- The visualization further down always works: as long as your code is missing or not yet correct, it automatically uses a hidden **reference implementation** and tells you so. As soon as your code passes the check, you see *your own* results.
"""

# ╔═╡ 386bbde5-223a-46ef-b6a5-ffe781d18b3c
TableOfContents(title = "Contents")

# ╔═╡ 788caa33-86d5-47c0-8d5a-cd6a76bbf7e7
md"""
## 0. Julia in five minutes

- `for i in 1:m` … `end`: loop over i = 1, 2, …, m
- `for i in 1:m, j in 1:n` … `end`: nested loop, **j runs fastest**, so the matrix is filled row by row
- `max(a, b, c)`: the largest of the three values
- `if` … `elseif` … `else` … `end`: conditions; `&&` means *and*, `||` means *or*
- `while i > 0 || j > 0` … `end`: repeat as long as the condition holds
- `push!(v, c)`: append the element `c` to the vector `v`
- `x[i]`: the i-th character of the sequence (the first one is `x[1]`)
- `sc.match`, `sc.mismatch`, `sc.gap`: the parameters of the scoring model
- `S(sc, x[i], y[j])`: substitution score S(xᵢ, yⱼ), i.e. match or mismatch

!!! warning "The one thing to remember: index shift"
    On the slides the matrix starts at F(0, 0). Julia arrays start at index **1**.
    So **F(i, j) from the slides is `F[i+1, j+1]` in Julia.**
    The sequences are *not* shifted: xᵢ is simply `x[i]`.

| slides | Julia |
|:--|:--|
| F(0, 0) | `F[1, 1]` |
| F(i, 0) | `F[i+1, 1]` |
| F(i−1, j−1) | `F[i, j]` |
| F(i−1, j) | `F[i, j+1]` |
| F(i, j−1) | `F[i+1, j]` |
"""

# ╔═╡ 409a54df-f7f6-4528-a446-352b812731ba
md"""
The scoring model is given (you only *use* it):
"""

# ╔═╡ 2bbdd721-a4ef-4a66-ac55-84fe39abac98
begin
	"Scoring model: match and mismatch score plus a linear gap penalty γ."
	struct Scoring
		match::Int
		mismatch::Int
		gap::Int        # linear gap penalty γ (negative)
	end

	"Substitution score S(a, b)"
	S(sc::Scoring, a::Char, b::Char) = a == b ? sc.match : sc.mismatch
end

# ╔═╡ 2fdeaa32-fc6a-417e-aba5-77f25a5a8bca
md"""
## 1. Exercise: compute the F-matrix

Write the function `my_fill`. It receives the two sequences x and y (as vectors of characters) and the scoring model, and returns the complete matrix F with m + 1 rows and n + 1 columns.

**Initialization** (TODO 1): F(0, 0) = 0, F(i, 0) = i · γ, F(0, j) = j · γ

**Recurrence** (TODO 2), for i = 1 … m and j = 1 … n:

F(i, j) = max { F(i−1, j−1) + S(xᵢ, yⱼ),  F(i−1, j) + γ,  F(i, j−1) + γ }

Here γ is the (negative) gap penalty `sc.gap`.
"""

# ╔═╡ 9347db95-4ac9-4ece-a9bd-815ac556b71e
function my_fill(x::Vector{Char}, y::Vector{Char}, sc::Scoring)
	m, n = length(x), length(y)
	γ = sc.gap
	F = zeros(Int, m + 1, n + 1)   # F[i+1, j+1] holds F(i, j); F[1, 1] = 0 already

	# TODO 1: initialization. Set the first column F(i, 0) and the first row F(0, j).


	# TODO 2: fill the rest of the matrix row by row with the recurrence.


	return missing   # when you are done, replace `missing` by `F`
end

# ╔═╡ b4f61c84-a647-4ac8-9702-3557f5c82aff
md"""
## 2. Exercise: traceback

Write the function `my_traceback`. It receives a complete F-matrix and returns the optimal alignment as two strings with `-` for gaps, e.g. `("CGAT--CCTGT", "C-ATCGCCT-T")`.

Start at F(m, n) and walk back to F(0, 0). In every step, find out which of the three predecessors produced the value of the current cell:

| the value came from | append to `ax` | append to `ay` | then |
|:--|:--|:--|:--|
| ↖ diagonal: F(i−1, j−1) + S(xᵢ, yⱼ) | `x[i]` | `y[j]` | `i -= 1; j -= 1` |
| ↑ up: F(i−1, j) + γ | `x[i]` | `'-'` | `i -= 1` |
| ← left: F(i, j−1) + γ | `'-'` | `y[j]` | `j -= 1` |

If several predecessors fit (a tie), prefer the diagonal, as on slide 12. Because you walk backwards, `ax` and `ay` are built from the end; reverse them at the end.

This exercise is independent of exercise 1: the check calls your function with a *correct* F-matrix.
"""

# ╔═╡ e019be82-0678-4648-b347-43e14972cf82
function my_traceback(F::AbstractMatrix, x::Vector{Char}, y::Vector{Char}, sc::Scoring)
	m, n = length(x), length(y)
	γ = sc.gap
	ax, ay = Char[], Char[]   # aligned x and aligned y, built from the end
	i, j = m, n               # start at F(m, n)

	# TODO 3: walk back to F(0, 0).
	# while i > 0 || j > 0
	#     ...
	# end


	return missing   # when you are done, replace by: return String(reverse(ax)), String(reverse(ay))
end

# ╔═╡ 53ff7ba1-eca2-427a-b78a-0f12de920b22
md"""
## 3. Playground

Change the sequences and the scoring model. With *mine*, the matrix and the alignment come from your functions (as far as they are finished); with *reference*, from the reference implementation.
"""

# ╔═╡ 2aadc835-0468-4e1d-a36f-ef021d04e466
md"""
| | |
|:--|:--|
| Sequence **x** (rows) | $(@bind x_in TextField(default = "CGATCCTGT")) |
| Sequence **y** (columns) | $(@bind y_in TextField(default = "CATCGCCTT")) |
| Match | $(@bind s_match Slider(0:5, default = 1, show_value = true)) |
| Mismatch | $(@bind s_mismatch Slider(-5:2, default = -1, show_value = true)) |
| Gap penalty γ | $(@bind gap_d Slider(-8:0, default = -1, show_value = true)) |
| Implementation | $(@bind impl Radio(["mine" => "mine", "ref" => "reference"], default = "mine")) |
"""

# ╔═╡ cf1e8d6a-1292-41cc-bc7e-bd51440922f2
md"""
### The F-matrix

Move the **fill step** slider to build the matrix cell by cell. The current cell has a solid red border; the three cells it depends on are dashed. Small arrows mark *every* predecessor that gives the maximum. When the matrix is complete, the traceback path is yellow.
"""

# ╔═╡ d170b25a-9b31-4785-8593-6a0b69df7848
md"""
### The alignment
"""

# ╔═╡ c01dcf56-30fd-4db5-8080-6ddc4fb6d138
md"""
## 4. Explore

Use the playground to answer these questions.

1. **Gaps for free.** Set match +1, mismatch 0, gap 0 (slide 13). What does F(m, n) count?
2. **No gaps at all.** Make the gap penalty more and more negative. From which value on does the optimal alignment of the slide example contain no gaps? Why does that only work because x and y have the same length?
3. **Ties.** Find cells with more than one arrow. What does that mean for the alignment? Change the order of the cases in your `my_traceback` (e.g. up before diagonal). Does the score change? Does the alignment change? Does the check still accept your code?
4. **Strange models.** What happens if mismatch scores *higher* than match?
"""

# ╔═╡ f9e6ade7-90e8-442e-8531-7b330355544c
md"""
## 5. Bonus: local alignment (Smith-Waterman)

### 5a. The matrix (TODO 4)

Copy your `my_fill` into `my_sw_fill` and change it into the Smith-Waterman recurrence (slides 28–29):

- The first row and column stay **0** (no initialization with γ).
- The maximum gets a fourth option: **0**. A local alignment may start anywhere.

The best local alignment ends in the cell with the **highest value** in the whole matrix, not in F(m, n).
"""

# ╔═╡ 8884cdf8-a4f8-4a67-9e10-bef385925638
function my_sw_fill(x::Vector{Char}, y::Vector{Char}, sc::Scoring)
	m, n = length(x), length(y)
	γ = sc.gap
	F = zeros(Int, m + 1, n + 1)   # first row and first column keep their zeros!

	# TODO 4: fill the matrix with the Smith-Waterman recurrence.


	return missing   # when you are done, replace `missing` by `F`
end

# ╔═╡ 2ea060bd-047d-4721-a104-4a961a5c8cab
md"""
### 5b. The traceback (TODO 5)

Write `my_sw_traceback`. It receives a complete Smith-Waterman matrix and returns the best **local** alignment as two strings, e.g. `("ATC", "ATC")`. Two things differ from your `my_traceback` (slide 29):

- **Start** at the cell with the **highest value** in the whole matrix, not at F(m, n). Write your own loop to find it, then compare with Julia's built-in `findmax(F)`.
- **Stop** at the first cell with value **0**, not at F(0, 0).

Everything in between is the same as in `my_traceback`. The check calls your function with a *correct* matrix, so this exercise does not depend on 5a.
"""

# ╔═╡ 52bf0847-e0fb-45df-a86e-8ae02bad2056
function my_sw_traceback(F::AbstractMatrix, x::Vector{Char}, y::Vector{Char}, sc::Scoring)
	m, n = length(x), length(y)
	γ = sc.gap
	ax, ay = Char[], Char[]   # aligned x and aligned y, built from the end

	# TODO 5a: find the position of the maximum in F.
	#          Write your own loop, then compare with the built-in findmax(F).


	# TODO 5b: start at the maximum and walk back until you reach a cell with value 0.


	return missing   # when you are done, replace by: return String(reverse(ax)), String(reverse(ay))
end

# ╔═╡ cdee9805-0a7d-46ec-88a5-f9861e834038
md"**Test cell for Smith-Waterman.** Use it to try out your `my_sw_traceback`; add `@show` lines in your function to see what happens."

# ╔═╡ c576b42d-0c32-407f-a24d-da4f783f5a08
md"""
---
## Appendix: reference implementation, checks and display

The cells below are hidden. They contain the reference solution, the automatic checks and the code for the tables. You do not need them for the exercises.
"""

# ╔═╡ 2830be38-0909-4e17-ab6b-4d3d809da7c8
begin
	function ref_fill(x::Vector{Char}, y::Vector{Char}, sc::Scoring)
		m, n = length(x), length(y)
		γ = sc.gap
		F = zeros(Int, m + 1, n + 1)
		for i in 1:m
			F[i+1, 1] = i * γ
		end
		for j in 1:n
			F[1, j+1] = j * γ
		end
		for i in 1:m, j in 1:n
			F[i+1, j+1] = max(F[i, j] + S(sc, x[i], y[j]), F[i, j+1] + γ, F[i+1, j] + γ)
		end
		F
	end

	function ref_traceback(F::AbstractMatrix, x::Vector{Char}, y::Vector{Char}, sc::Scoring)
		m, n = length(x), length(y)
		γ = sc.gap
		ax, ay = Char[], Char[]
		i, j = m, n
		while i > 0 || j > 0
			if i > 0 && j > 0 && F[i+1, j+1] == F[i, j] + S(sc, x[i], y[j])
				push!(ax, x[i]); push!(ay, y[j]); i -= 1; j -= 1
			elseif i > 0 && F[i+1, j+1] == F[i, j+1] + γ
				push!(ax, x[i]); push!(ay, '-'); i -= 1
			else
				push!(ax, '-'); push!(ay, y[j]); j -= 1
			end
		end
		String(reverse(ax)), String(reverse(ay))
	end

	function ref_sw_fill(x::Vector{Char}, y::Vector{Char}, sc::Scoring)
		m, n = length(x), length(y)
		γ = sc.gap
		F = zeros(Int, m + 1, n + 1)
		for i in 1:m, j in 1:n
			F[i+1, j+1] = max(0, F[i, j] + S(sc, x[i], y[j]), F[i, j+1] + γ, F[i+1, j] + γ)
		end
		F
	end

	"Score of a given alignment (strings with '-'), linear gap model."
	function alignment_score(ax::AbstractString, ay::AbstractString, sc::Scoring)
		total = 0
		for (p, q) in zip(ax, ay)
			total += (p == '-' || q == '-') ? sc.gap : S(sc, p, q)
		end
		total
	end
end

# ╔═╡ 43299099-3675-402b-a9b9-604054af574a
begin
	"Format a score: integers with a real minus sign."
	fmt(v::Real) = isinf(v) ? (v < 0 ? "−∞" : "∞") : replace(string(round(Int, v)), "-" => "−")
	fmtp(v::Real) = v < 0 ? "($(fmt(v)))" : fmt(v)
	sub(n::Integer) = join(Char(0x2080 + d) for d in reverse(digits(n)))
	"Row and column of the k-th cell when filling row by row."
	cell_of(k, n) = ((k - 1) ÷ n + 1, (k - 1) % n + 1)

	"Arrows for all optimal predecessors: bit 1 = ↖, bit 2 = ↑, bit 3 = ←."
	function compute_arrows(F, a, b, sc::Scoring)
		m, n = length(a), length(b)
		γ = sc.gap
		A = zeros(UInt8, m + 1, n + 1)
		for i in 1:m
			A[i+1, 1] = 0x02
		end
		for j in 1:n
			A[1, j+1] = 0x04
		end
		for i in 1:m, j in 1:n
			v = F[i+1, j+1]
			A[i+1, j+1] = (v == F[i, j] + S(sc, a[i], b[j]) ? 0x01 : 0x00) |
			              (v == F[i, j+1] + γ ? 0x02 : 0x00) |
			              (v == F[i+1, j] + γ ? 0x04 : 0x00)
		end
		A
	end

	"Cells (i, j) visited by an alignment, from (0, 0) to (m, n)."
	function path_from_alignment(ax::AbstractString, ay::AbstractString)
		path = [(0, 0)]
		i, j = 0, 0
		for (p, q) in zip(ax, ay)
			p != '-' && (i += 1)
			q != '-' && (j += 1)
			push!(path, (i, j))
		end
		path
	end

	function alignment_stats(ax::AbstractString, ay::AbstractString)
		cols = collect(zip(ax, ay))
		matches = count(p == q && p != '-' for (p, q) in cols)
		gaps = count(p == '-' || q == '-' for (p, q) in cols)
		(len = length(cols), matches = matches, mismatches = length(cols) - matches - gaps, gaps = gaps)
	end

	const NW_CSS = """
	<style>
	.nw-wrap { overflow-x: auto; }
	table.nw { border-collapse: collapse; font-variant-numeric: tabular-nums; margin: 0.5em 0; }
	table.nw th, table.nw td { min-width: 2.7em; height: 2.3em; text-align: center; padding: 0 0.2em;
	  border: 1px solid rgba(128,128,128,0.25); position: relative; }
	table.nw th { font-family: monospace; font-weight: 700; background: rgba(128,128,128,0.08); }
	table.nw th.corner { font-family: inherit; font-style: italic; }
	table.nw td.path { background: rgba(250,204,21,0.75) !important; color: #1a1a1a; font-weight: 700; }
	table.nw td.cur { outline: 3px solid #dc2626; outline-offset: -3px; }
	table.nw td.nb { outline: 2px dashed #dc2626; outline-offset: -3px; }
	table.nw td.best { outline: 3px solid #16a34a; outline-offset: -3px; font-weight: 700; }
	table.nw .ar { position: absolute; top: 1px; left: 3px; font-size: 0.62em; opacity: 0.75; line-height: 1; }
	table.aln { border-collapse: collapse; font-family: monospace; font-size: 1.25em; margin: 0.5em 0; }
	table.aln td, table.aln th { width: 1.4em; text-align: center; padding: 0.1em 0; }
	table.aln th { font-size: 0.75em; opacity: 0.6; padding-right: 0.6em; }
	table.aln td.m { background: rgba(34,197,94,0.30); }
	table.aln td.x { background: rgba(239,68,68,0.30); }
	table.aln td.g { background: rgba(128,128,128,0.18); }
	table.aln td.bar { line-height: 0.9; }
	.aln-stats { font-size: 0.9em; opacity: 0.85; }
	</style>
	"""
end

# ╔═╡ bf008082-7feb-4c51-b90e-80dd16dd6dea
begin
	"Result of an automatic check; status is :missing, :error, :wrong or :ok."
	struct Check
		status::Symbol
		msg::String
	end

	box(kind, title, text) =
		Markdown.parse("!!! $kind \"$title\"\n" * join(["    " * l for l in split(text, '\n')], "\n"))

	hint(title, text) = HTML("<details style='margin: 0.3em 0'><summary style='cursor: pointer'><b>" *
		title * "</b></summary>" * Markdown.html(Markdown.parse(text)) * "</details>")

	function show_check(c::Check)
		kind, title = c.status == :ok      ? ("correct", "Well done!") :
		              c.status == :missing ? ("note", "Still missing") :
		              c.status == :error   ? ("danger", "Error") :
		                                     ("warning", "Keep working")
		box(kind, title, c.msg)
	end

	function describe_error(e, fname::Symbol)
		if e isa UndefVarError && e.var == fname
			"The cell that defines `$(fname)` has an error. Look at the red message in that cell."
		else
			msg = replace(first(sprint(showerror, e), 300), "`" => "'", "\n" => " ")
			"Your function `$(fname)` threw an error: `$(msg)`"
		end
	end

	tostr(v) = v isa AbstractVector{Char} ? String(v) : string(v)
	tostr_pair(r) = (tostr(r[1]), tostr(r[2]))

	"Compare a student matrix function with the reference on all test cases."
	function check_matrix(f, ref, fname::String, cases)
		for (label, xs, ys, s) in cases
			a, b = collect(xs), collect(ys)
			Fs = try
				f(a, b, s)
			catch e
				return Check(:error, describe_error(e, Symbol(fname)) * " (test case: $(label))")
			end
			Fs === missing && return Check(:missing,
				"`$(fname)` still returns `missing`. Write the missing code, then replace `missing` by `F`.")
			Fs isa AbstractMatrix || return Check(:wrong,
				"`$(fname)` should return a matrix, but it returned a value of type `$(typeof(Fs))`.")
			Fr = ref(a, b, s)
			size(Fs) == size(Fr) || return Check(:wrong,
				"Your matrix has size $(size(Fs)), but it should be (m + 1, n + 1) = $(size(Fr)).")
			m, n = length(a), length(b)
			for i in 0:m, j in 0:n
				v = Fs[i+1, j+1]
				v isa Real || return Check(:wrong, "F($i, $j) is not a number but `$(repr(v))`.")
				if v != Fr[i+1, j+1]
					part = (i == 0 || j == 0) ? "This cell belongs to the first row or column (initialization)." :
					                            "This cell is computed with the recurrence."
					return Check(:wrong, "Test case *$(label)* (x = `$(xs)`, y = `$(ys)`): " *
						"F($i, $j) should be $(fmt(Fr[i+1, j+1])), but your matrix has $(fmt(v)). $(part)")
				end
			end
		end
		Check(:ok, "Your matrix is correct for all $(length(cases)) test cases.")
	end

	"Check a student traceback: valid, optimal, and (ideally) equal to the reference."
	function check_traceback(f, cases)
		identical = 0
		for (label, xs, ys, s) in cases
			a, b = collect(xs), collect(ys)
			Fr = ref_fill(a, b, s)
			r = try
				f(Fr, a, b, s)
			catch e
				return Check(:error, describe_error(e, :my_traceback) * " (test case: $(label))")
			end
			r === missing && return Check(:missing,
				"`my_traceback` still returns `missing`. Write the loop, then return the two reversed strings.")
			(r isa Tuple && length(r) == 2) || return Check(:wrong,
				"`my_traceback` should return a tuple `(ax, ay)` of two strings, but it returned a `$(typeof(r))`.")
			ax, ay = tostr_pair(r)
			where_ = "Test case *$(label)* (x = `$(xs)`, y = `$(ys)`): "
			length(ax) == length(ay) || return Check(:wrong, where_ *
				"the aligned sequences have different lengths ($(length(ax)) and $(length(ay))).")
			replace(ax, "-" => "") == xs || return Check(:wrong, where_ *
				"removing the gaps from your aligned x gives `$(replace(ax, "-" => ""))` instead of `$(xs)`. Did you forget to reverse?")
			replace(ay, "-" => "") == ys || return Check(:wrong, where_ *
				"removing the gaps from your aligned y gives `$(replace(ay, "-" => ""))` instead of `$(ys)`. Did you forget to reverse?")
			any(p == '-' && q == '-' for (p, q) in zip(ax, ay)) && return Check(:wrong, where_ *
				"your alignment has a column with a gap in both sequences.")
			got, opt = alignment_score(ax, ay, s), Fr[end, end]
			got == opt || return Check(:wrong, where_ *
				"your alignment `$(ax)` / `$(ay)` has score $(fmt(got)), but the optimum is $(fmt(opt)). " *
				"Check how you decide which predecessor to follow.")
			(ax, ay) == ref_traceback(Fr, a, b, s) && (identical += 1)
		end
		extra = identical == length(cases) ? "" :
			" In $(length(cases) - identical) test case(s) you found a *different* optimal alignment than the reference " *
			"(which prefers diagonal, then up, then left). That is fine: ties allow several optimal alignments."
		Check(:ok, "Your traceback returns an optimal alignment for all $(length(cases)) test cases." * extra)
	end

	"Check a student Smith-Waterman traceback: contiguous pieces of x and y, best local score."
	function check_sw_traceback(f, cases)
		for (label, xs, ys, s) in cases
			a, b = collect(xs), collect(ys)
			Fr = ref_sw_fill(a, b, s)
			r = try
				f(Fr, a, b, s)
			catch e
				return Check(:error, describe_error(e, :my_sw_traceback) * " (test case: $(label))")
			end
			r === missing && return Check(:missing,
				"`my_sw_traceback` still returns `missing`. Find the maximum, write the loop, then return the two reversed strings.")
			(r isa Tuple && length(r) == 2) || return Check(:wrong,
				"`my_sw_traceback` should return a tuple `(ax, ay)` of two strings, but it returned a `$(typeof(r))`.")
			ax, ay = tostr_pair(r)
			where_ = "Test case *$(label)* (x = `$(xs)`, y = `$(ys)`): "
			length(ax) == length(ay) || return Check(:wrong, where_ *
				"the aligned sequences have different lengths ($(length(ax)) and $(length(ay))).")
			any(p == '-' && q == '-' for (p, q) in zip(ax, ay)) && return Check(:wrong, where_ *
				"your alignment has a column with a gap in both sequences.")
			px, py = replace(ax, "-" => ""), replace(ay, "-" => "")
			occursin(px, xs) || return Check(:wrong, where_ *
				"`$(px)` (your aligned x without gaps) is not a contiguous part of x. Did you forget to reverse?")
			occursin(py, ys) || return Check(:wrong, where_ *
				"`$(py)` (your aligned y without gaps) is not a contiguous part of y. Did you forget to reverse?")
			got, opt = alignment_score(ax, ay, s), maximum(Fr)
			got == opt || return Check(:wrong, where_ *
				"your local alignment `$(ax)` / `$(ay)` has score $(fmt(got)), but the best local score is $(fmt(opt)). " *
				"Do you start at the maximum and stop at the first 0?")
		end
		Check(:ok, "Your traceback returns a best local alignment for all $(length(cases)) test cases.")
	end

	function source_banner(impl, fc::Check, tc::Check)
		impl == "ref" && return box("info", "Reference implementation",
			"Everything below comes from the reference implementation.")
		why(c) = c.status == :missing ? "is not written yet" :
		         c.status == :error   ? "throws an error" : "does not pass the check yet"
		l1 = fc.status == :ok ? "F-matrix: **your `my_fill`** ✔" :
		                        "F-matrix: reference, because your `my_fill` $(why(fc))"
		l2 = tc.status == :ok ? "Traceback: **your `my_traceback`** ✔" :
		                        "Traceback: reference, because your `my_traceback` $(why(tc))"
		kind = (fc.status == :ok && tc.status == :ok) ? "correct" : "note"
		box(kind, "Where the results below come from", "- " * l1 * "\n- " * l2)
	end
end

# ╔═╡ d863fd67-0883-440e-b609-70ab0051bc79
hint("Hint 1: initialization", """
You need two simple loops, one over `i in 1:m` and one over `j in 1:n`.
Remember the index shift: F(i, 0) is `F[i+1, 1]` and F(0, j) is `F[1, j+1]`.
""")

# ╔═╡ ce96f509-724a-48a2-a3c2-63a1d471916f
hint("Hint 2: the recurrence", """
Use the nested loop `for i in 1:m, j in 1:n`. Compute the three candidates first
and give them names, e.g. `diag`, `up`, `left`, then store `max(diag, up, left)`.

F(i−1, j−1) is `F[i, j]`, F(i−1, j) is `F[i, j+1]`, F(i, j−1) is `F[i+1, j]`, and
the new value goes to `F[i+1, j+1]`.
""")

# ╔═╡ 90d477cf-2f04-4536-ac93-aa5d2b1c91d8
hint("Hint 1: the structure", """
Inside the `while` loop you need one `if … elseif … else … end` with the three cases
from the table. Test the diagonal first, then up, and use `else` for left.
""")

# ╔═╡ d0a8c587-7e3e-4565-bb10-28a2536d7b89
hint("Hint 2: the borders", """
At the border of the matrix not all moves are possible: in row 0 (i = 0) you can only go left,
in column 0 (j = 0) only up. Protect the diagonal case with `i > 0 && j > 0 && …` and the
up case with `i > 0 && …`. Then `else` (left) is always safe.

If the cell runs forever, i or j does not decrease in some case. Stop it with the ■ button.
""")

# ╔═╡ 8c77950b-b352-4531-b595-a3d7271532f4
begin
	clean(s) = uppercase(filter(!isspace, s))
	x = isempty(clean(x_in)) ? "CGATCCTGT" : clean(x_in)
	y = isempty(clean(y_in)) ? "CATCGCCTT" : clean(y_in)
	sc = Scoring(s_match, s_mismatch, gap_d)
	a_seq, b_seq = collect(x), collect(y)

	if isempty(clean(x_in)) || isempty(clean(y_in))
		box("warning", "Note", "An empty sequence was replaced by the slide example.")
	elseif max(length(x), length(y)) > 20
		box("warning", "Note", "Long sequences make the matrix hard to read; up to about 15 characters work best.")
	else
		md""
	end
end

# ╔═╡ 7a495127-fa9a-4e6c-8389-e571fbe0accb
begin
	n_cells = length(a_seq) * length(b_seq)
	md"""
	**Fill step:** $(@bind k Slider(0:n_cells, default = n_cells, show_value = true)) of $(n_cells) cells
	"""
end

# ╔═╡ 30260dc9-eeec-4765-bbd1-431f0a9cb079
TEST_CASES = [
	("slide 15", "CGATCCTGT", "CATCGCCTT", Scoring(1, -1, -1)),
	("slide 13", "CGATCCTGT", "CATCGCCTT", Scoring(1, 0, 0)),
	("different lengths", "GATTACA", "GCATG", Scoring(1, -1, -2)),
	("one sequence of length 1", "ACGT", "A", Scoring(2, -1, -1)),
	("reaching a border before (0,0) bounds check!", "GA", "AG", Scoring(1, -1, -1)),
	("reaching a border before (0,0) bounds check column!", "AG", "GA", Scoring(1, -1, -1)),
	("your playground input", x, y, sc),
]

# ╔═╡ 323d00fb-6684-4861-9096-0cc3edfb800d
begin
	fill_check = try
		check_matrix(my_fill, ref_fill, "my_fill", TEST_CASES)
	catch e
		Check(:error, describe_error(e, :my_fill))
	end
	show_check(fill_check)
end

# ╔═╡ d835c5ba-4070-4a73-885b-1ad13c5dc88a
begin
	tb_check = try
		check_traceback(my_traceback, TEST_CASES)
	catch e
		Check(:error, describe_error(e, :my_traceback))
	end
	show_check(tb_check)
end

# ╔═╡ fa6cd90b-4d00-42d9-af34-d1ad532bd2bb
begin
	fill_mine = impl == "mine" && fill_check.status == :ok
	tb_mine = impl == "mine" && tb_check.status == :ok

	F_active = fill_mine ? my_fill(a_seq, b_seq, sc) : ref_fill(a_seq, b_seq, sc)
	ax_active, ay_active = if tb_mine
		tostr_pair(my_traceback(F_active, a_seq, b_seq, sc))
	else
		ref_traceback(F_active, a_seq, b_seq, sc)
	end

	arrows_active = compute_arrows(F_active, a_seq, b_seq, sc)
	path_active = path_from_alignment(ax_active, ay_active)

	source_banner(impl, fill_check, tb_check)
end

# ╔═╡ 4e9e01b4-efe8-4e47-bd1f-6cf96f819677
begin
	sw_check = try
		check_matrix(my_sw_fill, ref_sw_fill, "my_sw_fill", TEST_CASES)
	catch e
		Check(:error, describe_error(e, :my_sw_fill))
	end
	show_check(sw_check)
end

# ╔═╡ dffd4f0f-1817-4b68-8b22-78d5fc0a0fee
let
	# Slide 32 example. Expected result: ("ATC", "ATC") with score 3
	a, b = collect("CGATCCTGT"), collect("CATCGCCTT")
	s = Scoring(1, -1, -3)
	# uses your my_sw_fill once it passes the check, otherwise the reference
	F = sw_check.status == :ok ? my_sw_fill(a, b, s) : ref_sw_fill(a, b, s)
	my_sw_traceback(F, a, b, s)
end

# ╔═╡ 8f466882-5d5e-4fba-95b1-e161225155f1
hint("Hint 1: finding the maximum", """
Loop over all cells and remember the largest value and its position. Julia also has
`best, idx = findmax(F)`: it returns the value and a `CartesianIndex`.
`i, j = Tuple(idx) .- 1` turns it into slide indices, so that F(i, j) is `F[i+1, j+1]` again.

If the maximum occurs more than once, `findmax` returns the first one **column by column**
(Julia stores matrices column-major). Any of them gives a best local alignment.
""")

# ╔═╡ 3f4d0f87-9c17-44d9-9973-eeac8eb2ab53
hint("Hint 2: the loop", """
Use `while F[i+1, j+1] > 0` and the same `if … elseif … else … end` as in `my_traceback`.
The guards `i > 0`, `j > 0` are not even needed here: row 0 and column 0 are all zeros,
so the loop stops before it reaches the border.
""")

# ╔═╡ 82f21cd6-e0c1-4b57-925f-01527c98b93a
begin
	sw_tb_check = try
		check_sw_traceback(my_sw_traceback, TEST_CASES)
	catch e
		Check(:error, describe_error(e, :my_sw_traceback))
	end
	show_check(sw_tb_check)
end

# ╔═╡ be5096c9-e115-4efc-bad4-eeb5df370b93
"""
Render a score matrix as an HTML table.
`upto`: number of inner cells already filled (row by row); `current`: (i, j) to highlight;
`path`: traceback cells (shown when the matrix is complete); `best`: cells with a green border.
"""
function matrix_html(M::AbstractMatrix, a::Vector{Char}, b::Vector{Char};
                     name = "F", upto = typemax(Int), arrows = nothing,
                     path = Tuple{Int, Int}[], current = nothing, best = Tuple{Int, Int}[])
	m, n = length(a), length(b)
	onpath = upto >= m * n ? Set(path) : Set{Tuple{Int, Int}}()
	bestset = Set(best)
	visible(i, j) = i == 0 || j == 0 || (i - 1) * n + j <= upto
	nbrs = current === nothing ? Tuple{Int, Int}[] :
		[(current[1] - 1, current[2] - 1), (current[1] - 1, current[2]), (current[1], current[2] - 1)]

	vals = Float64[M[i+1, j+1] for i in 0:m for j in 0:n if visible(i, j) && isfinite(M[i+1, j+1])]
	lo, hi = isempty(vals) ? (0.0, 1.0) : extrema(vals)

	io = IOBuffer()
	print(io, "<div class='nw-wrap'><table class='nw'><thead><tr><th class='corner'>", name,
	      "</th><th>y →</th>")
	for c in b
		print(io, "<th>", c, "</th>")
	end
	print(io, "</tr></thead><tbody>")
	for i in 0:m
		print(io, "<tr><th>", i == 0 ? "x ↓" : string(a[i]), "</th>")
		for j in 0:n
			v = M[i+1, j+1]
			cls = String[]
			style = ""
			text = ""
			if visible(i, j)
				text = fmt(v)
				t = hi > lo ? (v - lo) / (hi - lo) : 0.5
				style = "background: rgba(59,130,246,$(round(0.06 + 0.42 * t, digits = 3)))"
				(i, j) in onpath && push!(cls, "path")
				(i, j) in bestset && push!(cls, "best")
				current !== nothing && (i, j) == current && push!(cls, "cur")
				(i, j) in nbrs && push!(cls, "nb")
				if arrows !== nothing
					bits = arrows[i+1, j+1]
					s = ((bits & 0x01) != 0 ? "↖" : "") *
					    ((bits & 0x02) != 0 ? "↑" : "") *
					    ((bits & 0x04) != 0 ? "←" : "")
					isempty(s) || (text = "<span class='ar'>$s</span>" * text)
				end
			end
			print(io, "<td class='", join(cls, " "), "' style='", style, "'>", text, "</td>")
		end
		print(io, "</tr>")
	end
	print(io, "</tbody></table></div>")
	HTML(NW_CSS * String(take!(io)))
end

# ╔═╡ 48528a1b-47ff-4f6b-8a57-7473abed9a0d
let
	cur = 1 <= k < n_cells ? cell_of(k, length(b_seq)) : nothing
	matrix_html(F_active, a_seq, b_seq; upto = k, arrows = arrows_active,
	            path = path_active, current = cur)
end

# ╔═╡ be4238eb-65e5-4d96-a7e7-8c1c56e1a3d6
if sw_check.status == :ok
	let
		Fl = my_sw_fill(a_seq, b_seq, sc)
		mx = maximum(Fl)
		bests = [(i, j) for i in 0:length(a_seq) for j in 0:length(b_seq) if Fl[i+1, j+1] == mx]
		where_txt = join(["($i, $j)" for (i, j) in bests], ", ")
		HTML(matrix_html(Fl, a_seq, b_seq; name = "F", best = bests).content *
		     "<p class='aln-stats'>Your local alignment matrix for the playground input. " *
		     "Best local score: <b>$(fmt(mx))</b> in cell(s) $(where_txt) (green border). " *
		     "The traceback (exercise 5b) starts at a green cell and stops at the first 0.</p>")
	end
else
	md"*Your Smith-Waterman matrix appears here once `my_sw_fill` passes the check.*"
end

# ╔═╡ 22d4206b-b2bf-44f1-abc9-8c7117462502
begin
	"Alignment as a three-line HTML table: x, match bars, y."
	function alignment_html(ax::AbstractString, ay::AbstractString)
		cols = collect(zip(ax, ay))
		kind(p, q) = (p == '-' || q == '-') ? "g" : (p == q ? "m" : "x")
		io = IOBuffer()
		print(io, "<table class='aln'><tr><th>x</th>")
		for (p, q) in cols
			print(io, "<td class='", kind(p, q), "'>", p, "</td>")
		end
		print(io, "</tr><tr><th></th>")
		for (p, q) in cols
			print(io, "<td class='bar'>", (p == q && p != '-') ? "|" : "", "</td>")
		end
		print(io, "</tr><tr><th>y</th>")
		for (p, q) in cols
			print(io, "<td class='", kind(p, q), "'>", q, "</td>")
		end
		print(io, "</tr></table>")
		String(take!(io))
	end

	"Step-by-step explanation of one cell of the F-matrix."
	function explain(F, a, b, sc::Scoring, i, j)
		xi, yj = a[i], b[j]
		s, γ = S(sc, xi, yj), sc.gap
		diag, up, left = F[i, j] + s, F[i, j+1] + γ, F[i+1, j] + γ
		best = F[i+1, j+1]
		hl(v) = v == best ? "**$(fmt(v))**" : fmt(v)
		Markdown.parse("""
		**Cell ($i, $j)**: x$(sub(i)) = `$xi`, y$(sub(j)) = `$yj` → $(xi == yj ? "match" : "mismatch"), S = $(fmt(s))

		F($i, $j) is the maximum of:

		- ↖ diagonal: F($(i-1), $(j-1)) + S = $(fmt(F[i, j])) + $(fmtp(s)) = $(hl(diag))
		- ↑ up (gap in y): F($(i-1), $j) + γ = $(fmt(F[i, j+1])) + $(fmtp(γ)) = $(hl(up))
		- ← left (gap in x): F($i, $(j-1)) + γ = $(fmt(F[i+1, j])) + $(fmtp(γ)) = $(hl(left))

		⇒ F($i, $j) = **$(fmt(best))**
		""")
	end
end

# ╔═╡ 8027f419-22dc-4c5d-9eca-ad70b1221615
if k == 0
	md"Only the first row and column are initialized. Move the slider to the right."
elseif k < n_cells
	explain(F_active, a_seq, b_seq, sc, cell_of(k, length(b_seq))...)
else
	let m = length(a_seq), n = length(b_seq)
		Markdown.parse("The matrix is complete. Optimal global score: F($m, $n) = **$(fmt(F_active[end, end]))**.")
	end
end

# ╔═╡ bbe38600-6ccd-4027-96ef-160a56ed76a9
let
	st = alignment_stats(ax_active, ay_active)
	recomputed = alignment_score(ax_active, ay_active, sc)
	ok = recomputed == F_active[end, end]
	HTML(NW_CSS * alignment_html(ax_active, ay_active) * """
	<p class="aln-stats">
	Length $(st.len) · matches $(st.matches) · mismatches $(st.mismatches) · gaps $(st.gaps)<br>
	Score F(m, n): <b>$(fmt(F_active[end, end]))</b> ·
	score recomputed column by column: <b>$(fmt(recomputed))</b>
	$(ok ? "✔ consistent" : "✘ inconsistent!")
	</p>
	""")
end

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
PlutoUI = "~0.7.23"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.13.3"
manifest_format = "2.1"
project_hash = "9a38ea2a7647ef8107794f1f94ff9c7ddda19134"

[[deps.AbstractPlutoDingetjes]]
git-tree-sha1 = "e71ee7b4aa06b045259a7d6101e1cb45ad140bce"
registries = "General"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.4.1"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"
version = "1.11.0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"
version = "1.11.0"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
registries = "General"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "7134810b1afce04bbc1045ca1985fbe81ce17653"
registries = "General"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.5"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "b6d6bfdd7ce25b0f9b2f6b3dd56b2673a66c8770"
registries = "General"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.5"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"
version = "1.11.0"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
registries = "General"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

[[deps.JuliaSyntaxHighlighting]]
deps = ["StyledStrings"]
uuid = "ac6e5ff7-fb65-4e79-a425-ec3bc9c03011"
version = "1.12.0"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"
version = "1.11.0"

[[deps.Markdown]]
deps = ["Base64", "JuliaSyntaxHighlighting", "StyledStrings"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"
version = "1.11.0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"
version = "1.11.0"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "e24b87585a307a3c3225cb9b64d03802a1e01edd"
registries = "General"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.8.10"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "Dates", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "UUIDs"]
git-tree-sha1 = "5152abbdab6488d5eec6a01029ca6697dff4ec8f"
registries = "General"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.23"

[[deps.PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "edbeefc7a4889f528644251bdb5fc9ab5348bc2c"
registries = "General"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.3.4"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "aef1987d90dcc2e2cbd919ad10b2d25bcce4f418"
registries = "General"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.6.1"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"
version = "1.11.0"

[[deps.Random]]
deps = ["SHA"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"
version = "1.11.0"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
registries = "General"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "1.0.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"
version = "1.11.0"

[[deps.StyledStrings]]
uuid = "f489334b-da3d-4c2e-b8f0-e476e12c162b"
version = "1.11.0"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"
version = "1.11.0"

[[deps.Tricks]]
git-tree-sha1 = "311349fd1c93a31f783f977a71e8b062a57d4101"
registries = "General"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.13"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"
version = "1.11.0"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"
version = "1.11.0"

[registries.General]
url = "https://github.com/JuliaRegistries/General.git"
uuid = "23338594-aafe-5451-b93e-139f81909106"
"""

# ╔═╡ Cell order:
# ╟─b7651817-5920-4052-b91f-514eabd5f896
# ╟─aa799557-29e1-4637-8e8f-2937d2edab7d
# ╟─386bbde5-223a-46ef-b6a5-ffe781d18b3c
# ╟─788caa33-86d5-47c0-8d5a-cd6a76bbf7e7
# ╟─409a54df-f7f6-4528-a446-352b812731ba
# ╠═2bbdd721-a4ef-4a66-ac55-84fe39abac98
# ╟─2fdeaa32-fc6a-417e-aba5-77f25a5a8bca
# ╠═9347db95-4ac9-4ece-a9bd-815ac556b71e
# ╟─d863fd67-0883-440e-b609-70ab0051bc79
# ╟─ce96f509-724a-48a2-a3c2-63a1d471916f
# ╟─323d00fb-6684-4861-9096-0cc3edfb800d
# ╟─b4f61c84-a647-4ac8-9702-3557f5c82aff
# ╠═e019be82-0678-4648-b347-43e14972cf82
# ╟─90d477cf-2f04-4536-ac93-aa5d2b1c91d8
# ╟─d0a8c587-7e3e-4565-bb10-28a2536d7b89
# ╟─d835c5ba-4070-4a73-885b-1ad13c5dc88a
# ╟─53ff7ba1-eca2-427a-b78a-0f12de920b22
# ╟─2aadc835-0468-4e1d-a36f-ef021d04e466
# ╟─8c77950b-b352-4531-b595-a3d7271532f4
# ╟─fa6cd90b-4d00-42d9-af34-d1ad532bd2bb
# ╟─cf1e8d6a-1292-41cc-bc7e-bd51440922f2
# ╟─7a495127-fa9a-4e6c-8389-e571fbe0accb
# ╟─48528a1b-47ff-4f6b-8a57-7473abed9a0d
# ╟─8027f419-22dc-4c5d-9eca-ad70b1221615
# ╟─d170b25a-9b31-4785-8593-6a0b69df7848
# ╟─bbe38600-6ccd-4027-96ef-160a56ed76a9
# ╟─c01dcf56-30fd-4db5-8080-6ddc4fb6d138
# ╟─f9e6ade7-90e8-442e-8531-7b330355544c
# ╠═8884cdf8-a4f8-4a67-9e10-bef385925638
# ╟─4e9e01b4-efe8-4e47-bd1f-6cf96f819677
# ╟─be4238eb-65e5-4d96-a7e7-8c1c56e1a3d6
# ╟─2ea060bd-047d-4721-a104-4a961a5c8cab
# ╟─8f466882-5d5e-4fba-95b1-e161225155f1
# ╟─3f4d0f87-9c17-44d9-9973-eeac8eb2ab53
# ╠═52bf0847-e0fb-45df-a86e-8ae02bad2056
# ╟─82f21cd6-e0c1-4b57-925f-01527c98b93a
# ╟─cdee9805-0a7d-46ec-88a5-f9861e834038
# ╠═dffd4f0f-1817-4b68-8b22-78d5fc0a0fee
# ╟─c576b42d-0c32-407f-a24d-da4f783f5a08
# ╟─2830be38-0909-4e17-ab6b-4d3d809da7c8
# ╟─30260dc9-eeec-4765-bbd1-431f0a9cb079
# ╟─bf008082-7feb-4c51-b90e-80dd16dd6dea
# ╟─43299099-3675-402b-a9b9-604054af574a
# ╟─be5096c9-e115-4efc-bad4-eeb5df370b93
# ╟─22d4206b-b2bf-44f1-abc9-8c7117462502
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
