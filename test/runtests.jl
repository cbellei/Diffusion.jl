using Test
using DelimitedFiles

reference_8x4_output = readdlm("test/resources/reference_8x4_output.dat")

# write your own tests here


@testset "All tests" begin

    @testset "1 process, 8x4 grid" begin
        cmd = `mpirun -np 1 julia src/Heat2D.jl test/resources/test1_params.yml`
        run(cmd)
        expected = reference_8x4_output
        actual = readdlm("test/resources/test1.dat")
        @test all(actual .≈ expected)
    end;

    @testset "1 process, 4x8 grid" begin
        cmd = `mpirun -np 1 julia src/Heat2D.jl test/resources/test2_params.yml`
        run(cmd)
        nx = 4
        ny = 8
        expected = transpose(reshape(reference_8x4_output, nx + 2, ny + 2))
        actual = reshape(readdlm("test/resources/test2.dat"), ny + 2, nx + 2)
        @test all(actual .≈ expected)
    end;

    @testset "2x1 processes, 8x4 grid" begin
        cmd = `mpirun -np 2 julia src/Heat2D.jl test/resources/test3_params.yml`
        run(cmd)
        expected = reference_8x4_output
        actual = readdlm("test/resources/test3.dat")
        @test all(actual .≈ expected)
    end;

    @testset "2x1 processes, 4x8 grid" begin
        cmd = `mpirun -np 2 julia src/Heat2D.jl test/resources/test4_params.yml`
        run(cmd)
        nx = 4
        ny = 8
        expected = transpose(reshape(reference_8x4_output, nx + 2, ny + 2))
        actual = reshape(readdlm("test/resources/test4.dat"), ny + 2, nx + 2)
        @test all(actual .≈ expected)
    end;

    @testset "1x2 processes, 8x4 grid" begin
        cmd = `mpirun -np 2 julia src/Heat2D.jl test/resources/test5_params.yml`
        run(cmd)
        expected = reference_8x4_output
        actual = readdlm("test/resources/test5.dat")
        @test all(actual .≈ expected)
    end;

    @testset "1x2 processes, 4x8 grid" begin
        cmd = `mpirun -np 2 julia src/Heat2D.jl test/resources/test6_params.yml`
        run(cmd)
        nx = 4
        ny = 8
        expected = transpose(reshape(reference_8x4_output, nx + 2, ny + 2))
        actual = reshape(readdlm("test/resources/test6.dat"), ny + 2, nx + 2)
        @test all(actual .≈ expected)
    end;

end;