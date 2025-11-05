import numpy as np

# Compute the scoring matrix using linear gap penalty 
def compute_f_matrix_linear(x, y, match=1, mismatch=-1, gap=-1): -> list[list[int]]:
  # implement to fill F  
  pass

# Perform traceback without the help of an additional pointer matrix
# When performing traceback, we'll need to recompute the direction
def traceback_from_f(
    F: npt.NDArray[np.int_],
    x: str,
    y: str,
    match: int = 1,
    mismatch: int = -1,
    gap: int = -1,
) -> tuple[str, str]:
  # return the two aligned sequences including gaps
  pass
  

def format_alignment(ax, ay, match_char='|', mismatch_char=' ', gap_char=' ',
                     group=1, wrap=None): -> str
    """
    Pretty-print an alignment.

    Parameters
    ----------
    ax, ay : str
        Aligned sequences of equal length (with '-' for gaps).
    match_char : str
        Character to show for exact matches (default '|').
    mismatch_char : str
        Character to show for mismatches (default ' ').
    gap_char : str
        Character to show when either side is a gap (default ' ').
    group : int
        Insert an extra space between groups of this many symbols (1 = no extra grouping).
    wrap : int or None
        If given, wrap output to this many alignment columns per block (not counting
        the extra inter-symbol spaces). None = no wrapping.

    Returns
    -------
    str
        Three-line formatted alignment (possibly repeated in wrapped blocks).
    """
    pass

