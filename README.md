# Diffusion

## Running simulation
If you want to find a simulation with a number of processes equal to
`nproc`, and with parameters contained
in the file with path `src/example.yml`, you can type on the Terminal
```
mpirun -np nproc src/diffusion.jl src/example.yml
```
## Running tests
There are both "end-to-end" tests and ...
```
julia test/runtests.jl
```
