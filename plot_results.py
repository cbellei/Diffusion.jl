import matplotlib.pyplot as plt
import pandas as pd
import numpy as np

fname = "src/reference_8x4_output.dat"
dataJulia = pd.read_csv(fname, sep='\t', header=None).values[0]
print(len(dataJulia))

nx = 256
ny = 256

dataJulia = dataJulia.reshape(nx + 2, ny + 2)
print(dataJulia)
plt.imshow(dataJulia, interpolation='none')
plt.colorbar()
plt.show()


# fname = "/Users/admin-bellei/GoogleDrive/DataScience/Heat2D_MPI_Solving_F90/outputPar.dat"
# dataFortran = pd.read_csv(fname, sep=',', header=None).values[0]
#
# dataFortran = dataFortran.reshape(ny, nx).T
# diff = dataJulia - dataFortran
#
# plt.imshow(diff)
# plt.colorbar()
# plt.clim(-1.e-16, 1.e-16)
# plt.show()