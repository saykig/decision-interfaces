"""R22: exact joint reward/detection queries, for the declared one-sender model.

A source is the convex hull of a nonempty finite list (reward, detection).
All arithmetic is rational. No solver or floating-point feasibility oracle.
See ../README.md for the strategic model, proofs and excluded operations.
"""
from __future__ import annotations

from fractions import Fraction as F
from itertools import combinations
from typing import Iterable, NamedTuple

Point = tuple[F, F]
Source = tuple[Point, ...]


def rational(value: F | int | str) -> F:
    if isinstance(value, bool) or not isinstance(value, (F, int, str)):
        raise TypeError("use Fraction, integer or rational string, never float/bool")
    return F(value)


def source(points: Iterable[tuple[F | int | str, F | int | str]]) -> Source:
    result = tuple(sorted(set((rational(r), rational(q)) for r, q in points)))
    if not result:
        raise ValueError("the uncertainty source must be nonempty")
    if any(r <= 0 or not 0 < q < 1 for r, q in result):
        raise ValueError("reward must be positive and detection strictly between 0 and 1")
    return result


def query(a: F | int | str, k: F | int | str) -> tuple[F, F]:
    a, k = rational(a), rational(k)
    if a <= 0 or k <= 0:
        raise ValueError("reward multiplier and report cost must be positive")
    return a, k


def frontier(points: Source, a: F | int | str, k: F | int | str) -> F:
    """Attained minimum fine over the ENTIRE convex hull, not a grid estimate."""
    points = source(points)
    a, k = query(a, k)
    return max(F(0), max((a * r - k) / q for r, q in points))


def safe(points: Source, a: F | int | str, k: F | int | str,
         fine: F | int | str) -> bool:
    """Replay original affine incentive constraints at the proposed fine."""
    points = source(points)
    a, k = query(a, k)
    fine = rational(fine)
    if fine < 0:
        raise ValueError("fine must be nonnegative")
    return all(a * r - k - fine * q <= 0 for r, q in points)


def profile(points: Source, t: F | int | str) -> F:
    t = rational(t)
    if t < 0:
        raise ValueError("negative effective costs are outside this interface contract")
    return frontier(points, 1, t) if t > 0 else max(r / q for r, q in source(points))


class Piece(NamedTuple):
    left: F
    right: F | None
    intercept: F
    decay: F

    def value(self, t: F) -> F:
        return self.intercept - self.decay * t


def envelope(points: Source) -> tuple[Piece, ...]:
    """Canonical clipped upper envelope on t>=0; None is the infinite endpoint.

    This simple reference enumerates line intersections. It does not claim an
    optimal envelope algorithm, a bit-rate result, or multi-sender coverage.
    """
    points = source(points)
    lines = tuple(sorted({(r / q, 1 / q) for r, q in points} | {(F(0), F(0))}))
    end = max(r for r, _ in points)
    cuts = {F(0), end}
    for (x, y), (u, v) in combinations(lines, 2):
        if y != v:
            t = (x - u) / (y - v)
            if 0 < t < end:
                cuts.add(t)
    cuts = sorted(cuts)
    pieces: list[Piece] = []
    for left, right in zip(cuts, cuts[1:]):
        t = (left + right) / 2
        x, y = max(lines, key=lambda line: (line[0] - line[1] * t, line))
        if pieces and (pieces[-1].intercept, pieces[-1].decay) == (x, y):
            pieces[-1] = Piece(pieces[-1].left, right, x, y)
        else:
            pieces.append(Piece(left, right, x, y))
    pieces.append(Piece(end, None, F(0), F(0)))
    return tuple(pieces)


def envelope_value(pieces: tuple[Piece, ...], t: F | int | str) -> F:
    t = rational(t)
    if t < 0:
        raise ValueError("profile domain is t>=0")
    for piece in pieces:
        if piece.left <= t and (piece.right is None or t <= piece.right):
            return piece.value(t)
    raise ValueError("incomplete envelope")


def discrepancy(p: Source, q: Source, lo: F | int | str,
                hi: F | int | str) -> F:
    """Exact symmetric profile discrepancy on a declared compact cost interval."""
    lo, hi = rational(lo), rational(hi)
    if not 0 <= lo <= hi:
        raise ValueError("require 0<=lo<=hi")
    ep, eq = envelope(p), envelope(q)
    cuts = {lo, hi}
    for piece in ep + eq:
        if lo < piece.left < hi:
            cuts.add(piece.left)
    return max(abs(envelope_value(ep, t) - envelope_value(eq, t)) for t in cuts)


def serial(points: Source, floors: Iterable[F | int | str],
           a: F | int | str, k: F | int | str) -> F:
    """Independent additional serial audit stages; each occurrence is charged."""
    divisor = F(1)
    for floor in floors:
        floor = rational(floor)
        if not 0 < floor < 1:
            raise ValueError("serial detection floor must be in (0,1)")
        divisor *= floor
    return frontier(points, a, k) / divisor


def masked_serial(components: dict[str, Source],
                  floors: dict[str, F | int | str],
                  allowed: Iterable[tuple[str, str]],
                  a: F | int | str, k: F | int | str) -> F | None:
    """Exact finite compatibility mask; no assignment returns None, NOT zero."""
    pairs = tuple(allowed)
    # Validate even an empty mask; malformed data is not infeasibility.
    a, k = query(a, k)
    for points in components.values():
        source(points)
    for floor in floors.values():
        floor = rational(floor)
        if not 0 < floor < 1:
            raise ValueError("serial detection floor must be in (0,1)")
    for left, right in pairs:
        if left not in components or right not in floors:
            raise ValueError("mask references an unknown component or audit label")
    if not pairs:
        return None
    return max(serial(components[left], [floors[right]], a, k)
               for left, right in pairs)
