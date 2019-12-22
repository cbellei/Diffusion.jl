# Diffusion.jl

Diffusion.jl is a Julia package that solves the diffusion equation on a two-dimensional Cartesian domain, using
the Message Passing Interface (MPI) paradigm. For more information, please have a look at 
<a href="http://www.claudiobellei.com/2018/09/30/julia-mpi/">this blog post</a>.

## Installation
In your target folder, clone the repository with the command:
```git clone https://github.com/cbellei/Diffusion.jl.git```

## Dependencies
Diffusion.jl is tested on Julia 1.0. It assumes that an MPI installation (for example, Open MPI) is available on the system
and that the Julia package MPI.jl has been installed.

## How to use Diffusion.jl

### Simulation parameters
The simulation parameters are all specified in a yaml file, as in `src/example.yml`. 
The parameters that are required are:
* number of cells in the x and y directions
* number of processors in the x and y direction
* maximum number of steps for the simulation
* time step dt
* criterion for terminating the simulation (if the solution changes by less than the `tol` value, the simulation is ended)
* name of the output file

### Running
If you want to run a simulation with a number of processes equal to `nproc`, and the simulation parameters are
contained in the file `src/example.yml`, then you should type on the Terminal
```
mpirun -np nproc julia src/diffusion.jl src/example.yml
```

### Running tests
All tests can be run from the Terminal, using the command 
```
julia test/runtests.jl
```
