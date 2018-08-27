function updateBound!(x::Array{Float64,2}, size_total_x, size_total_y, neighbors, comm,
                       me, xs, ys, xe, ye, xcell, ycell, nproc)

    mep1 = me + 1

    #assume, to start with, that this process is not going to receive anything
    rreq = Dict{String, MPI.Request}(
                                "N" => MPI.REQUEST_NULL,
                                "S" => MPI.REQUEST_NULL,
                                "E" => MPI.REQUEST_NULL,
                                "W" => MPI.REQUEST_NULL
                                )
    recv = Dict{String, Array{Float64,1}}()
    ghost_boundaries = Dict{String, Any}(
                                "N" => (xe[mep1]+1, ys[mep1]:ye[mep1]),
                                "S" => (xs[mep1]-1, ys[mep1]:ye[mep1]),
                                "E" => (xs[mep1]:xe[mep1], ye[mep1]+1),
                                "W" => (xs[mep1]:xe[mep1], ys[mep1]-1)
                                )
    is_receiving = Dict{String, Bool}("N" => false, "S" => false, "E" => false, "W" => false)

    #send
    neighbors["N"] >=0 && MPI.Isend(x[xe[mep1], ys[mep1]:ye[mep1]], neighbors["N"], me + 40, comm)
    neighbors["S"] >=0 && MPI.Isend(x[xs[mep1], ys[mep1]:ye[mep1]], neighbors["S"], me + 50, comm)
    neighbors["E"] >=0 && MPI.Isend(x[xs[mep1]:xe[mep1], ye[mep1]], neighbors["E"], me + 60, comm)
    neighbors["W"] >=0 && MPI.Isend(x[xs[mep1]:xe[mep1], ys[mep1]], neighbors["W"], me + 70, comm)

    #receive
    if (neighbors["N"] >= 0)
        recv["N"] = Array{Float64,1}(undef, ycell)
        is_receiving["N"] = true
        rreq["N"] = MPI.Irecv!(recv["N"], neighbors["N"], neighbors["N"] + 50, comm)
    end
    if (neighbors["S"] >= 0)
        recv["S"] = Array{Float64,1}(undef, ycell)
        is_receiving["S"] = true
        rreq["S"] = MPI.Irecv!(recv["S"], neighbors["S"], neighbors["S"] + 40, comm)
    end
    if (neighbors["E"] >= 0)
        recv["E"] = Array{Float64,1}(undef, xcell)
        is_receiving["E"] = true
        rreq["E"] = MPI.Irecv!(recv["E"], neighbors["E"], neighbors["E"] + 70, comm)
    end
    if (neighbors["W"] >= 0)
        recv["W"] = Array{Float64,1}(undef, xcell)
        is_receiving["W"] = true
        rreq["W"] = MPI.Irecv!(recv["W"], neighbors["W"], neighbors["W"] + 60, comm)
    end

    MPI.Waitall!([rreq[k] for k in keys(rreq)])
    for (k, v) in is_receiving
        if v
            x[ghost_boundaries[k][1], ghost_boundaries[k][2]] = recv[k]
        end
    end
end


function computeNext!(x0::Array{Float64,2}, x::Array{Float64,2},
    size_total_x::Int, size_total_y::Int, dt::Float64, hx::Float64, hy::Float64,
    me::Int, xs::Array{Int,1}, ys::Array{Int,1}, xe::Array{Int,1}, ye::Array{Int,1},
    nproc::Int, k0::Float64)

    # The stencil of the explicit operator for the heat equation
    # on a regular rectangular grid using a five point finite difference
    # scheme in space is :
    #
    # |                                    weightx * x[i-1][j]                                    |
    # |                                                                                           |
    # | weighty * x[i][j-1]   (diagx * weightx + diagy * weighty) * x[i][j]   weighty * x[i][j+1] |
    # |                                                                                           |
    # |                                    weightx * x[i+1][j]                                    |


    me += 1

    diagx = Float64(-2.0 + hx * hx / (2 * k0 * dt))
    diagy = Float64(-2.0 + hy * hy / (2 * k0 * dt))
    weightx = Float64(k0 * dt / (hx * hx))
    weighty = Float64(k0 * dt / (hy * hy))

    #Perform an explicit update on the points within the domain.
    #Optimization : inner loop on column index (second index) since
    #Julia is row major
    diff = 0.0
    for i = xs[me]:xe[me]
        for j = ys[me]:ye[me]
            x[i,j] = weightx * (x0[i-1,j] + x0[i+1,j] + x0[i,j]*diagx) +
                weighty * (x0[i,j-1] + x0[i,j+1] + x0[i,j]*diagy)
        end
    end

#     if (me-1==1)
#         println(xs[me], " ", xe[me], " ", ys[me], " " , ye[me])
#         println(x0[8,:])
#         println(x0[9,:])
#         println(x0[9,:])
#         println()
#         println(x[9,:])
#     end

   #Compute the difference into domain for convergence.
   #Update the value x0(i,j).
   #Optimization : inner loop on column index (second index) since
   #Julia is row major
   diff = 0.0
   for j = ys[me]:ye[me]
     for i = xs[me]:xe[me]
        ldiff = x0[i,j] - x[i,j]
        diff = diff + ldiff * ldiff
        x0[i,j] = x[i,j]
     end
   end

   return diff
end