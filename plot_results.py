import matplotlib.pyplot as plt
import pandas as pd

fname = "outputJulia.dat"
dataJulia = pd.read_csv(fname, sep='\t', header=None).values[0]
print(len(dataJulia))

nx = 256

dataJulia = dataJulia.reshape(nx, nx)
plt.imshow(dataJulia, interpolation='none')
plt.colorbar()
plt.show()


fname = "/Users/admin-bellei/GoogleDrive/DataScience/Heat2D_MPI_Solving_F90/outputPar.dat"
dataFortran = pd.read_csv(fname, sep=',', header=None).values[0]

print(len(dataFortran))
nx = 256

dataFortran = dataFortran.reshape(256, 256)
diff = dataJulia - dataFortran

plt.imshow(diff)
plt.colorbar()
plt.clim(-1.e-5, 1.e-5)
plt.show()