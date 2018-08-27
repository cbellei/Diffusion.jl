function oneDArray(t::DataType, len::Int)
    return zeros(t, len)
end

function twoDArray(len_x::Int, len_y::Int)
    return zeros(Float64, len_x, len_y)
end