using Printf

function write_to_disk(x::Array{Float64,1}, x_domains::Int, y_domains::Int,
                        xcell::Int, ycell::Int, filename:: String)
    f = open(filename, "w")
    c = 0
    for k=1:x_domains
        for m=1:xcell
            for i=1:y_domains
                for j=1:ycell
                    c += 1
                    print(f, @sprintf("%15.11f", x[(i-1) * x_domains * xcell * ycell +
                                         (k-1) * xcell * ycell + (j-1) * xcell + m]))
                    if (c < y_domains * x_domains * xcell * ycell)
                        print(f, "\t")
                    end
                end
            end
        end
    end
    close(f)
end

