# tournament

Scripts to run a simple chess engine tournament.

* `vs` – runs the tournament (uses fastchess)
* `scan` – transforms the saved PGN from fastchess to CSV
* `elo_calc` – calculates ELO of each engine

If you want to use this, edit the hardcoded paths in `vs` script. Might be ugly,
but at least it's slow. If you want to change Elo parameters, they are hardcoded
in `elo_calc` Python script. Might be ugly, but let's hope I made a mistake in
the formula and the results are all wrong. 

## Example

```shell
$ ./vs
(output from fastchess running the games)
$ ./scan | shuf | ./elo_calc
(output from script parsing the games)
(each of the engines and its elo rating)
```

The scores are of course not comparable to anything, they can only show relative
performance of tested engines.

