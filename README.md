# Family Tree in Prolog

MSCS-632 Advanced Programming Languages, Assignment 8
Frenie Labrador

A family tree for a made up family (the Millers, 4 generations) written in Prolog.
It has facts for parent, male and female, rules for grandparent, sibling, cousin,
aunt/uncle, and recursive rules for ancestors and descendants.

## Files

- `family_tree.pl` - the facts and rules
- `queries.txt` - sample queries to type in, with the answer you should get
- `run_queries.pl` - runs all the sample queries at once and prints the answers
- `expected_output.txt` - output from running `run_queries.pl`

## The family

```
robert + linda
 |-- michael + jennifer
 |     |-- emily + chris
 |     |     |-- noah
 |     |     |-- ava
 |     |-- jake
 |-- susan + mark
 |     |-- olivia
 |     |-- ethan
 |-- david + karen
       |-- sophia
```

## How to run

Install SWI-Prolog (tested on 9.0.4), then from this folder:

```
swipl family_tree.pl
?- siblings_of(michael, L).
L = [david, susan].
```

To run every sample query at once:

```
swipl run_queries.pl
```

Type `halt.` to leave the Prolog prompt.
