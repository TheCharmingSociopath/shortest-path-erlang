# Basic erlang practice
Solved 2 small problems in Erlang as an assignment for the Distributed Systems UG course. See Assignment.pdf for the problems. Here is an overview of the solutions.

## Problem 1
- Spawned a process from the main with the PID of self.
- Each process prints the required string and passes the token to the next process. 
- No chance of a deadlock as the process exits after passing the token.

## Problem 2
- I used simple bellman ford by dividing the edges between multiple processes. The implementation with divided vertices will be more efficient (similar to packet distribution type algorithm: https://pubsonline.informs.org/doi/10.1287/ijoc.1060.0195), but it has not been used here. The implementation will be very similar however, and can be easily converted because of the modular nature of the code written.
- Divided the edges beween the process.
- Each process does the edge relaxation step and sends the output back to the parent process (whose process ID has been passed while the process was spawned.)
- The parent process merges the distance list.
- This happens $V-1$ times, after which the output is printed.
- It is assumed that the graph is connected and edge weights are positive and integers. 
  - Integers because I was too lazy to change the input line to float :P
  - Connected and positive weights because of the inherent assumptions from the bellman ford algorithm.
- Complexity is $O(\frac{NM}{P} + NP)$.

