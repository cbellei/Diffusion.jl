import YAML

function get_sim_params()
    path = "./runs/run01/run01.yml"

    data = YAML.load(open("src/params.yml"))

    key = "grid"
    Nx = data[key]["nx"]
    Ny = data[key]["ny"]

    key = "numerics"
    NPROCX = data[key]["nprocx"]
    NPROCY = data[key]["nprocy"]
    MAX_STEPS = data[key]["max_steps"]
    Dt = data[key]["dt"]
    TOL = data[key]["tol"]

    return Int64[Nx, Ny, NPROCX, NPROCY, MAX_STEPS], Float64[Dt, TOL]
end